import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/onboarding/domain/onboarding_step.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/presentation/brand_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingStepView extends StatelessWidget {
  const OnboardingStepView({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return DSPageBody(
      children: [
        _StepArtwork(step: step),
        const DSGap.xl(),
        DSText(_titleFor(context, step), role: DSTextRole.display),
        const DSGap.sm(),
        DSText(_bodyFor(context, step), color: ds.colors.onSurfaceMuted),
        const DSGap.xl(),
        _contentFor(step),
      ],
    );
  }

  Widget _contentFor(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.welcome:
        return const _WelcomeContent();
      case OnboardingStep.designLanguage:
        return const _DesignLanguageContent();
      case OnboardingStep.appearance:
        return const _AppearanceContent();
      case OnboardingStep.language:
        return const _LanguageContent();
      case OnboardingStep.tour:
        return const _TourContent();
    }
  }
}

String _titleFor(BuildContext context, OnboardingStep step) {
  final l10n = context.l10n;

  switch (step) {
    case OnboardingStep.welcome:
      return l10n.onboardingWelcomeTitle;
    case OnboardingStep.designLanguage:
      return l10n.onboardingDesignLanguageTitle;
    case OnboardingStep.appearance:
      return l10n.onboardingAppearanceTitle;
    case OnboardingStep.language:
      return l10n.onboardingLanguageTitle;
    case OnboardingStep.tour:
      return l10n.onboardingTourTitle;
  }
}

String _bodyFor(BuildContext context, OnboardingStep step) {
  final l10n = context.l10n;

  switch (step) {
    case OnboardingStep.welcome:
      return l10n.onboardingWelcomeBody;
    case OnboardingStep.designLanguage:
      return l10n.onboardingDesignLanguageBody;
    case OnboardingStep.appearance:
      return l10n.onboardingAppearanceBody;
    case OnboardingStep.language:
      return l10n.onboardingLanguageBody;
    case OnboardingStep.tour:
      return l10n.onboardingTourBody;
  }
}

