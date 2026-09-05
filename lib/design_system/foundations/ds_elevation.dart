import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/painting.dart';

final class DSElevation {
  const DSElevation._(this._language);

  factory DSElevation.of(DesignLanguage language) => DSElevation._(language);

  final DesignLanguage _language;
  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 3;
  static const double level3 = 6;

  List<BoxShadow> shadow(double level, {required Color shadowColor}) {
    if (_language.isCupertino || level <= level0) return const <BoxShadow>[];
    return <BoxShadow>[
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.10 + level * 0.01),
        blurRadius: level * 4,
        offset: Offset(0, level),
      ),
    ];
  }
}
