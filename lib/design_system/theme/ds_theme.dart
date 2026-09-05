import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_colors.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/design_system/foundations/ds_elevation.dart';
import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_typography.dart';
import 'package:flutter/widgets.dart';

/// The fully resolved design system: every token, ready to be read.
///
/// This is deliberately *not* a Flutter `ThemeData` or `CupertinoThemeData`.
/// Those are outputs; this is the input both of them are generated from, which
/// is what stops the Material and Cupertino skins from drifting apart.
@immutable
final class DSThemeData {
  const DSThemeData({
    required this.designLanguage,
    required this.brand,
    required this.colors,
    required this.typography,
    required this.radii,
    required this.elevation,
  });

  /// Resolves every token from the three inputs a user can actually change.
  factory DSThemeData.resolve({
    required DesignLanguage designLanguage,
    required Brightness brightness,
    required DSBrand brand,
  }) {
    final DSColors colors = DSColors.fromSeed(
      seed: brand.seed,
      brightness: brightness,
      language: designLanguage,
    );
    return DSThemeData(
      designLanguage: designLanguage,
      brand: brand,
      colors: colors,
      typography: DSTypography.of(designLanguage).applyColor(colors.onSurface),
      radii: DSRadii.of(designLanguage),
      elevation: DSElevation.of(designLanguage),
    );
  }

  final DesignLanguage designLanguage;
  final DSBrand brand;
  final DSColors colors;
  final DSTypography typography;
  final DSRadii radii;
  final DSElevation elevation;

  Brightness get brightness => colors.brightness;

  bool get isDark => brightness == Brightness.dark;

  bool get isCupertino => designLanguage.isCupertino;

  bool get isMaterial => designLanguage.isMaterial;

  /// Picks between a Material and a Cupertino value.
  ///
  /// Used by components for the rare, genuinely cosmetic differences that do
  /// not deserve a token of their own.
  T select<T>({required T material, required T cupertino}) =>
      isCupertino ? cupertino : material;

  // Every other field is a pure function of these three, so comparing them is
  // both correct and cheap — and it keeps `updateShouldNotify` from rebuilding
  // the entire app on every frame.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DSThemeData &&
          other.designLanguage == designLanguage &&
          other.brand == brand &&
          other.brightness == brightness;

  @override
  int get hashCode => Object.hash(designLanguage, brand, brightness);
}

/// Publishes [DSThemeData] to the widget tree.
///
/// Sits *above* both `MaterialApp` and `CupertinoApp` so that tokens survive the
/// swap between them, and so that components can be tested without booting an
/// entire app.
final class DSTheme extends InheritedWidget {
  const DSTheme({required this.data, required super.child, super.key});

  final DSThemeData data;

  /// The nearest design system theme.
  ///
  /// Throws in debug mode when the ancestor is missing, because silently
  /// falling back to defaults is how design systems rot.
  static DSThemeData of(BuildContext context) {
    final DSTheme? theme = context
        .dependOnInheritedWidgetOfExactType<DSTheme>();
    assert(
      theme != null,
      'No DSTheme found in context. Wrap your app in a DSTheme (see AuroraApp) '
      'or use DSTheme(data: DSThemeData.resolve(...)) in tests.',
    );
    return theme!.data;
  }

  @override
  bool updateShouldNotify(DSTheme oldWidget) => data != oldWidget.data;
}

/// `context.ds` — the single accessor every component uses.
extension DSThemeContext on BuildContext {
  DSThemeData get ds => DSTheme.of(this);
}
