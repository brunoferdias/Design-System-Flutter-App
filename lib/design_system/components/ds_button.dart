import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DSButtonIntent { primary, secondary, tertiary, destructive }

final class DSButton extends StatelessWidget {
  const DSButton({
    required this.label,
    required this.onPressed,
    this.intent = DSButtonIntent.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final DSButtonIntent intent;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Widget button = ds.isCupertino
        ? _buildCupertino(context)
        : _buildMaterial(context);
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget _buildMaterial(BuildContext context) {
    final ds = context.ds;
    final Widget child = _content(
      context,
      foreground: switch (intent) {
        DSButtonIntent.primary => ds.colors.onBrand,
        DSButtonIntent.destructive => ds.colors.onDanger,
        DSButtonIntent.secondary || DSButtonIntent.tertiary => ds.colors.brand,
      },
    );
    final VoidCallback? onPressed = _enabled ? this.onPressed : null;

    return switch (intent) {
      DSButtonIntent.primary => FilledButton(
        onPressed: onPressed,
        child: child,
      ),
      DSButtonIntent.destructive => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: ds.colors.danger,
          foregroundColor: ds.colors.onDanger,
        ),
        child: child,
      ),
      DSButtonIntent.secondary => OutlinedButton(
        onPressed: onPressed,
        child: child,
      ),
      DSButtonIntent.tertiary => TextButton(onPressed: onPressed, child: child),
    };
  }

  Widget _buildCupertino(BuildContext context) {
    final ds = context.ds;
    final VoidCallback? onPressed = _enabled ? this.onPressed : null;
    final BorderRadius radius = ds.radii.controlAll;
    const Size minimumSize = Size(0, 48);
    const EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: DSSpacing.xl,
      vertical: DSSpacing.md,
    );

    return switch (intent) {
      DSButtonIntent.primary => CupertinoButton.filled(
        onPressed: onPressed,
        borderRadius: radius,
        minimumSize: minimumSize,
        padding: padding,
        child: _content(context, foreground: ds.colors.onBrand),
      ),
      DSButtonIntent.destructive => CupertinoButton(
        onPressed: onPressed,
        color: ds.colors.danger,
        borderRadius: radius,
        minimumSize: minimumSize,
        padding: padding,
        child: _content(context, foreground: ds.colors.onDanger),
      ),

      DSButtonIntent.secondary => CupertinoButton(
        onPressed: onPressed,
        borderRadius: radius,
        minimumSize: minimumSize,
        padding: EdgeInsets.zero,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: ds.colors.border),
          ),
          child: Padding(
            padding: padding,
            child: _content(context, foreground: ds.colors.brand),
          ),
        ),
      ),
      DSButtonIntent.tertiary => CupertinoButton(
        onPressed: onPressed,
        minimumSize: minimumSize,
        padding: padding,
        child: _content(context, foreground: ds.colors.brand),
      ),
    };
  }

  Widget _content(BuildContext context, {required Color foreground}) {
    final ds = context.ds;
    final Color color = _enabled
        ? foreground
        : foreground.withValues(alpha: 0.4);

    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: ds.isCupertino
            ? CupertinoActivityIndicator(color: color, radius: 9)
            : CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    final Text text = Text(
      label,
      style: ds.typography.label.copyWith(fontSize: 14, color: color),
    );
    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 18, color: color),
        const SizedBox(width: DSSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}

final class DSIconButton extends StatelessWidget {
  const DSIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    if (ds.isCupertino) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: const EdgeInsets.all(DSSpacing.sm),
        minimumSize: const Size.square(44),
        child: Icon(
          icon,
          size: 24,
          color: ds.colors.brand,
          semanticLabel: semanticLabel,
        ),
      );
    }
    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      icon: Icon(icon, semanticLabel: semanticLabel),
      color: ds.colors.onSurface,
      style: IconButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: DSRadii.pillAll),
      ),
    );
  }
}
