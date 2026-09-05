import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final class FoundationsPage extends StatelessWidget {
  const FoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    return DSScaffold(
      title: l10n.foundationsTitle,
      body: DSPageBody(
        children: <Widget>[
          DSText(l10n.appTagline, role: DSTextRole.display),
          const DSGap.sm(),
          DSText(
            l10n.foundationsSubtitle,
            role: DSTextRole.body,
            color: ds.colors.onSurfaceMuted,
          ),
          const DSGap.md(),
          Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: <Widget>[
              DSBadge(
                ds.select(material: 'Material 3', cupertino: 'Cupertino'),
                tone: DSBadgeTone.brand,
              ),
              DSBadge(
                ds.isDark ? l10n.themeModeDark : l10n.themeModeLight,
                tone: DSBadgeTone.info,
              ),
              DSBadge(ds.brand.name),
            ],
          ),

          DSSectionHeader(
            title: l10n.foundationsColor,
            description: l10n.foundationsColorDescription,
          ),
          const _ColorTokens(),

          DSSectionHeader(
            title: l10n.foundationsTypography,
            description: l10n.foundationsTypographyDescription,
          ),
          const _TypographyTokens(),

          DSSectionHeader(
            title: l10n.foundationsSpacing,
            description: l10n.foundationsSpacingDescription,
          ),
          const _SpacingTokens(),

          DSSectionHeader(
            title: l10n.foundationsRadius,
            description: l10n.foundationsRadiusDescription,
          ),
          const _RadiusTokens(),

          DSSectionHeader(
            title: l10n.foundationsElevation,
            description: l10n.foundationsElevationDescription,
          ),
          const _ElevationTokens(),

          DSSectionHeader(
            title: l10n.foundationsMotion,
            description: l10n.foundationsMotionDescription,
          ),
          const _MotionTokens(),
        ],
      ),
    );
  }
}

String _hex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

final class _ColorTokens extends StatelessWidget {
  const _ColorTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final l10n = context.l10n;
    final Map<String, Color> catalogue = ds.colors.catalogue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DSText(
          l10n.foundationsTapToCopy,
          role: DSTextRole.caption,
          color: ds.colors.onSurfaceMuted,
        ),
        const DSGap.md(),
        Wrap(
          spacing: DSSpacing.md,
          runSpacing: DSSpacing.md,
          children: <Widget>[
            for (final MapEntry<String, Color> entry in catalogue.entries)
              _Swatch(role: entry.key, color: entry.value),
          ],
        ),
      ],
    );
  }
}

final class _Swatch extends StatelessWidget {
  const _Swatch({required this.role, required this.color});
  final String role;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final String hex = _hex(color);

    return Semantics(
      button: true,
      label: context.l10n.a11yColorSwatch(role, hex),
      child: GestureDetector(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: hex));
          if (!context.mounted) return;
          DSFeedback.toast(context, context.l10n.commonCopied);
        },
        child: SizedBox(
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: ds.radii.compactAll,
                  border: Border.all(color: ds.colors.separator),
                ),
              ),
              const DSGap.xs(),
              DSText(role, role: DSTextRole.caption, maxLines: 1),
              DSText(
                hex,
                role: DSTextRole.caption,
                color: ds.colors.onSurfaceMuted,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _TypographyTokens extends StatelessWidget {
  const _TypographyTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return DSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final MapEntry<String, TextStyle> entry
              in ds.typography.catalogue.entries) ...<Widget>[
            Text(entry.key, style: entry.value, maxLines: 1),
            DSText(
              '${entry.value.fontSize?.toStringAsFixed(0)}pt · '
              'w${entry.value.fontWeight?.value ?? 400} · '
              '${((entry.value.height ?? 1) * (entry.value.fontSize ?? 0)).round()}pt line',
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
            const DSGap.lg(),
          ],
        ],
      ),
    );
  }
}

final class _SpacingTokens extends StatelessWidget {
  const _SpacingTokens();

