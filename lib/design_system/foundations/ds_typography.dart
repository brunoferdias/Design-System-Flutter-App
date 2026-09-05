import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// The type scale, expressed as design-system roles rather than platform names.
///
/// Both platforms get the same eight roles, but the metrics behind them differ:
/// Material's scale bottoms out at 14pt body copy, while Cupertino's body text
/// is 17pt. A component asks for `typography.body`; the theme decides what that
/// means today.
@immutable
final class DSTypography {
  const DSTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodyStrong,
    required this.label,
    required this.caption,
  });

  /// The Material 3 type scale, trimmed to the roles this system uses.
  factory DSTypography.material() => const DSTypography(
    display: TextStyle(fontSize: 36, height: 44 / 36, fontWeight: FontWeight.w400),
    headline: TextStyle(fontSize: 28, height: 36 / 28, fontWeight: FontWeight.w400),
    title: TextStyle(fontSize: 22, height: 28 / 22, fontWeight: FontWeight.w500),
    subtitle: TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    body: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodyStrong: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
    ),
    label: TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    caption: TextStyle(
      fontSize: 11,
      height: 16 / 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
  );

  /// Apple's text styles, mapped onto the same roles.
  factory DSTypography.cupertino() => const DSTypography(
    display: TextStyle(fontSize: 34, height: 41 / 34, fontWeight: FontWeight.w700, letterSpacing: 0.37),
    headline: TextStyle(fontSize: 28, height: 34 / 28, fontWeight: FontWeight.w700, letterSpacing: 0.36),
    title: TextStyle(fontSize: 22, height: 28 / 22, fontWeight: FontWeight.w600, letterSpacing: 0.35),
    subtitle: TextStyle(fontSize: 17, height: 22 / 17, fontWeight: FontWeight.w600, letterSpacing: -0.41),
    body: TextStyle(fontSize: 17, height: 22 / 17, fontWeight: FontWeight.w400, letterSpacing: -0.41),
    bodyStrong: TextStyle(fontSize: 17, height: 22 / 17, fontWeight: FontWeight.w600, letterSpacing: -0.41),
    label: TextStyle(fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w400, letterSpacing: -0.24),
    caption: TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w400, letterSpacing: -0.08),
  );

  factory DSTypography.of(DesignLanguage language) => switch (language) {
    DesignLanguage.material => DSTypography.material(),
    DesignLanguage.cupertino => DSTypography.cupertino(),
  };

  /// Page-level hero text. One per screen, at most.
  final TextStyle display;

  /// Section headlines.
  final TextStyle headline;

  /// Card and dialog titles.
  final TextStyle title;

  /// List row titles and form group labels.
  final TextStyle subtitle;

  /// Running text — the workhorse of the scale.
  final TextStyle body;

  /// Running text that needs emphasis without changing size.
  final TextStyle bodyStrong;

  /// Button labels, tab labels, overline text.
  final TextStyle label;

  /// Helper text, timestamps, footnotes.
  final TextStyle caption;

  /// Applies [color] to every role at once.
  DSTypography applyColor(Color color) => DSTypography(
    display: display.copyWith(color: color),
    headline: headline.copyWith(color: color),
    title: title.copyWith(color: color),
    subtitle: subtitle.copyWith(color: color),
    body: body.copyWith(color: color),
    bodyStrong: bodyStrong.copyWith(color: color),
    label: label.copyWith(color: color),
    caption: caption.copyWith(color: color),
  );

  /// The roles in scale order, for the Foundations screen.
  Map<String, TextStyle> get catalogue => <String, TextStyle>{
    'display': display,
    'headline': headline,
    'title': title,
    'subtitle': subtitle,
    'body': body,
    'bodyStrong': bodyStrong,
    'label': label,
    'caption': caption,
  };
}
