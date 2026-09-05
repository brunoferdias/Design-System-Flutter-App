import 'package:design_system_flutter/features/catalog/domain/component_id.dart';

/// The snippet shown on each component's detail page.
///
/// Not localized — code is code in every language. Kept next to the demos so a
/// change to a component's API is obvious the moment the sample stops matching
/// the specimen above it.
extension ComponentCode on ComponentId {
  String get codeSample => switch (this) {
    ComponentId.button => '''
DSButton(
  label: l10n.bookingSubmit,
  intent: DSButtonIntent.primary,
  icon: Icons.check,
  isLoading: controller.isSubmitting,
  expand: true,
  onPressed: controller.submit,
)''',
    ComponentId.textField => '''
DSTextField(
  label: l10n.bookingFieldEmail,
  placeholder: l10n.bookingFieldEmailHint,
  keyboardType: TextInputType.emailAddress,
  errorText: form.emailError,
  onChanged: controller.onEmailChanged,
)''',
    ComponentId.toggle => '''
DSSwitch(
  value: settings.flexibleFare,
  semanticLabel: l10n.bookingFlexibleFare,
  onChanged: controller.setFlexibleFare,
)''',
    ComponentId.slider => '''
DSSlider(
  value: passengers.toDouble(),
  min: 1,
  max: 6,
  divisions: 5,
  semanticLabel: l10n.bookingPassengers,
  onChanged: (value) => controller.setPassengers(value.round()),
)''',
    ComponentId.segmentedControl => '''
DSSegmentedControl<CabinClass>(
  value: form.cabin,
  onChanged: controller.setCabin,
  segments: [
    DSSegment(value: CabinClass.economy, label: l10n.bookingCabinEconomy),
    DSSegment(value: CabinClass.premium, label: l10n.bookingCabinPremium),
    DSSegment(value: CabinClass.business, label: l10n.bookingCabinBusiness),
  ],
)''',
    ComponentId.card => '''
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
)''',
    ComponentId.listSection => '''
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
)''',
    ComponentId.avatarBadge => '''
Row(
  children: [
    const DSAvatar(name: 'Ada Lovelace', size: 56),
    const DSGap.md(),
    DSBadge(l10n.showcaseEnabled, tone: DSBadgeTone.success),
  ],
)''',
    ComponentId.dialog => '''
final confirmed = await DSFeedback.confirm(
  context,
  title: l10n.bookingConfirmTitle,
  message: l10n.bookingConfirmMessage(2, cabin, name),
  confirmLabel: l10n.commonConfirm,
  cancelLabel: l10n.commonCancel,
);
if (!context.mounted || !confirmed) return;''',
    ComponentId.actionSheet => '''
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
);''',
    ComponentId.toast => '''
// Rendered into the root Overlay, so it behaves identically under
// MaterialApp and CupertinoApp.
DSFeedback.toast(context, l10n.settingsResetDone);''',
    ComponentId.progress => '''
const DSProgressIndicator(size: 24)''',
  };
}
