import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

/// What a piece of text is for. The role picks the style, so screens never
/// set a font size by hand.
enum DSTextRole {
  display,
  headline,
  title,
  subtitle,
  body,
  bodyStrong,
  label,
  caption,
}

/// A `Text` that already knows the app's typography.
class DSText extends StatelessWidget {
  const DSText(
    this.data, {
    this.role = DSTextRole.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String data;
  final DSTextRole role;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    var style = _styleFor(ds);
    if (color != null) {
      style = style.copyWith(color: color);
    }

    return Text(
      data,
      style: style,
      textAlign: textAlign,
      // When the text is limited to a few lines, cut it with "..." by default.
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }

  TextStyle _styleFor(DSThemeData ds) {
    switch (role) {
      case DSTextRole.display:
        return ds.typography.display;
      case DSTextRole.headline:
        return ds.typography.headline;
      case DSTextRole.title:
        return ds.typography.title;
      case DSTextRole.subtitle:
        return ds.typography.subtitle;
      case DSTextRole.body:
        return ds.typography.body;
      case DSTextRole.bodyStrong:
        return ds.typography.bodyStrong;
      case DSTextRole.label:
        return ds.typography.label;
      case DSTextRole.caption:
        return ds.typography.caption;
    }
  }
}
