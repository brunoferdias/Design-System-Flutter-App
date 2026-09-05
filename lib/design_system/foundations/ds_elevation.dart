import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/painting.dart';

/// Builds the shadows used by cards and sheets.
class DSElevation {
  const DSElevation(this.language);

  final DesignLanguage language;

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;

  /// iOS surfaces are flat (they use borders instead of shadows), so on
  /// Cupertino this always returns an empty list.
  List<BoxShadow> shadow(double level, {required Color shadowColor}) {
    if (language.isCupertino || level <= level0) return const [];

    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.10 + level * 0.01),
        blurRadius: level * 4,
        offset: Offset(0, level),
      ),
    ];
  }
}