class _StepArtwork extends StatelessWidget {
  const _StepArtwork({required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final palette = [
      ds.colors.brand,
      ds.colors.brandSubtle,
      ds.colors.success,
      ds.colors.warning,
      ds.colors.info,
      ds.colors.danger,
    ];

    return SizedBox(
      height: 96,
      child: Row(
        children: [
          for (var i = 0; i < palette.length; i++)
            Expanded(
              child: AnimatedContainer(
                duration: DSMotion.slow,
                curve: DSMotion.standard,
                margin: const EdgeInsets.symmetric(horizontal: DSSpacing.xxs),
                height: 32 + ((step.position + i) % 4) * 20,
                decoration: BoxDecoration(
                  color: palette[i],
                  borderRadius: ds.radii.surfaceAll,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TryItHint extends StatelessWidget {
  const _TryItHint();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Row(
      children: [
        Icon(
          ds.select(
            material: Icons.touch_app_outlined,
            cupertino: CupertinoIcons.hand_draw,
          ),
          size: 18,
          color: ds.colors.brand,
        ),
        const DSGap.sm(),
        Expanded(
          child: DSText(
            context.l10n.onboardingTryIt,
            role: DSTextRole.caption,
            color: ds.colors.brand,
          ),
        ),
      ],
    );
  }
}

class _LivePreview extends StatelessWidget {
  const _LivePreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSText(
          context.l10n.onboardingLivePreview,
          role: DSTextRole.label,
          color: context.ds.colors.onSurfaceMuted,
        ),
        const DSGap.sm(),
        DSCard(child: child),
      ],
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    return DSListSection(
      rows: [
        DSListRow(
          title: l10n.foundationsColor,
          subtitle: l10n.foundationsColorDescription,
          leading: ds.select(
            material: Icons.palette_outlined,
            cupertino: CupertinoIcons.paintbrush,
          ),
        ),
        DSListRow(
          title: l10n.foundationsTypography,
          subtitle: l10n.foundationsTypographyDescription,
          leading: ds.select(
            material: Icons.text_fields,
            cupertino: CupertinoIcons.textformat,
          ),
        ),
        DSListRow(
          title: l10n.foundationsMotion,
          subtitle: l10n.foundationsMotionDescription,
          leading: ds.select(
            material: Icons.animation,
            cupertino: CupertinoIcons.timer,
          ),
        ),
      ],
    );
  }
}

class _DesignLanguageContent extends ConsumerWidget {
  const _DesignLanguageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<DesignLanguagePreference>(
          value: settings.designLanguage,
          onChanged: controller.setDesignLanguage,
          segments: [
            DSSegment(
              value: DesignLanguagePreference.system,
              label: l10n.designLanguageAutomatic,
            ),
            DSSegment(
              value: DesignLanguagePreference.material,
              label: l10n.designLanguageMaterial,
            ),
            DSSegment(
              value: DesignLanguagePreference.cupertino,
              label: l10n.designLanguageCupertino,
            ),
          ],
        ),
        const DSGap.xl(),
        _LivePreview(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DSTextField(
                label: l10n.bookingFieldName,
                placeholder: l10n.bookingFieldNameHint,
              ),
              const DSGap.lg(),
              const _PreviewSwitchRow(),
              const DSGap.lg(),
              DSButton(
                label: l10n.commonConfirm,
                expand: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSwitchRow extends StatefulWidget {
  const _PreviewSwitchRow();

  @override
  State<_PreviewSwitchRow> createState() => _PreviewSwitchRowState();
}

class _PreviewSwitchRowState extends State<_PreviewSwitchRow> {
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: DSText(l10n.bookingFlexibleFare, maxLines: 1)),
        DSSwitch(
          value: _isOn,
          semanticLabel: l10n.bookingFlexibleFare,
          onChanged: (next) => setState(() => _isOn = next),
        ),
      ],
    );
  }
}

class _AppearanceContent extends ConsumerWidget {
  const _AppearanceContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ds = context.ds;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<AppThemeMode>(
          value: settings.themeMode,
          onChanged: controller.setThemeMode,
          segments: [
            DSSegment(value: AppThemeMode.system, label: l10n.themeModeSystem),
            DSSegment(value: AppThemeMode.light, label: l10n.themeModeLight),
            DSSegment(value: AppThemeMode.dark, label: l10n.themeModeDark),
          ],
        ),
        const DSGap.xl(),
        BrandPicker(selected: settings.brand, onSelected: controller.setBrand),
        const DSGap.xl(),
        _LivePreview(
          child: Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: [
              for (final entry in ds.colors.catalogue.entries)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.value,
                    borderRadius: ds.radii.compactAll,
                    border: Border.all(color: ds.colors.separator),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageContent extends ConsumerWidget {
  const _LanguageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final sampleDate = DateTime(2026, 3, 22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<AppLanguage>(
          value: AppLanguage.supported.contains(settings.language)
              ? settings.language
              : AppLanguage.english,
          onChanged: controller.setLanguage,
          segments: [
            DSSegment(value: AppLanguage.english, label: l10n.languageEnglish),
            DSSegment(
              value: AppLanguage.portuguese,
              label: l10n.languagePortuguese,
            ),
            DSSegment(value: AppLanguage.german, label: l10n.languageGerman),
          ],
        ),
        const DSGap.xl(),
        _LivePreview(
          child: DSListSection(
            rows: [
              DSListRow(
                title: l10n.bookingDeparture,
                additionalInfo: l10n.bookingDepartureValue(sampleDate),
              ),
              DSListRow(
                title: l10n.bookingPassengers,
                additionalInfo: l10n.bookingPassengerCount(3),
              ),
              DSListRow(
                title: l10n.bookingTotal,
                additionalInfo: l10n.bookingTotalValue(1234.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TourContent extends StatelessWidget {
  const _TourContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    return DSListSection(
      rows: [
        DSListRow(
          title: l10n.navFoundations,
          subtitle: l10n.onboardingTourFoundations,
          leading: ds.select(
            material: Icons.palette_outlined,
            cupertino: CupertinoIcons.paintbrush,
          ),
        ),
        DSListRow(
          title: l10n.navComponents,
          subtitle: l10n.onboardingTourComponents,
          leading: ds.select(
            material: Icons.widgets_outlined,
            cupertino: CupertinoIcons.square_stack_3d_up,
          ),
        ),
        DSListRow(
          title: l10n.navPlayground,
          subtitle: l10n.onboardingTourPlayground,
          leading: ds.select(
            material: Icons.science_outlined,
            cupertino: CupertinoIcons.wand_stars,
          ),
        ),
        DSListRow(
          title: l10n.navSettings,
          subtitle: l10n.onboardingTourSettings,
          leading: ds.select(
            material: Icons.settings_outlined,
            cupertino: CupertinoIcons.settings,
          ),
        ),
      ],
    );
  }
}
