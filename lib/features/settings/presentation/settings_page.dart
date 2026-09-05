import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/core/app_info.dart';
import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/presentation/brand_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The fourth tab: every preference, plus the "about" section.
///
/// The page only reads the settings and calls the controller; it never saves
/// anything itself.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ds = context.ds;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return DSScaffold(
      title: l10n.settingsTitle,
      body: DSPageBody(
        children: [
          DSSectionHeader(
            title: l10n.settingsSectionDesignLanguage,
            description: l10n.settingsDesignLanguageDescription,
            // No space above: this is the first thing on the page.
            topPadding: 0,
          ),
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
          const DSGap.md(),
          // "Automatic" does not say which one won, so we spell it out. The
          // live region makes screen readers announce the change.
          Semantics(
            liveRegion: true,
            child: DSText(
              l10n.a11yCurrentDesignLanguage(
                ds.select(
                  material: l10n.designLanguageMaterial,
                  cupertino: l10n.designLanguageCupertino,
                ),
              ),
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
          ),

          DSSectionHeader(title: l10n.settingsSectionAppearance),
          DSSegmentedControl<AppThemeMode>(
            value: settings.themeMode,
            onChanged: controller.setThemeMode,
            segments: [
              DSSegment(
                value: AppThemeMode.system,
                label: l10n.themeModeSystem,
              ),
              DSSegment(value: AppThemeMode.light, label: l10n.themeModeLight),
              DSSegment(value: AppThemeMode.dark, label: l10n.themeModeDark),
            ],
          ),
          const DSGap.xl(),
          DSText(l10n.settingsBrandColor, role: DSTextRole.subtitle),
          const DSGap.xs(),
          DSText(
            l10n.settingsBrandColorDescription,
            role: DSTextRole.caption,
            color: ds.colors.onSurfaceMuted,
          ),
          const DSGap.md(),
          BrandPicker(
            selected: settings.brand,
            onSelected: controller.setBrand,
          ),

          DSSectionHeader(
            title: l10n.settingsSectionLanguage,
            description: l10n.settingsLanguageDescription,
          ),
          DSListSection(
            rows: [
              for (final language in AppLanguage.values)
                DSListRow(
                  title: _languageLabel(context, language),
                  // A tick marks the one in use.
                  leading: settings.language == language
                      ? ds.select(
                          material: Icons.check,
                          cupertino: CupertinoIcons.check_mark,
                        )
                      : null,
                  onTap: () => controller.setLanguage(language),
                ),
            ],
          ),

          DSSectionHeader(title: l10n.settingsSectionAbout),
          DSListSection(
            rows: [
              DSListRow(
                title: l10n.settingsVersion(AppInfo.version),
                leading: ds.select(
                  material: Icons.info_outline,
                  cupertino: CupertinoIcons.info,
                ),
              ),
              DSListRow(
                title: l10n.settingsSourceCode,
                subtitle: AppInfo.repositoryUrl,
                leading: ds.select(
                  material: Icons.code,
                  cupertino: CupertinoIcons.chevron_left_slash_chevron_right,
                ),
                onTap: () => _copyRepositoryUrl(context),
              ),
              DSListRow(
                title: l10n.settingsReplayIntro,
                leading: ds.select(
                  material: Icons.slideshow_outlined,
                  cupertino: CupertinoIcons.play_rectangle,
                ),
                // Clearing the flag is not enough: the router only reads it
                // during a navigation, so we also navigate.
                onTap: () {
                  controller.replayOnboarding();
                  context.goNamed(AppRoute.onboarding.routeName);
                },
              ),
              DSListRow(
                title: l10n.settingsResetTitle,
                isDestructive: true,
                leading: ds.select(
                  material: Icons.restart_alt,
                  cupertino: CupertinoIcons.arrow_counterclockwise,
                ),
                onTap: () => _confirmReset(context, controller),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copyRepositoryUrl(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: AppInfo.repositoryUrl));

    if (!context.mounted) return;
    DSFeedback.toast(context, context.l10n.commonCopied);
  }

  /// Resetting cannot be undone, so we ask first.
  Future<void> _confirmReset(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.l10n;

    final confirmed = await DSFeedback.confirm(
      context,
      title: l10n.settingsResetTitle,
      message: l10n.settingsResetMessage,
      confirmLabel: l10n.commonReset,
      cancelLabel: l10n.commonCancel,
      isDestructive: true,
    );
    if (!confirmed) return;

    await controller.reset();

    // Both the dialog and the reset were awaited, so check the page is still
    // there before showing the toast.
    if (!context.mounted) return;
    DSFeedback.toast(context, l10n.settingsResetDone);
  }
}

String _languageLabel(BuildContext context, AppLanguage language) {
  final l10n = context.l10n;

  switch (language) {
    case AppLanguage.system:
      return l10n.languageSystem;
    case AppLanguage.english:
      return l10n.languageEnglish;
    case AppLanguage.portuguese:
      return l10n.languagePortuguese;
    case AppLanguage.german:
      return l10n.languageGerman;
  }
}