  static const Map<String, double> _scale = <String, double>{
    'xxs': DSSpacing.xxs,
    'xs': DSSpacing.xs,
    'sm': DSSpacing.sm,
    'md': DSSpacing.md,
    'lg': DSSpacing.lg,
    'xl': DSSpacing.xl,
    'xxl': DSSpacing.xxl,
    'xxxl': DSSpacing.xxxl,
  };

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return DSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final MapEntry<String, double> entry in _scale.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.sm),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 48,
                    child: DSText(entry.key, role: DSTextRole.caption),
                  ),
                  Container(
                    width: entry.value,
                    height: 16,
                    decoration: BoxDecoration(
                      color: ds.colors.brand,
                      borderRadius: BorderRadius.all(ds.radii.compact),
                    ),
                  ),
                  const DSGap.sm(),
                  DSText(
                    '${entry.value.toStringAsFixed(0)}dp',
                    role: DSTextRole.caption,
                    color: ds.colors.onSurfaceMuted,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final class _RadiusTokens extends StatelessWidget {
  const _RadiusTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Map<String, Radius> radii = <String, Radius>{
      'compact': ds.radii.compact,
      'control': ds.radii.control,
      'surface': ds.radii.surface,
      'modal': ds.radii.modal,
      'pill': DSRadii.pill,
    };

    return Wrap(
      spacing: DSSpacing.md,
      runSpacing: DSSpacing.md,
      children: <Widget>[
        for (final MapEntry<String, Radius> entry in radii.entries)
          Column(
            children: <Widget>[
              Container(
                width: 88,
                height: 64,
                decoration: BoxDecoration(
                  color: ds.colors.brandSubtle,
                  borderRadius: BorderRadius.all(entry.value),
                ),
              ),
              const DSGap.xs(),
              DSText(entry.key, role: DSTextRole.caption),
              DSText(
                '${entry.value.x.toStringAsFixed(0)}dp',
                role: DSTextRole.caption,
                color: ds.colors.onSurfaceMuted,
              ),
            ],
          ),
      ],
    );
  }
}

final class _ElevationTokens extends StatelessWidget {
  const _ElevationTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    const Map<String, double> levels = <String, double>{
      'level0': DSElevation.level0,
      'level1': DSElevation.level1,
      'level2': DSElevation.level2,
      'level3': DSElevation.level3,
    };

    return Wrap(
      spacing: DSSpacing.lg,
      runSpacing: DSSpacing.lg,
      children: <Widget>[
        for (final MapEntry<String, double> entry in levels.entries)
          Column(
            children: <Widget>[
              Container(
                width: 88,
                height: 64,
                decoration: BoxDecoration(
                  color: ds.colors.surfaceElevated,
                  borderRadius: ds.radii.surfaceAll,
                  border: Border.all(color: ds.colors.separator),
                  boxShadow: ds.elevation.shadow(
                    entry.value,
                    shadowColor: ds.colors.shadow,
                  ),
                ),
              ),
              const DSGap.xs(),
              DSText(entry.key, role: DSTextRole.caption),
            ],
          ),
      ],
    );
  }
}

final class _MotionTokens extends StatefulWidget {
  const _MotionTokens();

  @override
  State<_MotionTokens> createState() => _MotionTokensState();
}

class _MotionTokensState extends State<_MotionTokens> {
  static const Map<String, Duration> _durations = <String, Duration>{
    'instant': DSMotion.instant,
    'fast': DSMotion.fast,
    'normal': DSMotion.normal,
    'slow': DSMotion.slow,
  };

  bool _extended = false;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return DSCard(
      onTap: () => setState(() => _extended = !_extended),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final MapEntry<String, Duration> entry in _durations.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.md),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 64,
                    child: DSText(entry.key, role: DSTextRole.caption),
                  ),
                  Expanded(
                    child: AnimatedAlign(
                      duration: entry.value,
                      curve: DSMotion.standard,
                      alignment: _extended
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: ds.colors.brand,
                          borderRadius: DSRadii.pillAll,
                        ),
                      ),
                    ),
                  ),
                  DSText(
                    '${entry.value.inMilliseconds}ms',
                    role: DSTextRole.caption,
                    color: ds.colors.onSurfaceMuted,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
