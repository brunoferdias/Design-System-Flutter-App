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

final class OnboardingStepView extends StatelessWidget {
  const OnboardingStepView({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    final (String title, String body) = switch (step) {
      OnboardingStep.welcome => (
        l10n.onboardingWelcomeTitle,
        l10n.onboardingWelcomeBody,
      ),
      OnboardingStep.designLanguage => (
        l10n.onboardingDesignLanguageTitle,
        l10n.onboardingDesignLanguageBody,
      ),
      OnboardingStep.appearance => (
        l10n.onboardingAppearanceTitle,
        l10n.onboardingAppearanceBody,
      ),
      OnboardingStep.language => (
        l10n.onboardingLanguageTitle,
        l10n.onboardingLanguageBody,
      ),
      OnboardingStep.tour => (
        l10n.onboardingTourTitle,
        l10n.onboardingTourBody,
      ),
    };

    return DSPageBody(
      children: <Widget>[
        _StepArtwork(step: step),
        const DSGap.xl(),
        DSText(title, role: DSTextRole.display),
        const DSGap.sm(),
        DSText(body, color: ds.colors.onSurfaceMuted),
        const DSGap.xl(),
        switch (step) {
          OnboardingStep.welcome => const _WelcomeContent(),
          OnboardingStep.designLanguage => const _DesignLanguageContent(),
          OnboardingStep.appearance => const _AppearanceContent(),
          OnboardingStep.language => const _LanguageContent(),
          OnboardingStep.tour => const _TourContent(),
        },
      ],
    );
  }
}

final class _StepArtwork extends StatelessWidget {
  const _StepArtwork({required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final List<Color> palette = <Color>[
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
        children: <Widget>[
          for (int i = 0; i < palette.length; i++)
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

final class _TryItHint extends StatelessWidget {
  const _TryItHint();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Row(
      children: <Widget>[
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

final class _LivePreview extends StatelessWidget {
  const _LivePreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
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

final class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;
    return DSListSection(
      rows: <DSListRow>[
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

final class _DesignLanguageContent extends ConsumerWidget {
  const _DesignLanguageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsController controller = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<DesignLanguagePreference>(
          value: settings.designLanguage,
          onChanged: controller.setDesignLanguage,
          segments: <DSSegment<DesignLanguagePreference>>[
            DSSegment<DesignLanguagePreference>(
              value: DesignLanguagePreference.system,
              label: l10n.designLanguageAutomatic,
            ),
            DSSegment<DesignLanguagePreference>(
              value: DesignLanguagePreference.material,
              label: l10n.designLanguageMaterial,
            ),
            DSSegment<DesignLanguagePreference>(
              value: DesignLanguagePreference.cupertino,
              label: l10n.designLanguageCupertino,
            ),
          ],
        ),
        const DSGap.xl(),
        _LivePreview(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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

final class _PreviewSwitchRow extends StatefulWidget {
  const _PreviewSwitchRow();

  @override
  State<_PreviewSwitchRow> createState() => _PreviewSwitchRowState();
}

class _PreviewSwitchRowState extends State<_PreviewSwitchRow> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: DSText(l10n.bookingFlexibleFare, maxLines: 1)),
        DSSwitch(
          value: _value,
          semanticLabel: l10n.bookingFlexibleFare,
          onChanged: (bool next) => setState(() => _value = next),
        ),
      ],
    );
  }
}

final class _AppearanceContent extends ConsumerWidget {
  const _AppearanceContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ds = context.ds;
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsController controller = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<AppThemeMode>(
          value: settings.themeMode,
          onChanged: controller.setThemeMode,
          segments: <DSSegment<AppThemeMode>>[
            DSSegment<AppThemeMode>(
              value: AppThemeMode.system,
              label: l10n.themeModeSystem,
            ),
            DSSegment<AppThemeMode>(
              value: AppThemeMode.light,
              label: l10n.themeModeLight,
            ),
            DSSegment<AppThemeMode>(
              value: AppThemeMode.dark,
              label: l10n.themeModeDark,
            ),
          ],
        ),
        const DSGap.xl(),
        BrandPicker(selected: settings.brand, onSelected: controller.setBrand),
        const DSGap.xl(),
        _LivePreview(
          child: Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: <Widget>[
              for (final MapEntry<String, Color> entry
                  in ds.colors.catalogue.entries)
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

final class _LanguageContent extends ConsumerWidget {
  const _LanguageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsController controller = ref.read(settingsProvider.notifier);
    final DateTime sample = DateTime(2026, 3, 22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _TryItHint(),
        const DSGap.md(),
        DSSegmentedControl<AppLanguage>(
          value: AppLanguage.supported.contains(settings.language)
              ? settings.language
              : AppLanguage.english,
          onChanged: controller.setLanguage,
          segments: <DSSegment<AppLanguage>>[
            DSSegment<AppLanguage>(
              value: AppLanguage.english,
              label: l10n.languageEnglish,
            ),
            DSSegment<AppLanguage>(
              value: AppLanguage.portuguese,
              label: l10n.languagePortuguese,
            ),
            DSSegment<AppLanguage>(
              value: AppLanguage.german,
              label: l10n.languageGerman,
            ),
          ],
        ),
        const DSGap.xl(),
        _LivePreview(
          child: DSListSection(
            rows: <DSListRow>[
              DSListRow(
                title: l10n.bookingDeparture,
                additionalInfo: l10n.bookingDepartureValue(sample),
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

final class _TourContent extends StatelessWidget {
  const _TourContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;
    return DSListSection(
      rows: <DSListRow>[
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
