import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

/// The meaning a badge carries, which selects its colour pair.
enum DSBadgeTone { neutral, brand, success, warning, danger, info }

/// A small pill that labels the status of the thing next to it.
///
/// A deliberately *neutral* component: neither Material nor Cupertino specifies
/// one, so the design system owns the whole definition and it renders
/// identically on both platforms. Every design system needs a few of these.
final class DSBadge extends StatelessWidget {
  const DSBadge(this.label, {this.tone = DSBadgeTone.neutral, super.key});

  final String label;
  final DSBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Color foreground = switch (tone) {
      DSBadgeTone.neutral => ds.colors.onSurfaceMuted,
      DSBadgeTone.brand => ds.colors.brand,
      DSBadgeTone.success => ds.colors.success,
      DSBadgeTone.warning => ds.colors.warning,
      DSBadgeTone.danger => ds.colors.danger,
      DSBadgeTone.info => ds.colors.info,
    };
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
}
