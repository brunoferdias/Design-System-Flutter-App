import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ColorScheme;
import 'package:flutter/painting.dart';

@immutable
final class DSColors {
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

  factory DSColors.fromSeed({
    required Color seed,
    required Brightness brightness,
    required DesignLanguage language,
  }) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final bool isDark = brightness == Brightness.dark;
    final bool isCupertino = language.isCupertino;

    return DSColors(
      brightness: brightness,
      brand: scheme.primary,
      onBrand: scheme.onPrimary,
      brandSubtle: scheme.primaryContainer,
      onBrandSubtle: scheme.onPrimaryContainer,
      surface: isCupertino
          ? (isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7))
          : scheme.surface,
      surfaceElevated: isCupertino
          ? (isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF))
          : scheme.surfaceContainerLow,
      surfaceSunken: isCupertino
          ? (isDark ? const Color(0xFF1C1C1E) : const Color(0xFFE5E5EA))
          : scheme.surfaceContainerHighest,
      onSurface: isCupertino
          ? (isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000))
          : scheme.onSurface,
      onSurfaceMuted: isCupertino
          ? (isDark ? const Color(0xFFAEAEB2) : const Color(0xFF6C6C70))
          : scheme.onSurfaceVariant,
      separator: isCupertino
          ? (isDark ? const Color(0x99545458) : const Color(0x5C3C3C43))
          : scheme.outlineVariant,
      border: isCupertino
          ? (isDark ? const Color(0xFF48484A) : const Color(0xFFC6C6C8))
          : scheme.outline,
      danger: scheme.error,
      onDanger: scheme.onError,
      dangerSubtle: scheme.errorContainer,
      success: isDark ? const Color(0xFF4ADE80) : const Color(0xFF14804A),
      warning: isDark ? const Color(0xFFFBBF24) : const Color(0xFF9A6300),
      info: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8),
      scrim: Color(isDark ? 0x99000000 : 0x66000000),
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
  final ColorScheme materialScheme;

  Map<String, Color> get catalogue => <String, Color>{
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
