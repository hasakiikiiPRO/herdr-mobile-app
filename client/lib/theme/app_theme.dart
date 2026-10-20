import 'package:flutter/material.dart';

/// Selectable app visual themes. Persisted as [AppSettings.themeId].
enum AppThemeId {
  /// Claude Code–inspired charcoal + clay orange (default).
  claude,

  /// Legacy Material teal seed (previous default).
  teal,
}

extension AppThemeIdX on AppThemeId {
  String get storageKey => name;

  static AppThemeId fromStorage(String? raw) {
    switch (raw) {
      case 'teal':
        return AppThemeId.teal;
      case 'claude':
      default:
        return AppThemeId.claude;
    }
  }
}

/// Extra semantic colors not covered well by [ColorScheme] alone
/// (status chips, terminal pane, transport mode badges).
@immutable
class HerdrColors extends ThemeExtension<HerdrColors> {
  const HerdrColors({
    required this.statusIdle,
    required this.statusWorking,
    required this.statusBlocked,
    required this.statusError,
    required this.statusUnknown,
    required this.terminalBg,
    required this.terminalFg,
    required this.modeLan,
    required this.modeTailscale,
    required this.modeFunnel,
  });

  final Color statusIdle;
  final Color statusWorking;
  final Color statusBlocked;
  final Color statusError;
  final Color statusUnknown;
  final Color terminalBg;
  final Color terminalFg;
  final Color modeLan;
  final Color modeTailscale;
  final Color modeFunnel;

  static HerdrColors of(BuildContext context) {
    return Theme.of(context).extension<HerdrColors>() ?? HerdrColors.claude;
  }

  /// Claude Code palette — muted greens, clay orange working, soft amber blocked.
  static const HerdrColors claude = HerdrColors(
    statusIdle: Color(0xFF6B9B76),
    statusWorking: Color(0xFFD97757),
    statusBlocked: Color(0xFFC4A35A),
    statusError: Color(0xFFC45C5C),
    statusUnknown: Color(0xFF8A8580),
    terminalBg: Color(0xFF0D0D0D),
    terminalFg: Color(0xFFE8E4DF),
    modeLan: Color(0xFF6B8CAE),
    modeTailscale: Color(0xFF9A7B9A),
    modeFunnel: Color(0xFFD97757),
  );

  /// Brighter Material-ish status colors for the legacy teal theme.
  static const HerdrColors teal = HerdrColors(
    statusIdle: Color(0xFF4CAF50),
    statusWorking: Color(0xFFFF9800),
    statusBlocked: Color(0xFFFFA000),
    statusError: Color(0xFFE53935),
    statusUnknown: Color(0xFF607D8B),
    terminalBg: Color(0xFF1E1E1E),
    terminalFg: Color(0xFFE0E0E0),
    modeLan: Color(0xFF2196F3),
    modeTailscale: Color(0xFF9C27B0),
    modeFunnel: Color(0xFFFF9800),
  );

  @override
  HerdrColors copyWith({
    Color? statusIdle,
    Color? statusWorking,
    Color? statusBlocked,
    Color? statusError,
    Color? statusUnknown,
    Color? terminalBg,
    Color? terminalFg,
    Color? modeLan,
    Color? modeTailscale,
    Color? modeFunnel,
  }) {
    return HerdrColors(
      statusIdle: statusIdle ?? this.statusIdle,
      statusWorking: statusWorking ?? this.statusWorking,
      statusBlocked: statusBlocked ?? this.statusBlocked,
      statusError: statusError ?? this.statusError,
      statusUnknown: statusUnknown ?? this.statusUnknown,
      terminalBg: terminalBg ?? this.terminalBg,
      terminalFg: terminalFg ?? this.terminalFg,
      modeLan: modeLan ?? this.modeLan,
      modeTailscale: modeTailscale ?? this.modeTailscale,
      modeFunnel: modeFunnel ?? this.modeFunnel,
    );
  }

