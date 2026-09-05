import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/material.dart' show Brightness, ColorScheme;
import 'package:flutter/painting.dart';

/// Every colour the app is allowed to paint with.
///
/// Widgets never hardcode a colour: they read a role from here (`brand`,
/// `danger`, `onSurfaceMuted`, ...) so light/dark and the four brands all work
/// for free.
class DSColors {
  const DSColors({
    required this.brightness,
    required this.brand,
    required this.onBrand,
    required this.brandSubtle,
    required this.onBrandSubtle,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceSunken,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.separator,
    required this.border,
    required this.danger,
    required this.onDanger,
    required this.dangerSubtle,
    required this.success,
    required this.warning,
    required this.info,
    required this.scrim,
    required this.shadow,
    required this.materialScheme,
  });

  /// Generates the palette from a single brand colour.
  ///
  /// Material takes its greys from the generated [ColorScheme]; Cupertino uses
  /// Apple's system greys instead, so an iOS build looks like an iOS app.
  factory DSColors.fromSeed({
    required Color seed,
    required Brightness brightness,
    required DesignLanguage language,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;

    Color byLanguage({
      required Color material,
      required Color cupertinoLight,
      required Color cupertinoDark,
    }) {
      if (!language.isCupertino) return material;
      return isDark ? cupertinoDark : cupertinoLight;
    }

    return DSColors(
      brightness: brightness,
      brand: scheme.primary,
      onBrand: scheme.onPrimary,
      brandSubtle: scheme.primaryContainer,
      onBrandSubtle: scheme.onPrimaryContainer,
      surface: byLanguage(
        material: scheme.surface,
        cupertinoLight: const Color(0xFFF2F2F7),
        cupertinoDark: const Color(0xFF000000),
      ),
      surfaceElevated: byLanguage(
        material: scheme.surfaceContainerLow,
        cupertinoLight: const Color(0xFFFFFFFF),
        cupertinoDark: const Color(0xFF1C1C1E),
      ),
      surfaceSunken: byLanguage(
        material: scheme.surfaceContainerHighest,
        cupertinoLight: const Color(0xFFE5E5EA),
        cupertinoDark: const Color(0xFF1C1C1E),
      ),
      onSurface: byLanguage(
        material: scheme.onSurface,
        cupertinoLight: const Color(0xFF000000),
        cupertinoDark: const Color(0xFFFFFFFF),
      ),
      onSurfaceMuted: byLanguage(
        material: scheme.onSurfaceVariant,
        cupertinoLight: const Color(0xFF6C6C70),
        cupertinoDark: const Color(0xFFAEAEB2),
      ),
      separator: byLanguage(
        material: scheme.outlineVariant,
        cupertinoLight: const Color(0x5C3C3C43),
        cupertinoDark: const Color(0x99545458),
      ),
      border: byLanguage(
        material: scheme.outline,
        cupertinoLight: const Color(0xFFC6C6C8),
        cupertinoDark: const Color(0xFF48484A),
      ),
      danger: scheme.error,
      onDanger: scheme.onError,
      dangerSubtle: scheme.errorContainer,
      success: isDark ? const Color(0xFF4ADE80) : const Color(0xFF14804A),
      warning: isDark ? const Color(0xFFFBBF24) : const Color(0xFF9A6300),
      info: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
      scrim: isDark ? const Color(0x99000000) : const Color(0x66000000),
      shadow: const Color(0xFF000000),
      materialScheme: scheme,
    );
  }

  final Brightness brightness;
  final Color brand;
  final Color onBrand;
  final Color brandSubtle;
  final Color onBrandSubtle;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceSunken;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color separator;
  final Color border;
  final Color danger;
  final Color onDanger;
  final Color dangerSubtle;
  final Color success;
  final Color warning;
  final Color info;
  final Color scrim;
  final Color shadow;

  /// Kept so the Material theme can be built from the same seed.
  final ColorScheme materialScheme;

  /// The roles listed on the Foundations page.
  Map<String, Color> get catalogue => {
    'brand': brand,
    'onBrand': onBrand,
    'brandSubtle': brandSubtle,
    'onBrandSubtle': onBrandSubtle,
    'surface': surface,
    'surfaceElevated': surfaceElevated,
    'surfaceSunken': surfaceSunken,
    'onSurface': onSurface,
    'onSurfaceMuted': onSurfaceMuted,
    'separator': separator,
    'border': border,
    'danger': danger,
    'dangerSubtle': dangerSubtle,
    'success': success,
    'warning': warning,
    'info': info,
  };
}
