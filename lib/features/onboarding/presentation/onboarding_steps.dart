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

/// The content of one introduction step.
///
/// Every step has the same shape -- artwork, title, text -- and then its own
/// widget at the bottom.
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

/// The bars at the top of each step.
///
/// They are just the theme colours at different heights; the heights depend on
/// the step, so the artwork changes as you move through the introduction.
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
                // Cycles through four heights so the bars look uneven.
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

/// The "you can try this right here" line above an interactive step.
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

/// A card showing what the choice above it does, updated live.
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

/// Step 1: what the app is about.
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

/// Step 2: Material or Cupertino. Picking one re-skins the app immediately,
/// including this very page.
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

/// A switch in the preview card that really works, so the user can feel the
/// difference between the two design languages.
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

/// Step 3: light/dark and the brand colour, previewed as a live palette.
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

/// Step 4: the language. The preview shows a date and a price, which is where
/// translation differences are easiest to see.
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
          // The control has no "system" option, so while the user is still on
          // the default we show English as the selected one.
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

/// Step 5: what each tab of the app is for.
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
