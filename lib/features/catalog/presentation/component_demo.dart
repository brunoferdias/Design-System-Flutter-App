import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// Picks the live demo for a component.
///
/// Each demo is a small widget below, kept stateful when the example needs to
/// react to taps.
class ComponentDemo extends StatelessWidget {
  const ComponentDemo({required this.componentId, super.key});

  final ComponentId componentId;

  @override
  Widget build(BuildContext context) {
    switch (componentId) {
      case ComponentId.button:
        return const _ButtonDemo();
      case ComponentId.textField:
        return const _TextFieldDemo();
      case ComponentId.toggle:
        return const _SwitchDemo();
      case ComponentId.slider:
        return const _SliderDemo();
      case ComponentId.segmentedControl:
        return const _SegmentedDemo();
      case ComponentId.card:
        return const _CardDemo();
      case ComponentId.listSection:
        return const _ListSectionDemo();
      case ComponentId.avatarBadge:
        return const _AvatarBadgeDemo();
      case ComponentId.dialog:
        return const _DialogDemo();
      case ComponentId.actionSheet:
        return const _ActionSheetDemo();
      case ComponentId.toast:
        return const _ToastDemo();
      case ComponentId.progress:
        return const _ProgressDemo();
    }
  }
}

/// Every button intent. The first one also toggles its loading state.
class _ButtonDemo extends StatefulWidget {
  const _ButtonDemo();

  @override
  State<_ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<_ButtonDemo> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSButton(
          label: l10n.showcaseIntentPrimary,
          isLoading: _isLoading,
          expand: true,
          onPressed: () => setState(() => _isLoading = !_isLoading),
        ),
        const DSGap.md(),
        DSButton(
          label: l10n.showcaseIntentSecondary,
          intent: DSButtonIntent.secondary,
          icon: Icons.bolt_outlined,
          expand: true,
          onPressed: () {},
        ),
        const DSGap.md(),
        DSButton(
          label: l10n.showcaseIntentTertiary,
          intent: DSButtonIntent.tertiary,
          expand: true,
          onPressed: () {},
        ),
        const DSGap.md(),
        DSButton(
          label: l10n.showcaseIntentDestructive,
          intent: DSButtonIntent.destructive,
          expand: true,
          onPressed: () {},
        ),
        const DSGap.md(),
        // A null callback is what disables a button.
        DSButton(label: l10n.showcaseDisabled, expand: true, onPressed: null),
      ],
    );
  }
}

/// The three states of a text field: normal, in error, and disabled.
class _TextFieldDemo extends StatelessWidget {
  const _TextFieldDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSTextField(
          label: l10n.showcaseSampleLabel,
          placeholder: l10n.showcaseSamplePlaceholder,
          helperText: l10n.showcaseSampleHelper,
        ),
        const DSGap.lg(),
        DSTextField(
          label: l10n.showcaseSampleLabel,
          placeholder: l10n.showcaseSamplePlaceholder,
          errorText: l10n.showcaseSampleError,
        ),
        const DSGap.lg(),
        DSTextField(
          label: l10n.showcaseDisabled,
          placeholder: l10n.showcaseSamplePlaceholder,
          enabled: false,
        ),
      ],
    );
  }
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DSListSection(
      rows: [
        DSListRow(
          title: _isOn ? l10n.showcaseEnabled : l10n.showcaseDisabled,
          trailing: DSSwitch(
            value: _isOn,
            semanticLabel: l10n.componentSwitch,
            onChanged: (next) => setState(() => _isOn = next),
          ),
        ),
        DSListRow(
          title: l10n.showcaseDisabled,
          trailing: const DSSwitch(value: false, onChanged: null),
        ),
      ],
    );
  }
}

/// A free-moving slider and one that snaps to five steps.
class _SliderDemo extends StatefulWidget {
  const _SliderDemo();

  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  double _continuousValue = 0.35;
  double _steppedValue = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSText(
          '${(_continuousValue * 100).round()}%',
          role: DSTextRole.subtitle,
        ),
        DSSlider(
          value: _continuousValue,
          semanticLabel: l10n.componentSlider,
          onChanged: (next) => setState(() => _continuousValue = next),
        ),
        const DSGap.lg(),
        DSText(_steppedValue.round().toString(), role: DSTextRole.subtitle),
        DSSlider(
          value: _steppedValue,
          min: 1,
          max: 5,
          divisions: 4,
          semanticLabel: l10n.componentSlider,
          onChanged: (next) => setState(() => _steppedValue = next),
        ),
      ],
    );
  }
}

class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo();

  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  String _selected = 'a';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DSSegmentedControl<String>(
      value: _selected,
      onChanged: (next) => setState(() => _selected = next),
      segments: [
        DSSegment(value: 'a', label: l10n.bookingCabinEconomy),
        DSSegment(value: 'b', label: l10n.bookingCabinPremium),
        DSSegment(value: 'c', label: l10n.bookingCabinBusiness),
      ],
    );
  }
}

