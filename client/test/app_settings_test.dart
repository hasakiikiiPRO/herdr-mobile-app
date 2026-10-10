import 'package:client/services/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<AppSettings> fresh() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(prefs);
  }

  group('AppSettings: defaults', () {
    test('новые настройки отдают дефолты', () async {
      final s = await fresh();
      expect(s.homeTabIndex, 0);
      expect(s.terminalFontSize, AppSettings.kDefaultFontSize);
      expect(s.autoScrollFollow, isTrue);
      expect(s.notificationsEnabled, isTrue);
      expect(s.agentSnapshot, isNull);
      expect(s.agentSnapshotAt, isNull);
      expect(s.sessionSnapshot, isNull);
      expect(s.sessionSnapshotAt, isNull);
      expect(s.sessionSnapshotProfile, isNull);
      expect(s.lastWorkspaceId, isNull);
    });
  });

  group('AppSettings: round-trip', () {
    test('homeTabIndex сохраняется и переживает новый инстанс', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      AppSettings(prefs).setHomeTabIndex(1);
      expect(AppSettings(prefs).homeTabIndex, 1);
    });

    test('terminalFontSize сохраняется, за границами клампится', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      AppSettings(prefs).setTerminalFontSize(15);
      expect(AppSettings(prefs).terminalFontSize, 15);

      AppSettings(prefs).setTerminalFontSize(4); // below the floor
      expect(AppSettings(prefs).terminalFontSize, AppSettings.kMinFontSize);

      AppSettings(prefs).setTerminalFontSize(99); // above the ceiling
      expect(AppSettings(prefs).terminalFontSize, AppSettings.kMaxFontSize);
    });

    test('autoScrollFollow сохраняется', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      AppSettings(prefs).setAutoScrollFollow(false);
      expect(AppSettings(prefs).autoScrollFollow, isFalse);
    });

    test('notificationsEnabled сохраняется (дефолт включён)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(AppSettings(prefs).notificationsEnabled, isTrue);
      AppSettings(prefs).setNotificationsEnabled(false);
      expect(AppSettings(prefs).notificationsEnabled, isFalse);
      AppSettings(prefs).setNotificationsEnabled(true);
      expect(AppSettings(prefs).notificationsEnabled, isTrue);
    });

    test('agent snapshot cache сохраняется', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      AppSettings(prefs)
        ..setAgentSnapshot('[{"pane_id":"p1"}]')
        ..setAgentSnapshotAt('2026-08-30T12:00:00.000');
      final read = AppSettings(prefs);
      expect(read.agentSnapshot, '[{"pane_id":"p1"}]');
      expect(read.agentSnapshotAt, '2026-08-30T12:00:00.000');
    });
  });
}

group('AppSettings: session snapshot cache', () {
  test('session snapshot + profile + workspace round-trip', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    AppSettings(prefs)
      ..setSessionSnapshot('{"workspaces":[],"panes":[]}')
      ..setSessionSnapshotAt('2026-10-10T12:00:00.000')
      ..setSessionSnapshotProfile('relay-abc')
      ..setLastWorkspaceId('wH');
    final read = AppSettings(prefs);
    expect(read.sessionSnapshot, '{"workspaces":[],"panes":[]}');
    expect(read.sessionSnapshotAt, '2026-10-10T12:00:00.000');
    expect(read.sessionSnapshotProfile, 'relay-abc');
    expect(read.lastWorkspaceId, 'wH');

    AppSettings(prefs).clearSessionSnapshot();
    final cleared = AppSettings(prefs);
    expect(cleared.sessionSnapshot, isNull);
    expect(cleared.sessionSnapshotAt, isNull);
    expect(cleared.sessionSnapshotProfile, isNull);
    expect(cleared.lastWorkspaceId, isNull);
  });
});
