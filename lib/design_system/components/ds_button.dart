import 'package:design_system_flutter/design_system/foundations/ds_radii.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// How important a button is, which decides how it is painted.
enum DSButtonIntent {
  /// The main action of the screen: filled with the brand colour.
  primary,

  /// A supporting action: outlined.
  secondary,

  /// A low-key action: text only.
  tertiary,

  /// Something the user cannot undo: filled in red.
  destructive,
}

/// A button that renders as a Material button or a Cupertino one, depending on
/// the design language.
///
/// Pass `onPressed: null` to disable it.
class DSButton extends StatelessWidget {
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

  /// Replaces the label with a spinner and blocks taps.
  final bool isLoading;

  /// Makes the button as wide as its parent.
  final bool expand;

  /// While loading the button must not react to taps either.
  bool get _isEnabled => onPressed != null && !isLoading;

  /// The callback we actually hand to the underlying button.
  VoidCallback? get _effectiveOnPressed => _isEnabled ? onPressed : null;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final button = ds.isCupertino
        ? _buildCupertino(context)
        : _buildMaterial(context);

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildMaterial(BuildContext context) {
    final ds = context.ds;

    switch (intent) {
      case DSButtonIntent.primary:
        return FilledButton(
          onPressed: _effectiveOnPressed,
          child: _content(context, foreground: ds.colors.onBrand),
        );
      case DSButtonIntent.destructive:
        return FilledButton(
          onPressed: _effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: ds.colors.danger,
            foregroundColor: ds.colors.onDanger,
          ),
          child: _content(context, foreground: ds.colors.onDanger),
        );
      case DSButtonIntent.secondary:
        return OutlinedButton(
          onPressed: _effectiveOnPressed,
          child: _content(context, foreground: ds.colors.brand),
        );
      case DSButtonIntent.tertiary:
        return TextButton(
          onPressed: _effectiveOnPressed,
          child: _content(context, foreground: ds.colors.brand),
        );
    }
  }

  Widget _buildCupertino(BuildContext context) {
    final ds = context.ds;
    final radius = ds.radii.controlAll;
    const minimumSize = Size(0, 48);
    const padding = EdgeInsets.symmetric(
      horizontal: DSSpacing.xl,
      vertical: DSSpacing.md,
    );

    switch (intent) {
      case DSButtonIntent.primary:
        return CupertinoButton.filled(
          onPressed: _effectiveOnPressed,
          borderRadius: radius,
          minimumSize: minimumSize,
          padding: padding,
          child: _content(context, foreground: ds.colors.onBrand),
        );
      case DSButtonIntent.destructive:
        return CupertinoButton(
          onPressed: _effectiveOnPressed,
          color: ds.colors.danger,
          borderRadius: radius,
          minimumSize: minimumSize,
          padding: padding,
          child: _content(context, foreground: ds.colors.onDanger),
        );
      case DSButtonIntent.secondary:
        // Cupertino has no outlined button, so we draw the border ourselves.
        return CupertinoButton(
          onPressed: _effectiveOnPressed,
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
        );
      case DSButtonIntent.tertiary:
        return CupertinoButton(
          onPressed: _effectiveOnPressed,
          minimumSize: minimumSize,
          padding: padding,
          child: _content(context, foreground: ds.colors.brand),
        );
    }
  }

  /// What goes inside the button: a spinner, a label, or an icon plus a label.
  Widget _content(BuildContext context, {required Color foreground}) {
    final ds = context.ds;
    final color = _isEnabled ? foreground : foreground.withValues(alpha: 0.4);

    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: ds.isCupertino
            ? CupertinoActivityIndicator(color: color, radius: 9)
            : CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }

    final text = Text(
      label,
      style: ds.typography.label.copyWith(fontSize: 14, color: color),
    );

    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: DSSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}

/// A tappable icon, sized to stay inside the 44dp minimum touch target.
class DSIconButton extends StatelessWidget {
  const DSIconButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// Read out loud by screen readers, and shown as a tooltip on Material.
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
