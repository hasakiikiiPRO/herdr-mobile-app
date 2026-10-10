import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/relay_session.dart';
import '../services/app_settings.dart';
import '../services/relay_client.dart';
import '../utils/async_value.dart';
import 'agents_store.dart';

/// Shared session state for the Spaces and Run tabs (a single `session.snapshot`
/// serves both — previously each page fetched it independently).
///
/// Owns the orchestration that used to live in the pages' State classes:
///   - loads the session (once) and reloads on demand;
///   - reconnect catch-up: after the relay drops, the session is re-read on the
///     next connected status (events during the gap were lost);
///   - live refresh: pane structure changes (agents' statuses now live in
///     [AgentsStore]) invalidate workspace/space statuses, so the session is
///     re-read debounced (300 ms) off [AgentsStore.structureRevision];
///   - a generation counter discards stale responses when refreshes overlap;
///   - stale-while-revalidate: the last successful snapshot is persisted per
///     profile so reopen/reconnect shows workspaces immediately (docs/15).
class SessionController extends ChangeNotifier {
  SessionController(
    this._client,
    this._store,
    this._settings, {
    required this.profileKey,
  }) {
    _client.status.addListener(_onConnectionStatus);
    _store.structureRevision.addListener(_onStructureChanged);
    // No eager load: [ensureLoaded] fetches on the first page that needs the
    // session (the Spaces tab is the default), so a session is never fetched
    // before anything shows it. Seed from disk so the first paint is instant.
    _hydrateFromCache();
  }

  final RelayClient _client;
  final AgentsStore _store;
  final AppSettings _settings;

  /// Active relay profile key — scopes the disk cache so switching devices
  /// never flashes another machine's workspaces.
  final String profileKey;

  Timer? _refreshDebounce;
  AsyncValue<RelaySession> _state = const AsyncIdle();
  int _generation = 0;

  /// True once the connection dropped: on the next connected status the
  /// session is re-read (reconnect catch-up).
  bool _wasDisconnected = false;

  /// JSON of the last cached snapshot — unchanged writes are skipped.
  String? _lastCachedJson;

  AsyncValue<RelaySession> get state => _state;

  /// Loads the session once (no-op once a load is in flight or done). Called
  /// by the Spaces and Run tabs on first build.
  void ensureLoaded() {
    if (_state is AsyncIdle<RelaySession>) {
      _load();
    } else if (_state is AsyncData<RelaySession> && _generation == 0) {
      // Hydrated from cache only — still need a fresh network fetch.
      _load();
    }
  }

  /// Reloads the session unconditionally (pull-to-refresh, Retry, after
  /// starting an agent in Run).
  Future<void> refresh() => _load();

  /// Starts an agent into the given free pane (`agent.start`), then refreshes
  /// the session so free-pane info and workspace statuses stay current.
  ///
  /// UI callers use this instead of reaching for `getIt<RelayClient>()`
  /// directly — the client stays owned by this controller.
  Future<void> startAgent(String name, String kind, String paneId) async {
    await _client.startAgent(name, kind, paneId);
    await refresh();
  }

  /// First free (agent-less) pane of [workspaceId], if any — the target for
  /// `agent.start` (docs/11-spaces.md §0.3).
  RelayPane? freePaneFor(String? workspaceId) {
    final session = _state.dataOrNull;
    if (session == null || workspaceId == null) return null;
    for (final pane in session.panes) {
      if (pane.workspaceId == workspaceId && !pane.isAgentPane) return pane;
    }
    return null;
  }

  void _hydrateFromCache() {
    final cached = _readCache();
    if (cached == null) return;
    _state = AsyncData(cached);
    // generation stays 0 so ensureLoaded still triggers a network refresh.
  }

  RelaySession? _readCache() {
    if (_settings.sessionSnapshotProfile != profileKey) return null;
    final raw = _settings.sessionSnapshot;
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final session = RelaySession.fromJson(json.cast<String, dynamic>());
      _lastCachedJson = raw;
      return session;
    } catch (_) {
      return null;
    }
  }

  void _writeCache(RelaySession session) {
    final json = jsonEncode(session.toJson());
    if (json == _lastCachedJson &&
        _settings.sessionSnapshotProfile == profileKey) {
      return;
    }
    _lastCachedJson = json;
    _settings.setSessionSnapshot(json);
    _settings.setSessionSnapshotAt(DateTime.now().toIso8601String());
    _settings.setSessionSnapshotProfile(profileKey);
    final wsId = session.focusedWorkspaceId ??
        (session.workspaces.isNotEmpty ? session.workspaces.first.id : null);
    if (wsId != null && wsId.isNotEmpty) {
      _settings.setLastWorkspaceId(wsId);
    }
  }

  void _onConnectionStatus() {
    final status = _client.status.value;
    if (status == RelayStatus.connected) {
      if (_wasDisconnected || _state.hasError) {
        _wasDisconnected = false;
        _load();
      }
    } else {
      _wasDisconnected = true;
      // Events received while offline are pointless; the reconnect catch-up
      // above re-reads the whole session.
      _refreshDebounce?.cancel();
    }
  }

  void _onStructureChanged() {
    if (_wasDisconnected) return;
    // A pane appeared/moved/vanished — the session snapshot may be stale.
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 300), () => _load());
  }

  Future<void> _load() async {
    final gen = ++_generation;
    // Keep showing cached / previous data while refreshing (SWR). Only flip
    // to loading when we have nothing useful to paint.
    if (_state is! AsyncData<RelaySession>) {
      _state = const AsyncLoading();
      notifyListeners();
    }
    try {
      final session = await _client.session();
      if (gen != _generation) return; // superseded by a newer load
      _writeCache(session);
      _state = AsyncData(session);
      notifyListeners();
    } catch (e) {
      if (gen != _generation) return;
      // Network error: keep showing cached data when available.
      if (_state is AsyncData<RelaySession>) {
        notifyListeners();
        return;
      }
      final cached = _readCache();
      if (cached != null) {
        _state = AsyncData(cached);
        notifyListeners();
        return;
      }
      _state = AsyncError(e);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _refreshDebounce?.cancel();
    _store.structureRevision.removeListener(_onStructureChanged);
    _client.status.removeListener(_onConnectionStatus);
    super.dispose();
  }
}
