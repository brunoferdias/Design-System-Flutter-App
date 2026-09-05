import 'package:design_system_flutter/core/app_info.dart';
import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the user drives the whole demonstration.
///
/// Four controls, four rebuilds of the entire app: design language, theme,
/// brand seed and language. Every one of them flows through the same
/// `SettingsController` → `AppSettings` → `DSThemeData` pipeline.
final class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ds = context.ds;
    final AppSettings settings = ref.watch(settingsProvider);
    final SettingsController controller = ref.read(settingsProvider.notifier);

    return DSScaffold(
      title: l10n.settingsTitle,
      body: DSPageBody(
        children: <Widget>[
          // --- Design language ---------------------------------------------
          DSSectionHeader(
            title: l10n.settingsSectionDesignLanguage,
            description: l10n.settingsDesignLanguageDescription,
            topPadding: 0,
          ),
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
          const DSGap.md(),
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

          // --- Appearance ---------------------------------------------------
          DSSectionHeader(title: l10n.settingsSectionAppearance),
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
          DSText(l10n.settingsBrandColor, role: DSTextRole.subtitle),
          const DSGap.xs(),
          DSText(
            l10n.settingsBrandColorDescription,
            role: DSTextRole.caption,
            color: ds.colors.onSurfaceMuted,
          ),
          const DSGap.md(),
          _BrandPicker(
            selected: settings.brand,
            onSelected: controller.setBrand,
          ),

          // --- Language -----------------------------------------------------
          DSSectionHeader(
            title: l10n.settingsSectionLanguage,
            description: l10n.settingsLanguageDescription,
          ),
          DSListSection(
            rows: <DSListRow>[
              for (final AppLanguage language in AppLanguage.values)
                DSListRow(
                  title: _languageLabel(context, language),
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

          // --- About --------------------------------------------------------
          DSSectionHeader(title: l10n.settingsSectionAbout),
          DSListSection(
            rows: <DSListRow>[
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

  static String _languageLabel(BuildContext context, AppLanguage language) {
    final l10n = context.l10n;
    return switch (language) {
      AppLanguage.system => l10n.languageSystem,
      AppLanguage.english => l10n.languageEnglish,
      AppLanguage.portuguese => l10n.languagePortuguese,
      AppLanguage.german => l10n.languageGerman,
    };
  }

  static Future<void> _copyRepositoryUrl(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: AppInfo.repositoryUrl));
    if (!context.mounted) return;
    DSFeedback.toast(context, context.l10n.commonCopied);
  }

  static Future<void> _confirmReset(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.l10n;
    final bool confirmed = await DSFeedback.confirm(
      context,
      title: l10n.settingsResetTitle,
      message: l10n.settingsResetMessage,
      confirmLabel: l10n.commonReset,
      cancelLabel: l10n.commonCancel,
      isDestructive: true,
    );
    if (!confirmed) return;
    await controller.reset();
    if (!context.mounted) return;
    // Read the localizations again: resetting may have changed the language.
    DSFeedback.toast(context, context.l10n.settingsResetDone);
  }
}

/// The brand seed picker: four swatches, one of which is selected.
final class _BrandPicker extends StatelessWidget {
  const _BrandPicker({required this.selected, required this.onSelected});

  final DSBrand selected;
  final ValueChanged<DSBrand> onSelected;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Row(
      children: <Widget>[
        for (final DSBrand brand in DSBrand.values)
          Expanded(
            child: Semantics(
              button: true,
              selected: brand == selected,
              label: _label(context, brand),
              child: GestureDetector(
                onTap: () => onSelected(brand),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DSSpacing.xs,
                  ),
                  child: Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: DSMotion.fast,
                        curve: DSMotion.standard,
                        height: 56,
                        decoration: BoxDecoration(
                          color: brand.seed,
                          borderRadius: ds.radii.surfaceAll,
                          border: Border.all(
                            color: brand == selected
                                ? ds.colors.onSurface
                                : ds.colors.separator,
                            width: brand == selected ? 3 : 1,
                          ),
                        ),
                      ),
                      const DSGap.xs(),
                      DSText(
                        _label(context, brand),
                        role: DSTextRole.caption,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static String _label(BuildContext context, DSBrand brand) {
    final l10n = context.l10n;
    return switch (brand) {
      DSBrand.aurora => l10n.brandColorAurora,
      DSBrand.forest => l10n.brandColorForest,
      DSBrand.sunset => l10n.brandColorSunset,
      DSBrand.graphite => l10n.brandColorGraphite,
    };
  }
}
