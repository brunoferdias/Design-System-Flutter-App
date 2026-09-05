import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

/// A live, interactive specimen of one component.
///
/// Every demo below is written the way a *feature* would write it: through the
/// `DSxxx` API only, with no `if (Platform.isIOS)` and no direct Material or
/// Cupertino imports beyond the two icon sets. If a demo needed an escape
/// hatch, that would be a bug in the design system, not in the demo.
final class ComponentDemo extends StatelessWidget {
  const ComponentDemo({required this.componentId, super.key});

  final ComponentId componentId;

  @override
  Widget build(BuildContext context) => switch (componentId) {
    ComponentId.button => const _ButtonDemo(),
    ComponentId.textField => const _TextFieldDemo(),
    ComponentId.toggle => const _SwitchDemo(),
    ComponentId.slider => const _SliderDemo(),
    ComponentId.segmentedControl => const _SegmentedDemo(),
    ComponentId.card => const _CardDemo(),
    ComponentId.listSection => const _ListSectionDemo(),
    ComponentId.avatarBadge => const _AvatarBadgeDemo(),
    ComponentId.dialog => const _DialogDemo(),
    ComponentId.actionSheet => const _ActionSheetDemo(),
    ComponentId.toast => const _ToastDemo(),
    ComponentId.progress => const _ProgressDemo(),
  };
}

// -----------------------------------------------------------------------------
// Actions
// -----------------------------------------------------------------------------

