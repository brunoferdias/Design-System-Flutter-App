import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The first tab: shows the design tokens themselves.
///
/// Everything on this page is read from the current theme, so changing the
/// brand or the design language changes what you see here.
class FoundationsPage extends StatelessWidget {
  const FoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    return DSScaffold(
      title: l10n.foundationsTitle,
      body: DSPageBody(
        children: [
          DSText(l10n.appTagline, role: DSTextRole.display),
          const DSGap.sm(),
          DSText(l10n.foundationsSubtitle, color: ds.colors.onSurfaceMuted),
          const DSGap.md(),

          // A quick summary of what the app is currently rendering with.
          Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: [
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

/// Turns a colour into the "#AARRGGBB" text shown under each swatch.
String _toHex(Color color) {
  final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${value.toUpperCase()}';
}

/// Every colour role, as tappable swatches.
class _ColorTokens extends StatelessWidget {
  const _ColorTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSText(
          l10n.foundationsTapToCopy,
          role: DSTextRole.caption,
          color: ds.colors.onSurfaceMuted,
        ),
        const DSGap.md(),
        Wrap(
          spacing: DSSpacing.md,
          runSpacing: DSSpacing.md,
          children: [
            for (final entry in ds.colors.catalogue.entries)
              _Swatch(role: entry.key, color: entry.value),
          ],
        ),
      ],
    );
  }
}

/// One colour: the sample, its role name and its hex code. Tapping copies it.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.role, required this.color});

  final String role;
  final Color color;

  Future<void> _copyToClipboard(BuildContext context) async {
    final hex = _toHex(color);
    await Clipboard.setData(ClipboardData(text: hex));

    // The clipboard call is asynchronous, so the page may be gone by now.
    if (!context.mounted) return;
    DSFeedback.toast(context, context.l10n.commonCopied);
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final hex = _toHex(color);

    return Semantics(
      button: true,
      label: context.l10n.a11yColorSwatch(role, hex),
      child: GestureDetector(
        onTap: () => _copyToClipboard(context),
        child: SizedBox(
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: ds.radii.compactAll,
                  // A border so white on white is still visible.
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

/// Every text style, written in its own style.
class _TypographyTokens extends StatelessWidget {
  const _TypographyTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return DSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in ds.typography.catalogue.entries) ...[
            Text(entry.key, style: entry.value, maxLines: 1),
            DSText(
              _describeStyle(entry.value),
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
            const DSGap.lg(),
          ],
        ],
      ),
    );
  }

  /// For example "14pt - w400 - 20pt line".
  String _describeStyle(TextStyle style) {
    final size = style.fontSize ?? 0;
    final weight = style.fontWeight?.value ?? 400;
    final lineHeight = ((style.height ?? 1) * size).round();

    return '${size.toStringAsFixed(0)}pt · '
        'w$weight · '
        '${lineHeight}pt line';
  }
}

/// The spacing scale, drawn as bars whose width is the value itself.
class _SpacingTokens extends StatelessWidget {
  const _SpacingTokens();

  static const Map<String, double> _scale = {
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
        children: [
          for (final entry in _scale.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: DSText(entry.key, role: DSTextRole.caption),
                  ),
                  Container(
                    width: entry.value,
                    height: 16,
                    decoration: BoxDecoration(
                      color: ds.colors.brand,
                      borderRadius: ds.radii.compactAll,
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

/// The corner radii, drawn on identical boxes.
class _RadiusTokens extends StatelessWidget {
  const _RadiusTokens();

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final radii = {
      'compact': ds.radii.compact,
      'control': ds.radii.control,
      'surface': ds.radii.surface,
      'modal': ds.radii.modal,
      'pill': DSRadii.pill,
    };

    return Wrap(
      spacing: DSSpacing.md,
      runSpacing: DSSpacing.md,
      children: [
        for (final entry in radii.entries)
          Column(
            children: [
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

/// The shadow levels. On Cupertino they all look flat, which is on purpose.
class _ElevationTokens extends StatelessWidget {
  const _ElevationTokens();

  static const Map<String, double> _levels = {
    'level0': DSElevation.level0,
    'level1': DSElevation.level1,
    'level2': DSElevation.level2,
    'level3': DSElevation.level3,
  };

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Wrap(
      spacing: DSSpacing.lg,
      runSpacing: DSSpacing.lg,
      children: [
        for (final entry in _levels.entries)
          Column(
            children: [
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

/// The durations, as dots that race across the card when you tap it.
class _MotionTokens extends StatefulWidget {
  const _MotionTokens();

  @override
  State<_MotionTokens> createState() => _MotionTokensState();
}

class _MotionTokensState extends State<_MotionTokens> {
  static const Map<String, Duration> _durations = {
    'instant': DSMotion.instant,
    'fast': DSMotion.fast,
    'normal': DSMotion.normal,
    'slow': DSMotion.slow,
  };

  /// Which side the dots are parked on. Tapping the card flips it.
  bool _isOnTheRight = false;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return DSCard(
      onTap: () => setState(() => _isOnTheRight = !_isOnTheRight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in _durations.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: DSSpacing.md),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: DSText(entry.key, role: DSTextRole.caption),
                  ),
                  Expanded(
                    child: AnimatedAlign(
                      // Same distance, different duration: that is the point.
                      duration: entry.value,
                      curve: DSMotion.standard,
                      alignment: _isOnTheRight
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
