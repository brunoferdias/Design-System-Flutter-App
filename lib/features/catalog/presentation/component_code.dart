import 'package:design_system_flutter/features/catalog/domain/component_id.dart';

/// The snippet shown under each demo.
///
/// These are hand written examples of how the component is used in this app --
/// they are text, not code that runs.
extension ComponentCode on ComponentId {
  String get codeSample {
    switch (this) {
      case ComponentId.button:
        return '''
DSButton(
  label: l10n.bookingSubmit,
  intent: DSButtonIntent.primary,
  icon: Icons.check,
  isLoading: controller.isSubmitting,
  expand: true,
  onPressed: controller.submit,
)''';

      case ComponentId.textField:
        return '''
DSTextField(
  label: l10n.bookingFieldEmail,
  placeholder: l10n.bookingFieldEmailHint,
  keyboardType: TextInputType.emailAddress,
  errorText: form.emailError,
  onChanged: controller.onEmailChanged,
)''';

      case ComponentId.toggle:
        return '''
DSSwitch(
  value: settings.flexibleFare,
  semanticLabel: l10n.bookingFlexibleFare,
  onChanged: controller.setFlexibleFare,
)''';

      case ComponentId.slider:
        return '''
DSSlider(
  value: passengers.toDouble(),
  min: 1,
  max: 6,
  divisions: 5,
  semanticLabel: l10n.bookingPassengers,
  onChanged: (value) => controller.setPassengers(value.round()),
)''';

      case ComponentId.segmentedControl:
        return '''
DSSegmentedControl<CabinClass>(
  value: form.cabin,
  onChanged: controller.setCabin,
  segments: [
    DSSegment(value: CabinClass.economy, label: l10n.bookingCabinEconomy),
    DSSegment(value: CabinClass.premium, label: l10n.bookingCabinPremium),
    DSSegment(value: CabinClass.business, label: l10n.bookingCabinBusiness),
  ],
)''';

      case ComponentId.card:
        return '''
DSCard(
  onTap: () => context.goNamed(AppRoute.playground.routeName),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DSText(l10n.playgroundTitle, role: DSTextRole.title),
      const DSGap.xs(),
      DSText(l10n.playgroundSubtitle),
    ],
  ),
)''';

      case ComponentId.listSection:
        return '''
DSListSection(
  header: l10n.settingsSectionAppearance,
  footer: l10n.settingsBrandColorDescription,
  rows: [
    DSListRow(
      title: l10n.settingsThemeMode,
      additionalInfo: l10n.themeModeSystem,
      leading: Icons.brightness_auto_outlined,
      onTap: controller.pickThemeMode,
    ),
  ],
)''';

      case ComponentId.avatarBadge:
        return '''
Row(
  children: [
    const DSAvatar(name: 'Ada Lovelace', size: 56),
    const DSGap.md(),
    DSBadge(l10n.showcaseEnabled, tone: DSBadgeTone.success),
  ],
)''';

      case ComponentId.dialog:
        return '''
final confirmed = await DSFeedback.confirm(
  context,
  title: l10n.bookingConfirmTitle,
  message: l10n.bookingConfirmMessage(2, cabin, name),
  confirmLabel: l10n.commonConfirm,
  cancelLabel: l10n.commonCancel,
);
if (!context.mounted || !confirmed) return;''';

      case ComponentId.actionSheet:
        return '''
final choice = await DSFeedback.actionSheet<ShareTarget>(
  context,
  title: l10n.showcaseSheetTitle,
  cancelLabel: l10n.commonCancel,
  actions: [
    DSSheetAction(value: ShareTarget.link, label: l10n.showcaseSheetCopyLink),
    DSSheetAction(
      value: ShareTarget.report,
      label: l10n.showcaseSheetReport,
      isDestructive: true,
    ),
  ],
);''';

      case ComponentId.toast:
        return 'DSFeedback.toast(context, l10n.settingsResetDone);';

      case ComponentId.progress:
        return 'const DSProgressIndicator(size: 24)';
    }
  }
}
