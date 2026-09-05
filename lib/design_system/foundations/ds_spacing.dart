/// Spacing tokens.
///
/// A strict 4-point grid. Components never hard-code an `EdgeInsets` value —
/// they compose these constants, which is what keeps vertical rhythm identical
/// between Material and Cupertino screens.
abstract final class DSSpacing {
  /// 2 — hairline gaps between tightly coupled glyphs.
  static const double xxs = 2;

  /// 4 — icon/label separation.
  static const double xs = 4;

  /// 8 — the default gap inside a component.
  static const double sm = 8;

  /// 12 — gap between sibling controls.
  static const double md = 12;

  /// 16 — the default screen gutter.
  static const double lg = 16;

  /// 24 — separation between content blocks.
  static const double xl = 24;

  /// 32 — separation between sections.
  static const double xxl = 32;

  /// 48 — hero spacing above a page headline.
  static const double xxxl = 48;
}
