enum DSWindowSize {
  compact,

  medium,

  expanded;

  static DSWindowSize fromWidth(double width) {
    if (width < DSBreakpoints.medium) return DSWindowSize.compact;
    if (width < DSBreakpoints.expanded) return DSWindowSize.medium;
    return DSWindowSize.expanded;
  }

  bool get isCompact => this == DSWindowSize.compact;

  bool get isAtLeastMedium => this != DSWindowSize.compact;
}

abstract final class DSBreakpoints {
  static const double medium = 600;
  static const double expanded = 960;
  static const double maxContentWidth = 720;
}