final class _ButtonDemo extends StatefulWidget {
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
      children: <Widget>[
        DSButton(
          label: l10n.showcaseIntentPrimary,
          intent: DSButtonIntent.primary,
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
        // `onPressed: null` is the only way to disable a button — the same
        // convention Flutter itself uses.
        DSButton(
          label: l10n.showcaseDisabled,
          expand: true,
          onPressed: null,
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Inputs
// -----------------------------------------------------------------------------

final class _TextFieldDemo extends StatelessWidget {
  const _TextFieldDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DSTextField(
          label: l10n.showcaseSampleLabel,
          placeholder: l10n.showcaseSamplePlaceholder,
          helperText: l10n.showcaseSampleHelper,
        ),
        const DSGap.lg(),
        // The error state is shown statically so it is always visible in the
        // gallery — a specimen sheet, not a form.
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

// -----------------------------------------------------------------------------
// Selection
// -----------------------------------------------------------------------------

final class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DSListSection(
      rows: <DSListRow>[
        DSListRow(
          title: _value ? l10n.showcaseEnabled : l10n.showcaseDisabled,
          trailing: DSSwitch(
            value: _value,
            semanticLabel: l10n.componentSwitch,
            onChanged: (bool next) => setState(() => _value = next),
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

final class _SliderDemo extends StatefulWidget {
  const _SliderDemo();

  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  double _continuous = 0.35;
  double _stepped = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DSText('${(_continuous * 100).round()}%', role: DSTextRole.subtitle),
        DSSlider(
          value: _continuous,
          semanticLabel: l10n.componentSlider,
          onChanged: (double next) => setState(() => _continuous = next),
        ),
        const DSGap.lg(),
        DSText(_stepped.round().toString(), role: DSTextRole.subtitle),
        DSSlider(
          value: _stepped,
          min: 1,
          max: 5,
          divisions: 4,
          semanticLabel: l10n.componentSlider,
          onChanged: (double next) => setState(() => _stepped = next),
        ),
      ],
    );
  }
}

final class _SegmentedDemo extends StatefulWidget {
  const _SegmentedDemo();

  @override
  State<_SegmentedDemo> createState() => _SegmentedDemoState();
}

class _SegmentedDemoState extends State<_SegmentedDemo> {
  String _value = 'a';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DSSegmentedControl<String>(
      value: _value,
      onChanged: (String next) => setState(() => _value = next),
      segments: <DSSegment<String>>[
        DSSegment<String>(value: 'a', label: l10n.bookingCabinEconomy),
        DSSegment<String>(value: 'b', label: l10n.bookingCabinPremium),
        DSSegment<String>(value: 'c', label: l10n.bookingCabinBusiness),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Containment
// -----------------------------------------------------------------------------

final class _CardDemo extends StatelessWidget {
  const _CardDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
            children: <Widget>[
              const DSAvatar(name: 'Ada Lovelace'),
              const DSGap.md(),
              Expanded(
                child: DSText(l10n.foundationsTapToCopy, maxLines: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _ListSectionDemo extends StatelessWidget {
  const _ListSectionDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final DesignLanguage language = context.ds.designLanguage;
    return DSListSection(
      header: l10n.componentsGroupContainment,
      footer: l10n.componentListSectionDescription,
      rows: <DSListRow>[
        DSListRow(
          title: l10n.showcaseSampleLabel,
          additionalInfo: l10n.showcaseEnabled,
          leading: language.isCupertino
              ? CupertinoIcons.star
              : Icons.star_outline,
          onTap: () {},
        ),
        DSListRow(
          title: l10n.componentListSection,
          subtitle: l10n.componentListSectionDescription,
          leading: language.isCupertino
              ? CupertinoIcons.square_list
              : Icons.list_outlined,
          onTap: () {},
        ),
        DSListRow(
          title: l10n.commonDelete,
          isDestructive: true,
          leading: language.isCupertino
              ? CupertinoIcons.delete
              : Icons.delete_outline,
          onTap: () {},
        ),
      ],
    );
  }
}

final class _AvatarBadgeDemo extends StatelessWidget {
  const _AvatarBadgeDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
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
          children: <Widget>[
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

// -----------------------------------------------------------------------------
// Feedback
// -----------------------------------------------------------------------------

final class _DialogDemo extends StatelessWidget {
  const _DialogDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DSButton(
      label: l10n.showcaseOpenDialog,
      expand: true,
      onPressed: () async {
        final bool confirmed = await DSFeedback.confirm(
          context,
          title: l10n.showcaseDialogTitle,
          message: l10n.showcaseDialogMessage,
          confirmLabel: l10n.commonDelete,
          cancelLabel: l10n.commonCancel,
          isDestructive: true,
        );
        // `context` crosses an async gap, so it has to be re-validated before
        // being used again. The analyzer enforces this; the habit matters more.
        if (!context.mounted || !confirmed) return;
        DSFeedback.toast(context, l10n.commonDone);
      },
    );
  }
}

final class _ActionSheetDemo extends StatelessWidget {
  const _ActionSheetDemo();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DSButton(
      label: l10n.showcaseOpenActionSheet,
      intent: DSButtonIntent.secondary,
      expand: true,
      onPressed: () async {
        final String? choice = await DSFeedback.actionSheet<String>(
          context,
          title: l10n.showcaseSheetTitle,
          cancelLabel: l10n.commonCancel,
          actions: <DSSheetAction<String>>[
            DSSheetAction<String>(
              value: l10n.showcaseSheetCopyLink,
              label: l10n.showcaseSheetCopyLink,
              icon: Icons.link,
            ),
            DSSheetAction<String>(
              value: l10n.showcaseSheetExportCode,
              label: l10n.showcaseSheetExportCode,
              icon: Icons.code,
            ),
            DSSheetAction<String>(
              value: l10n.showcaseSheetReport,
              label: l10n.showcaseSheetReport,
              icon: Icons.flag_outlined,
              isDestructive: true,
            ),
          ],
        );
        if (!context.mounted || choice == null) return;
        DSFeedback.toast(context, choice);
      },
    );
  }
}

final class _ToastDemo extends StatelessWidget {
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

final class _ProgressDemo extends StatelessWidget {
  const _ProgressDemo();

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      DSProgressIndicator(size: 20),
      DSProgressIndicator(),
      DSProgressIndicator(size: 40),
    ],
  );
}
