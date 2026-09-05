import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ColorScheme;
import 'package:flutter/painting.dart';

/// Semantic colour roles.
///
/// Components never name a colour ("blue", "grey 200"); they name a *role*
/// ("brand", "surfaceElevated", "danger"). That indirection is what lets the
/// same widget tree render correctly in light, dark, Material and Cupertino
/// without a single conditional inside the component itself.
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

  /// Derives every role from a single [seed], honouring the conventions of the
  /// requested [language].
  ///
  /// Material roles come straight from the Material 3 tonal palette algorithm,
  /// which guarantees the contrast ratios. Cupertino then overrides the handful
  /// of roles where Apple's system colours are meaningfully different — grouped
  /// backgrounds and hairline separators — while keeping the brand-derived
  /// accents so the app still looks like itself on both platforms.
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

  /// The primary action colour: filled buttons, selected states, focus rings.
  final Color brand;

  /// Content drawn on top of [brand].
  final Color onBrand;

  /// A low-emphasis wash of the brand, for selected rows and subtle chips.
  final Color brandSubtle;

  /// Content drawn on top of [brandSubtle].
  final Color onBrandSubtle;

  /// The page background.
  final Color surface;

  /// Cards, sheets and grouped list rows — one step above [surface].
  final Color surfaceElevated;

  /// Recessed areas such as track backgrounds and code blocks.
  final Color surfaceSunken;

  /// Primary text and icons.
  final Color onSurface;

  /// Secondary text, placeholders, disabled glyphs.
  final Color onSurfaceMuted;

  /// Hairline dividers between rows.
  final Color separator;

  /// Visible container borders.
  final Color border;

  /// Destructive actions and validation errors.
  final Color danger;

  /// Content drawn on top of [danger].
  final Color onDanger;

  /// A low-emphasis wash of [danger].
  final Color dangerSubtle;

  /// Positive confirmation.
  final Color success;

  /// Non-blocking caution.
  final Color warning;

  /// Neutral, informational emphasis.
  final Color info;

  /// The wash painted behind modals.
  final Color scrim;

  /// The colour shadows are tinted with.
  final Color shadow;

  /// The underlying Material 3 scheme.
  ///
  /// Exposed so that `ThemeData` can be built from exactly the same source of
  /// truth as the design system, instead of a parallel, drifting copy.
  final ColorScheme materialScheme;

  /// The semantic roles, in the order they are presented in the Foundations
  /// screen. Keeping the catalogue next to the definition means a new role can
  /// never be added without also becoming documented in the app.
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
