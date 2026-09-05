import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/painting.dart';

/// Elevation tokens.
///
/// Material and Cupertino disagree about depth more than about anything else:
/// Material tints and shadows a surface as it rises, while Cupertino keeps
/// surfaces flat and separates them with hairlines. Both answers live here so a
/// component can simply say "this is a level 1 surface".
final class DSElevation {
  const DSElevation._(this._language);

  factory DSElevation.of(DesignLanguage language) => DSElevation._(language);

  final DesignLanguage _language;

  /// Flush with the page — no depth at all.
  static const double level0 = 0;

  /// Cards and grouped lists.
  static const double level1 = 1;

  /// App bars once the content scrolls under them.
  static const double level2 = 3;

  /// Dialogs, popovers and sheets.
  static const double level3 = 6;

  /// The shadow for a given level, or an empty list on Cupertino where depth is
  /// expressed with borders instead.
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
