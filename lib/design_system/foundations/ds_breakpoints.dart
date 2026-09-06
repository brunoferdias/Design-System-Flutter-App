class DSBreakpoints {
  static const double medium = 600;
  static const double expanded = 960;

  static const double maxContentWidth = 720;
}

enum DSWindowSize {
  compact,
  medium,
  expanded;

  static DSWindowSize fromWidth(double width) {
    if (width < DSBreakpoints.medium) return DSWindowSize.compact;
    if (width < DSBreakpoints.expanded) return DSWindowSize.medium;
    return DSWindowSize.expanded;
  }

  bool get isAtLeastMedium => this != DSWindowSize.compact;
}
