import 'package:client/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Claude palette', () {
    test('accent is clay orange, bg near-black', () {
      expect(ClaudePalette.accent, const Color(0xFFD97757));
      expect(ClaudePalette.bg, const Color(0xFF0D0D0D));
      expect(ClaudePalette.surface, const Color(0xFF1A1A1A));
      expect(ClaudePalette.text, const Color(0xFFE8E4DF));
    });

    test('ThemeData primary matches Claude accent (not teal)', () {
      final theme = AppThemes.claude();
      expect(theme.colorScheme.primary, ClaudePalette.accent);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, ClaudePalette.bg);
      final herdr = theme.extension<HerdrColors>()!;
      expect(herdr.statusIdle, const Color(0xFF6B9B76));
      expect(herdr.statusWorking, ClaudePalette.accent);
      expect(herdr.terminalBg, const Color(0xFF0D0D0D));
    });
  });

  group('AppThemeId', () {
    test('defaults unknown storage to claude', () {
      expect(AppThemeIdX.fromStorage(null), AppThemeId.claude);
      expect(AppThemeIdX.fromStorage(''), AppThemeId.claude);
      expect(AppThemeIdX.fromStorage('teal'), AppThemeId.teal);
      expect(AppThemeIdX.fromStorage('claude'), AppThemeId.claude);
    });
  });

  testWidgets('Claude theme pumps MaterialApp without teal seed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.claude(),
        home: Builder(
          builder: (context) {
            final scheme = Theme.of(context).colorScheme;
            return Scaffold(
              appBar: AppBar(title: const Text('t')),
              body: Text('${scheme.primary.toARGB32()}'),
              bottomNavigationBar: NavigationBar(
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'a'),
                  NavigationDestination(icon: Icon(Icons.settings), label: 'b'),
                ],
                selectedIndex: 0,
                onDestinationSelected: (_) {},
              ),
            );
          },
        ),
      ),
    );
    expect(find.text('t'), findsOneWidget);
    final primary = Theme.of(tester.element(find.text('t'))).colorScheme.primary;
    expect(primary, ClaudePalette.accent);
  });
}
