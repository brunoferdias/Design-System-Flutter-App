import 'package:design_system_flutter/design_system/components/ds_gap.dart';
import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

/// A title (and optional explanation) that starts a new block on a page.
class DSSectionHeader extends StatelessWidget {
  const DSSectionHeader({
    required this.title,
    this.description,
    this.topPadding = DSSpacing.xl,
    super.key,
  });

  final String title;
  final String? description;

  /// Set this to 0 when the header is the first thing on the page.
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: DSSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DSText(title, role: DSTextRole.title),
          if (description != null) ...[
            const DSGap.xs(),
            DSText(description!, color: ds.colors.onSurfaceMuted),
          ],
        ],
      ),
    );
  }
}
