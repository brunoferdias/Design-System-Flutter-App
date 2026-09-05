import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_colors.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/design_system/foundations/ds_elevation.dart';
import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_typography.dart';
import 'package:flutter/widgets.dart';

/// All the design tokens, resolved for the current settings.
///
/// Widgets read this with `context.ds`.
class DSThemeData {
  const DSThemeData({
    required this.designLanguage,
    required this.brand,
    required this.colors,
    required this.typography,
    required this.radii,
    required this.elevation,
  });

  /// Builds the tokens for one combination of design language, brightness and
  /// brand. This runs again every time the user changes any of the three.
  factory DSThemeData.resolve({
    required DesignLanguage designLanguage,
    required Brightness brightness,
    required DSBrand brand,
  }) {
    final colors = DSColors.fromSeed(
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
      elevation: DSElevation(designLanguage),
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

  /// Picks one of two values based on the design language, so widgets can write
  /// `ds.select(material: Icons.check, cupertino: CupertinoIcons.check_mark)`.
  T select<T>({required T material, required T cupertino}) {
    return isCupertino ? cupertino : material;
  }

  // Two DSThemeData are the same when they were resolved from the same three
  // inputs -- that is what decides whether widgets need to rebuild.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DSThemeData &&
        other.designLanguage == designLanguage &&
        other.brand == brand &&
        other.brightness == brightness;
  }

  @override
  int get hashCode => Object.hash(designLanguage, brand, brightness);
}

/// Puts [DSThemeData] in the widget tree so any widget below can read it.
class DSTheme extends InheritedWidget {
  const DSTheme({required this.data, required super.child, super.key});

  final DSThemeData data;

  static DSThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<DSTheme>();
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

extension DSThemeContext on BuildContext {
  DSThemeData get ds => DSTheme.of(this);
}
