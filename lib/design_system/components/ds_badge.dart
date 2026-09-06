import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

enum DSBadgeTone { neutral, brand, success, warning, danger, info }

class DSBadge extends StatelessWidget {
  const DSBadge(this.label, {this.tone = DSBadgeTone.neutral, super.key});

  final String label;
  final DSBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final foreground = _foregroundFor(ds);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.12),
        borderRadius: DSRadii.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.sm,
          vertical: DSSpacing.xxs,
        ),
        child: DSText(label, role: DSTextRole.caption, color: foreground),
      ),
    );
  }

  Color _foregroundFor(DSThemeData ds) {
    switch (tone) {
      case DSBadgeTone.neutral:
        return ds.colors.onSurfaceMuted;
      case DSBadgeTone.brand:
        return ds.colors.brand;
      case DSBadgeTone.success:
        return ds.colors.success;
      case DSBadgeTone.warning:
        return ds.colors.warning;
      case DSBadgeTone.danger:
        return ds.colors.danger;
      case DSBadgeTone.info:
        return ds.colors.info;
    }
  }
}
