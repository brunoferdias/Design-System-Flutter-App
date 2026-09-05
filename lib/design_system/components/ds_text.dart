import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

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

final class DSText extends StatelessWidget {
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
    final TextStyle style = switch (role) {
      DSTextRole.display => ds.typography.display,
      DSTextRole.headline => ds.typography.headline,
      DSTextRole.title => ds.typography.title,
      DSTextRole.subtitle => ds.typography.subtitle,
      DSTextRole.body => ds.typography.body,
      DSTextRole.bodyStrong => ds.typography.bodyStrong,
      DSTextRole.label => ds.typography.label,
      DSTextRole.caption => ds.typography.caption,
    };
    return Text(
      data,
      style: color == null ? style : style.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
