/// Width thresholds that decide the navigation layout.
class DSBreakpoints {
  static const double medium = 600;
  static const double expanded = 960;

  /// Text stays readable when a page is not wider than this.
  static const double maxContentWidth = 720;
}

/// How much horizontal room the app currently has.
enum DSWindowSize {
  compact,
  medium,
  expanded;

  static DSWindowSize fromWidth(double width) {
    if (width < DSBreakpoints.medium) return DSWindowSize.compact;
    if (width < DSBreakpoints.expanded) return DSWindowSize.medium;
    return DSWindowSize.expanded;
  }

  /// Phones get a bottom bar; anything wider gets a side rail.
  bool get isAtLeastMedium => this != DSWindowSize.compact;
}
