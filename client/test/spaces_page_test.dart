import 'package:client/models/pair_config.dart';
import 'package:client/models/relay_agent.dart';
import 'package:client/models/relay_event.dart';
import 'package:client/models/relay_session.dart';
import 'package:client/pages/agent_page.dart';
import 'package:client/pages/run_page.dart';
import 'package:client/pages/spaces_page.dart';
import 'package:flutter/material.dart';
import 'package:client/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_relay_client.dart';
import 'test_helper.dart';

/// Spaces tab (workspace list → panes → terminal) and Run tab (start agent).
void main() {
  final config = PairConfig(
    host: '192.168.1.5',
    port: 8375,
    mode: 'lan',
    token: '0123456789abcdef0123456789abcdef',
  );

  final session = RelaySession(
    workspaces: const [
      RelayWorkspace(id: 'wH', label: 'herdr_relay', status: 'working', paneCount: 2),
      RelayWorkspace(id: 'w7', label: 'awake', status: 'idle', paneCount: 1),
    ],
    panes: const [
      RelayPane(
        id: 'wH:p8',
        workspaceId: 'wH',
        tabId: 'wH:t1',
        agent: 'kimi',
        status: 'working',
        cwd: '/home/u/cc',
        tabLabel: 'test',
      ),
      RelayPane(
        id: 'wH:p9',
        workspaceId: 'wH',
        tabId: 'wH:t1',
        agent: '',
        status: 'unknown',
      ),
      RelayPane(
        id: 'w7:p1',
        workspaceId: 'w7',
        tabId: 'w7:t1',
        agent: '',
        status: 'unknown',
      ),
    ],
    focusedWorkspaceId: 'wH',
  );

  late FakeRelayClient client;

  setUp(() async {
    client = FakeRelayClient();
    client.sessionData = session;
    await setupTestDependencies(client, config);
  });

  tearDown(teardownTestDependencies);

  group('SpacesPage', () {
    testWidgets('показывает workspace из session', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: SpacesPage())),
      );
      await tester.pumpAndSettle();

      expect(find.text('herdr_relay'), findsOneWidget);
      expect(find.text('awake'), findsOneWidget);
      expect(find.textContaining('2 pane'), findsOneWidget);
    });

    testWidgets('тап по workspace открывает его panes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: SpacesPage())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('herdr_relay'));
      await tester.pumpAndSettle();

      // WorkspacePage: primary is Herdr tab title (tab_label).
      expect(find.text('test'), findsOneWidget);
      expect(find.text('kimi · working'), findsOneWidget);
      expect(find.text('wH:p9'), findsOneWidget);
      // The other workspace's pane is not listed.
      expect(find.text('w7:p1'), findsNothing);
    });

    testWidgets('тап по pane открывает терминал AgentPage', (tester) async {
      client.outputText = 'hello\n';
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: SpacesPage())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('herdr_relay'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('test'));
      await tester.pumpAndSettle();

      expect(find.byType(AgentPage), findsOneWidget);
    });
  });

  group('RunPage', () {
    testWidgets('запускает агента в свободный pane выбранного workspace',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: RunPage())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'Agent name'), 'my-codex');
      await tester.tap(find.text('Start agent'));
      await tester.pumpAndSettle();

      expect(client.startAgentCalls, [( 'my-codex', 'codex', 'wH:p9')]);
    });

    testWidgets('без свободного pane создаёт tab и стартует', (tester) async {
      // All panes have agents — Run should create a tab then start.
      client.sessionData = const RelaySession(
        workspaces: [
          RelayWorkspace(id: 'wH', label: 'herdr_relay'),
        ],
        panes: [
          RelayPane(id: 'wH:p8', workspaceId: 'wH', tabId: 'wH:t1', agent: 'kimi'),
        ],
      );
      client.newTabPaneId = 'wH:pNew';
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: RunPage())),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('create a new tab'), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextField, 'Agent name'), 'phone-bot');
      await tester.tap(find.text('Start agent'));
      await tester.pumpAndSettle();

      expect(client.createTabCalls, [('wH', 'phone-bot', null)]);
      expect(client.startAgentCalls, [('phone-bot', 'codex', 'wH:pNew')]);
    });
  });

  testWidgets('статус-событие обновляет статус воркспейса живьём, без session-перечита',
      (tester) async {
    // Workspace statuses now come from AgentsStore (aggregated from agent
    // statuses); the session only supplies the workspace/pane structure.
    client.agents = [
      RelayAgent.fromJson({
        'pane_id': 'wH:p8',
        'agent': 'kimi',
        'agent_status': 'working',
        'workspace_id': 'wH',
      }),
    ];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: SpacesPage())),
    );
    await tester.pumpAndSettle();

    // Workspace wH chip shows the aggregated status from the store.
    expect(find.text('working'), findsOneWidget);

    final before = client.sessionCalls;
    client.emit(AgentStatusChanged(
      paneId: 'wH:p8',
      status: 'blocked',
      workspaceId: 'wH',
    ));
    await tester.pumpAndSettle();

    // Status applied live from the store — no session re-read.
    expect(find.text('blocked'), findsOneWidget);
    expect(find.text('working'), findsNothing);
    expect(client.sessionCalls, before,
        reason: 'status events must not re-read the session');
  });

  testWidgets('pane.updated перечитывает session (структурные изменения)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: SpacesPage())),
    );
    await tester.pumpAndSettle();
    final before = client.sessionCalls;

    client.emit(const PaneUpdated(paneId: 'wH:p9'));
    // SessionController (registered in setUp, outside the fake-async test
    // zone) debounces on the real clock — advance real time, then settle.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 400)),
    );
    await tester.pumpAndSettle();

    expect(client.sessionCalls, greaterThan(before),
        reason: 'pane.updated must re-read the session');
  });
}
