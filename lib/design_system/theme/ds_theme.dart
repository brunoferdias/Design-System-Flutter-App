import 'package:design_system_flutter/design_system/foundations/ds_brand.dart';
import 'package:design_system_flutter/design_system/foundations/ds_colors.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/design_system/foundations/ds_elevation.dart';
import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_typography.dart';
import 'package:flutter/widgets.dart';

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

  T select<T>({required T material, required T cupertino}) =>
      isCupertino ? cupertino : material;

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

final class DSTheme extends InheritedWidget {
  const DSTheme({required this.data, required super.child, super.key});
  final DSThemeData data;

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

extension DSThemeContext on BuildContext {
  DSThemeData get ds => DSTheme.of(this);
}
