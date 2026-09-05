import 'package:design_system_flutter/design_system/foundations/ds_elevation.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class DSCard extends StatelessWidget {
  const DSCard({
    required this.child,
    this.padding = const EdgeInsets.all(DSSpacing.lg),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final BorderRadius radius = ds.radii.surfaceAll;

    final Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: ds.colors.surfaceElevated,
        borderRadius: radius,
        border: Border.all(color: ds.colors.separator),
        boxShadow: ds.elevation.shadow(
          DSElevation.level1,
          shadowColor: ds.colors.shadow,
        ),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return surface;

    return ds.isCupertino
        ? CupertinoButton(
            onPressed: onTap,
            padding: EdgeInsets.zero,
            borderRadius: radius,
            child: surface,
          )
        : Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(onTap: onTap, borderRadius: radius, child: surface),
          );
  }
}