/// A plain card and a tappable one.
class _CardDemo extends StatelessWidget {
  const _CardDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DSText(l10n.componentCard, role: DSTextRole.title),
              const DSGap.xs(),
              DSText(
                l10n.componentCardDescription,
                color: context.ds.colors.onSurfaceMuted,
              ),
            ],
          ),
        ),
        const DSGap.md(),
        DSCard(
          onTap: () => DSFeedback.toast(context, l10n.commonCopied),
          child: Row(
            children: [
              const DSAvatar(name: 'Ada Lovelace'),
              const DSGap.md(),
              Expanded(child: DSText(l10n.foundationsTapToCopy, maxLines: 2)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListSectionDemo extends StatelessWidget {
  const _ListSectionDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCupertino = context.ds.isCupertino;

    return DSListSection(
      header: l10n.componentsGroupContainment,
      footer: l10n.componentListSectionDescription,
      rows: [
        DSListRow(
          title: l10n.showcaseSampleLabel,
          additionalInfo: l10n.showcaseEnabled,
          leading: isCupertino ? CupertinoIcons.star : Icons.star_outline,
          onTap: () {},
        ),
        DSListRow(
          title: l10n.componentListSection,
          subtitle: l10n.componentListSectionDescription,
          leading: isCupertino
              ? CupertinoIcons.square_list
              : Icons.list_outlined,
          onTap: () {},
        ),
        DSListRow(
          title: l10n.commonDelete,
          isDestructive: true,
          leading: isCupertino ? CupertinoIcons.delete : Icons.delete_outline,
          onTap: () {},
        ),
      ],
    );
  }
}

/// Avatars at three sizes, and every badge tone.
class _AvatarBadgeDemo extends StatelessWidget {
  const _AvatarBadgeDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            DSAvatar(name: 'Ada Lovelace', size: 56),
            DSGap.md(),
            DSAvatar(name: 'Grace Hopper'),
            DSGap.md(),
            DSAvatar(name: 'Alan Turing', size: 32),
          ],
        ),
        const DSGap.xl(),
        Wrap(
          spacing: DSSpacing.sm,
          runSpacing: DSSpacing.sm,
          children: [
            DSBadge(l10n.showcaseEnabled, tone: DSBadgeTone.success),
            DSBadge(l10n.showcaseLoading, tone: DSBadgeTone.info),
            DSBadge(l10n.showcaseDisabled),
            DSBadge(l10n.showcaseIntentPrimary, tone: DSBadgeTone.brand),
            DSBadge(l10n.showcaseIntentDestructive, tone: DSBadgeTone.danger),
          ],
        ),
      ],
    );
  }
}

class _DialogDemo extends StatelessWidget {
  const _DialogDemo();

  Future<void> _openDialog(BuildContext context) async {
    final l10n = context.l10n;

    final confirmed = await DSFeedback.confirm(
      context,
      title: l10n.showcaseDialogTitle,
      message: l10n.showcaseDialogMessage,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDestructive: true,
    );

    // We waited for the dialog, so the page may be gone by now.
    if (!context.mounted || !confirmed) return;
    DSFeedback.toast(context, l10n.commonDone);
  }

  @override
  Widget build(BuildContext context) {
    return DSButton(
      label: context.l10n.showcaseOpenDialog,
      expand: true,
      onPressed: () => _openDialog(context),
    );
  }
}

class _ActionSheetDemo extends StatelessWidget {
  const _ActionSheetDemo();

  Future<void> _openSheet(BuildContext context) async {
    final l10n = context.l10n;

    final choice = await DSFeedback.actionSheet<String>(
      context,
      title: l10n.showcaseSheetTitle,
      cancelLabel: l10n.commonCancel,
      actions: [
        DSSheetAction(
          value: l10n.showcaseSheetCopyLink,
          label: l10n.showcaseSheetCopyLink,
          icon: Icons.link,
        ),
        DSSheetAction(
          value: l10n.showcaseSheetExportCode,
          label: l10n.showcaseSheetExportCode,
          icon: Icons.code,
        ),
        DSSheetAction(
          value: l10n.showcaseSheetReport,
          label: l10n.showcaseSheetReport,
          icon: Icons.flag_outlined,
          isDestructive: true,
        ),
      ],
    );

    // A null choice means the sheet was cancelled.
    if (!context.mounted || choice == null) return;
    DSFeedback.toast(context, choice);
  }

  @override
  Widget build(BuildContext context) {
    return DSButton(
      label: context.l10n.showcaseOpenActionSheet,
      intent: DSButtonIntent.secondary,
      expand: true,
      onPressed: () => _openSheet(context),
    );
  }
}

class _ToastDemo extends StatelessWidget {
  const _ToastDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DSButton(
      label: l10n.showcaseShowToast,
      intent: DSButtonIntent.secondary,
      expand: true,
      onPressed: () => DSFeedback.toast(context, l10n.showcaseToastMessage),
    );
  }
}

class _ProgressDemo extends StatelessWidget {
  const _ProgressDemo();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DSProgressIndicator(size: 20),
        DSProgressIndicator(),
        DSProgressIndicator(size: 40),
      ],
    );
  }
}