  @override
  HerdrColors lerp(ThemeExtension<HerdrColors>? other, double t) {
    if (other is! HerdrColors) return this;
    return HerdrColors(
      statusIdle: Color.lerp(statusIdle, other.statusIdle, t)!,
      statusWorking: Color.lerp(statusWorking, other.statusWorking, t)!,
      statusBlocked: Color.lerp(statusBlocked, other.statusBlocked, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusUnknown: Color.lerp(statusUnknown, other.statusUnknown, t)!,
      terminalBg: Color.lerp(terminalBg, other.terminalBg, t)!,
      terminalFg: Color.lerp(terminalFg, other.terminalFg, t)!,
      modeLan: Color.lerp(modeLan, other.modeLan, t)!,
      modeTailscale: Color.lerp(modeTailscale, other.modeTailscale, t)!,
      modeFunnel: Color.lerp(modeFunnel, other.modeFunnel, t)!,
    );
  }
}

/// Hex tokens for the Claude Code look (documented in THEME.md).
abstract final class ClaudePalette {
  static const Color bg = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceHigh = Color(0xFF242424);
  static const Color surfaceHighest = Color(0xFF2C2C2C);
  static const Color surfaceLow = Color(0xFF141414);
  static const Color accent = Color(0xFFD97757); // clay / coral orange
  static const Color onAccent = Color(0xFF1A1A1A);
  static const Color text = Color(0xFFE8E4DF);
  static const Color textMuted = Color(0xFFA8A29E);
  static const Color outline = Color(0xFF3A3A3A);
  static const Color outlineVariant = Color(0xFF2A2A2A);
  static const Color error = Color(0xFFC45C5C);
  static const Color onError = Color(0xFFFFF5F5);
  static const Color secondary = Color(0xFF8A8580);
  static const Color tertiary = Color(0xFFC4A35A);
}

/// Builds [ThemeData] for a given [AppThemeId].
abstract final class AppThemes {
  static ThemeData forId(AppThemeId id) => switch (id) {
        AppThemeId.claude => claude(),
        AppThemeId.teal => teal(),
      };

  /// Claude Code–inspired dark theme (default).
  static ThemeData claude() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ClaudePalette.accent,
      onPrimary: ClaudePalette.onAccent,
      primaryContainer: Color(0xFF3D2A22),
      onPrimaryContainer: Color(0xFFF2D6C9),
      secondary: ClaudePalette.secondary,
      onSecondary: ClaudePalette.bg,
      secondaryContainer: Color(0xFF2A2826),
      onSecondaryContainer: ClaudePalette.textMuted,
      tertiary: ClaudePalette.tertiary,
      onTertiary: ClaudePalette.bg,
      tertiaryContainer: Color(0xFF3A3220),
      onTertiaryContainer: Color(0xFFF0E6C8),
      error: ClaudePalette.error,
      onError: ClaudePalette.onError,
      errorContainer: Color(0xFF3A1F1F),
      onErrorContainer: Color(0xFFF5D0D0),
      surface: ClaudePalette.surface,
      onSurface: ClaudePalette.text,
      surfaceDim: ClaudePalette.bg,
      surfaceBright: ClaudePalette.surfaceHigh,
      surfaceContainerLowest: ClaudePalette.bg,
      surfaceContainerLow: ClaudePalette.surfaceLow,
      surfaceContainer: ClaudePalette.surface,
      surfaceContainerHigh: ClaudePalette.surfaceHigh,
      surfaceContainerHighest: ClaudePalette.surfaceHighest,
      onSurfaceVariant: ClaudePalette.textMuted,
      outline: ClaudePalette.outline,
      outlineVariant: ClaudePalette.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: ClaudePalette.text,
      onInverseSurface: ClaudePalette.bg,
      inversePrimary: Color(0xFF8B4A35),
    );

    return _base(
      scheme: scheme,
      extras: HerdrColors.claude,
      chipRadius: 8,
    );
  }

  /// Previous teal seed theme (kept as a selectable fallback).
  static ThemeData teal() {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    );
    return _base(
      scheme: scheme,
      extras: HerdrColors.teal,
      chipRadius: 12,
    );
  }

  static ThemeData _base({
    required ColorScheme scheme,
    required HerdrColors extras,
    required double chipRadius,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      extensions: [extras],
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.surfaceContainer,
        labelStyle: TextStyle(color: scheme.onSurface, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimaryContainer),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(chipRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        showCheckmark: false,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(color: scheme.onSurface),
        actionTextColor: scheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.outlineVariant,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
        inactiveTrackColor: scheme.outlineVariant,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primaryContainer;
          }
          return scheme.surfaceContainerHighest;
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
    );
  }
}
