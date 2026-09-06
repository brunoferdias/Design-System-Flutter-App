import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/playground/application/booking_controller.dart';
import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaygroundPage extends ConsumerWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ds = context.ds;
    final draft = ref.watch(bookingProvider);
    final controller = ref.read(bookingProvider.notifier);

    return DSScaffold(
      title: l10n.playgroundTitle,
      body: DSPageBody(
        children: [
          DSText(l10n.bookingHeadline, role: DSTextRole.display),
          const DSGap.sm(),
          DSText(l10n.playgroundSubtitle, color: ds.colors.onSurfaceMuted),

          const DSGap.xl(),
          DSTextField(
            label: l10n.bookingFieldName,
            placeholder: l10n.bookingFieldNameHint,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            onChanged: controller.setName,
            errorText: draft.showValidation && !draft.isNameValid
                ? l10n.bookingErrorNameRequired
                : null,
          ),
          const DSGap.lg(),
          DSTextField(
            label: l10n.bookingFieldEmail,
            placeholder: l10n.bookingFieldEmailHint,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onChanged: controller.setEmail,
            errorText: draft.showValidation && !draft.isEmailValid
                ? l10n.bookingErrorEmailInvalid
                : null,
          ),

          const DSGap.xl(),
          DSText(l10n.bookingCabin, role: DSTextRole.subtitle),
          const DSGap.sm(),
          DSSegmentedControl<CabinClass>(
            value: draft.cabin,
            onChanged: controller.setCabin,
            segments: [
              DSSegment(
                value: CabinClass.economy,
                label: l10n.bookingCabinEconomy,
              ),
              DSSegment(
                value: CabinClass.premium,
                label: l10n.bookingCabinPremium,
              ),
              DSSegment(
                value: CabinClass.business,
                label: l10n.bookingCabinBusiness,
              ),
            ],
          ),

          const DSGap.xl(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DSText(l10n.bookingPassengers, role: DSTextRole.subtitle),
              DSText(
                l10n.bookingPassengerCount(draft.passengers),
                color: ds.colors.onSurfaceMuted,
              ),
            ],
          ),
          DSSlider(
            value: draft.passengers.toDouble(),
            min: BookingDraft.minPassengers.toDouble(),
            max: BookingDraft.maxPassengers.toDouble(),
            divisions: BookingDraft.maxPassengers - BookingDraft.minPassengers,
            semanticLabel: l10n.bookingPassengers,
            onChanged: (value) => controller.setPassengers(value.round()),
          ),

          const DSGap.lg(),
          DSListSection(
            rows: [
              DSListRow(
                title: l10n.bookingDeparture,
                additionalInfo: l10n.bookingDepartureValue(draft.departure),
              ),
              DSListRow(
                title: l10n.bookingFlexibleFare,
                subtitle: l10n.bookingFlexibleFareDescription,
                trailing: DSSwitch(
                  value: draft.flexibleFare,
                  semanticLabel: l10n.bookingFlexibleFare,
                  onChanged: (enabled) {
                    controller.setFlexibleFare(enabled: enabled);
                  },
                ),
              ),
            ],
          ),

          DSCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DSText(l10n.bookingTotal, role: DSTextRole.subtitle),
                DSText(
                  l10n.bookingTotalValue(draft.total),
                  role: DSTextRole.title,
                  color: ds.colors.brand,
                ),
              ],
            ),
          ),

          const DSGap.xl(),
          DSButton(
            label: l10n.bookingSubmit,
            expand: true,
            onPressed: () => _submit(context, ref),
          ),
          const DSGap.sm(),
          DSButton(
            label: l10n.commonReset,
            intent: DSButtonIntent.tertiary,
            expand: true,
            onPressed: controller.reset,
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = ref.read(bookingProvider.notifier);

    if (!controller.submit()) return;

    final draft = ref.read(bookingProvider);
    final confirmed = await DSFeedback.confirm(
      context,
      title: l10n.bookingConfirmTitle,
      message: l10n.bookingConfirmMessage(
        draft.passengers,
        _cabinLabel(context, draft.cabin),
        draft.name.trim(),
      ),
      confirmLabel: l10n.commonConfirm,
      cancelLabel: l10n.commonCancel,
    );

    if (!context.mounted || !confirmed) return;
    DSFeedback.toast(context, l10n.bookingSuccess(draft.name.trim()));
  }
}

String _cabinLabel(BuildContext context, CabinClass cabin) {
  final l10n = context.l10n;

  switch (cabin) {
    case CabinClass.economy:
      return l10n.bookingCabinEconomy;
    case CabinClass.premium:
      return l10n.bookingCabinPremium;
    case CabinClass.business:
      return l10n.bookingCabinBusiness;
  }
}
