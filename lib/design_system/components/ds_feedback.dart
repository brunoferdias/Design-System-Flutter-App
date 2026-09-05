import 'dart:async';

import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_motion.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// One entry in a [DSFeedback.actionSheet].
@immutable
final class DSSheetAction<T> {
  const DSSheetAction({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDestructive;
}

/// Everything the design system can say back to the user.
///
/// Grouped as static entry points rather than widgets because these are all
/// imperative, `Future`-returning interactions. Screens `await` a plain `bool`
/// or `T?` and never learn which framework drew the surface.
abstract final class DSFeedback {
  /// A blocking yes/no question. Resolves to `false` when dismissed.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool isDestructive = false,
  }) async {
    final DSThemeData ds = context.ds;

    if (ds.isCupertino) {
      final bool? result = await showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: DSSpacing.sm),
            child: Text(message),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              isDefaultAction: !isDestructive,
              child: Text(cancelLabel),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              isDestructiveAction: isDestructive,
              isDefaultAction: isDestructive == false,
              child: Text(confirmLabel),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: ds.colors.danger,
                    foregroundColor: ds.colors.onDanger,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// A menu of contextual actions. Resolves to `null` when dismissed.
  static Future<T?> actionSheet<T>(
    BuildContext context, {
    required String title,
    required List<DSSheetAction<T>> actions,
    required String cancelLabel,
  }) {
    final DSThemeData ds = context.ds;

    if (ds.isCupertino) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: (BuildContext sheetContext) => CupertinoActionSheet(
          title: Text(title),
          actions: <Widget>[
            for (final DSSheetAction<T> action in actions)
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(sheetContext).pop(action.value),
                isDestructiveAction: action.isDestructive,
                child: Text(action.label),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            isDefaultAction: true,
            child: Text(cancelLabel),
          ),
        ),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DSSpacing.lg,
                0,
                DSSpacing.lg,
                DSSpacing.sm,
              ),
              child: DSText(title, role: DSTextRole.title),
            ),
            for (final DSSheetAction<T> action in actions)
              ListTile(
                leading: action.icon == null ? null : Icon(action.icon),
                title: Text(action.label),
                iconColor: action.isDestructive ? ds.colors.danger : null,
                textColor: action.isDestructive ? ds.colors.danger : null,
                onTap: () => Navigator.of(sheetContext).pop(action.value),
              ),
          ],
        ),
      ),
    );
  }

  /// Transient, non-blocking feedback.
  ///
  /// Material has `SnackBar` and Cupertino has nothing, so rather than making
  /// half the app feel foreign the design system owns this one outright and
  /// paints it into the root [Overlay]. It therefore works identically under
  /// `MaterialApp` and `CupertinoApp`.
  static void toast(BuildContext context, String message) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final DSThemeData ds = context.ds;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext overlayContext) => DSTheme(
        data: ds,
        child: _DSToast(
          message: message,
          onDismissed: () {
            if (entry.mounted) entry.remove();
          },
        ),
      ),
    );
    overlay.insert(entry);
  }
}

/// The toast surface: fades and slides in, waits, then removes itself.
final class _DSToast extends StatefulWidget {
  const _DSToast({required this.message, required this.onDismissed});

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_DSToast> createState() => _DSToastState();
}

class _DSToastState extends State<_DSToast> with SingleTickerProviderStateMixin {
  static const Duration _visibleFor = Duration(seconds: 3);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DSMotion.normal,
    reverseDuration: DSMotion.fast,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    await _controller.forward();
    await Future<void>.delayed(_visibleFor);
    if (!mounted) return;
    await _controller.reverse();
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final CurvedAnimation animation = CurvedAnimation(
      parent: _controller,
      curve: DSMotion.enter,
      reverseCurve: DSMotion.exit,
    );

    return Positioned(
      left: DSSpacing.lg,
      right: DSSpacing.lg,
      bottom: MediaQuery.viewPaddingOf(context).bottom + DSSpacing.xxxl,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(animation),
            child: Align(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(
                  horizontal: DSSpacing.lg,
                  vertical: DSSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: ds.isDark
                      ? ds.colors.surfaceSunken
                      : ds.colors.onSurface,
                  borderRadius: BorderRadius.all(ds.radii.control),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: ds.colors.shadow.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: ds.typography.body.copyWith(
                      color: ds.isDark ? ds.colors.onSurface : ds.colors.surface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
