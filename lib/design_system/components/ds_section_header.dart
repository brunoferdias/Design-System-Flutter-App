import 'package:design_system_flutter/design_system/components/ds_gap.dart';
import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

/// A title plus an optional one-line explanation, used to open a section.
final class DSSectionHeader extends StatelessWidget {
  const DSSectionHeader({
    required this.title,
    this.description,
    this.topPadding = DSSpacing.xl,
    super.key,
  });

  final String title;
  final String? description;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: DSSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DSText(title, role: DSTextRole.title),
          if (description != null) ...<Widget>[
            const DSGap.xs(),
            DSText(
              description!,
              role: DSTextRole.body,
              color: ds.colors.onSurfaceMuted,
            ),
          ],
        ],
      ),
    );
  }
}
