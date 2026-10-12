import 'package:client/core/service_locator.dart';
import 'package:client/models/pair_config.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/controllers/modes_controller.dart';
import 'package:client/core/connection/mode_service.dart';
import 'package:client/services/config_store.dart';
import 'package:client/services/relay_client.dart';
import 'package:client/widgets/device_switcher_bar.dart';
import 'package:flutter/material.dart';
import 'package:client/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_relay_client.dart';
import 'test_helper.dart';

void main() {
  final linux = PairConfig(
    host: '10.126.126.1',
    port: 8375,
    mode: 'lan',
    token: '0123456789abcdef0123456789abcdef',
    relayId: 'linux-id',
    name: 'hasakiikii',
  );
  final windows = PairConfig(
    host: '10.126.126.3',
    port: 8375,
    mode: 'lan',
    token: 'fedcba9876543210fedcba9876543210',
    relayId: 'windows-id',
    name: 'hasakiikiiPRO',
  );

  late FakeRelayClient client;

  setUp(() async {
    client = FakeRelayClient();
    await setupTestDependencies(client, linux);
    final store = getIt<ConfigStore>();
    await store.saveProfile(linux);
    await store.saveProfile(windows);
    // saveProfile makes the last one active; restore linux as active for tests.
    await store.setActive(linux.profileKey);
  });

  tearDown(() async {
    await teardownTestDependencies();
  });

  testWidgets('bar lists every saved device and AppBar shows active name',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: HomePage(
          config: linux,
          onRequestSwitch: () async {},
          onAddDevice: () async {},
          onForgetDevice: () async {},
          onModeSelected: (_) async {},
          onSwitchDevice: (_) async {},
          reachabilityProbe: (_) async => true,
          modesController: ModesController((_) async => const <RelayModeInfo>[]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DeviceSwitcherBar), findsOneWidget);
    expect(find.text('hasakiikii'), findsWidgets); // chip + AppBar
    expect(find.text('hasakiikiiPRO'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('tapping another device chip calls onSwitchDevice', (tester) async {
    PairConfig? switched;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: HomePage(
          config: linux,
          onRequestSwitch: () async {},
          onAddDevice: () async {},
          onForgetDevice: () async {},
          onModeSelected: (_) async {},
          onSwitchDevice: (c) async => switched = c,
          reachabilityProbe: (_) async => false,
          modesController: ModesController((_) async => const <RelayModeInfo>[]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('hasakiikiiPRO'));
    await tester.pumpAndSettle();

    expect(switched, isNotNull);
    expect(switched!.profileKey, windows.profileKey);
    expect(switched!.displayName, 'hasakiikiiPRO');
  });

  testWidgets('standalone bar highlights active and probes others', (tester) async {
    final status = ValueNotifier(RelayStatus.connected);
    final probed = <String>[];
    addTearDown(status.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: DeviceSwitcherBar(
            activeConfig: linux,
            activeStatus: status,
            onSwitch: (_) async {},
            reachabilityProbe: (c) async {
              probed.add(c.profileKey);
              return c.profileKey == windows.profileKey;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('hasakiikii'), findsOneWidget);
    expect(find.text('hasakiikiiPRO'), findsOneWidget);
    expect(probed, contains(windows.profileKey));
    expect(probed, isNot(contains(linux.profileKey)));
  });
}
