/// Layout breakpoints, aligned with the Material 3 window size classes.
///
/// The app uses them to pick a navigation pattern (tabs vs. rail) and to cap the
/// width of reading columns on large screens.
enum DSWindowSize {
  /// Phones in portrait. Bottom navigation, single column.
  compact,

  /// Small tablets, phones in landscape. Navigation rail, single column.
  medium,

  /// Tablets and desktops. Navigation rail, centred content column.
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
  /// Below this width the layout is a single, edge-to-edge column.
  static const double medium = 600;

  /// Above this width there is room for a persistent navigation rail.
  static const double expanded = 960;

  /// Text is never allowed to grow wider than this, for readability.
  static const double maxContentWidth = 720;
}
