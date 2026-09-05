import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The data of one line inside a [DSListSection].
///
/// It is a plain class, not a widget: the section decides how to draw it on
/// Material and on Cupertino.
class DSListRow {
  const DSListRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.additionalInfo,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final String? subtitle;

  /// Icon shown before the title.
  final IconData? leading;

  /// Widget shown at the end of the row, for example a switch.
  final Widget? trailing;

  /// Grey text shown at the end of the row, for example the current value.
  final String? additionalInfo;

  final VoidCallback? onTap;

  /// Paints the row in red, for actions like "Delete".
  final bool isDestructive;
}

/// A group of rows with an optional header and footer.
class DSListSection extends StatelessWidget {
  const DSListSection({
    required this.rows,
    this.header,
    this.footer,
    super.key,
  });

  final List<DSListRow> rows;
  final String? header;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    if (context.ds.isCupertino) return _buildCupertino(context);
    return _buildMaterial(context);
  }

  /// Cupertino already has inset grouped lists, so we only feed it our colours.
  Widget _buildCupertino(BuildContext context) {
    final ds = context.ds;

    return CupertinoListSection.insetGrouped(
      backgroundColor: ds.colors.surface,
      decoration: BoxDecoration(
        color: ds.colors.surfaceElevated,
        borderRadius: ds.radii.surfaceAll,
      ),
      separatorColor: ds.colors.separator,
      margin: const EdgeInsets.only(bottom: DSSpacing.lg),
      header: header == null
          ? null
          : DSText(
              header!,
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
      footer: footer == null
          ? null
          : DSText(
              footer!,
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
      children: [
        for (final row in rows)
          CupertinoListTile.notched(
            backgroundColor: ds.colors.surfaceElevated,
            onTap: row.onTap,
            title: DSText(
              row.title,
              color: row.isDestructive ? ds.colors.danger : ds.colors.onSurface,
            ),
            subtitle: row.subtitle == null
                ? null
                : DSText(
                    row.subtitle!,
                    role: DSTextRole.caption,
                    color: ds.colors.onSurfaceMuted,
                  ),
            leading: row.leading == null
                ? null
                : Icon(row.leading, color: ds.colors.brand, size: 22),
            additionalInfo: row.additionalInfo == null
                ? null
                : _TrailingInfo(text: row.additionalInfo!),
            // A tappable row without a custom trailing gets the iOS chevron.
            trailing:
                row.trailing ??
                (row.onTap == null ? null : const CupertinoListTileChevron()),
          ),
      ],
    );
  }

  /// Material has no grouped list, so we build a card with dividers.
  Widget _buildMaterial(BuildContext context) {
    final ds = context.ds;

    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DSSpacing.xs,
                0,
                DSSpacing.xs,
                DSSpacing.sm,
              ),
              child: DSText(
                header!,
                role: DSTextRole.label,
                color: ds.colors.brand,
              ),
            ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  // A divider between rows, but not above the first one.
                  if (i > 0) const Divider(height: 1, indent: DSSpacing.lg),
                  _MaterialRow(row: rows[i]),
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DSSpacing.xs,
                DSSpacing.sm,
                DSSpacing.xs,
                0,
              ),
              child: DSText(
                footer!,
                role: DSTextRole.caption,
                color: ds.colors.onSurfaceMuted,
              ),
            ),
        ],
      ),
    );
  }
}

/// One [DSListRow] drawn as a Material `ListTile`.
class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.row});

  final DSListRow row;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final titleColor = row.isDestructive
        ? ds.colors.danger
        : ds.colors.onSurface;

    return ListTile(
      onTap: row.onTap,
      leading: row.leading == null
          ? null
          : Icon(
              row.leading,
              color: row.isDestructive ? ds.colors.danger : null,
            ),
      title: DSText(row.title, role: DSTextRole.subtitle, color: titleColor),
      subtitle: row.subtitle == null
          ? null
          : DSText(
              row.subtitle!,
              role: DSTextRole.caption,
              color: ds.colors.onSurfaceMuted,
            ),
      trailing: _buildTrailing(ds),
    );
  }

  /// A custom widget wins; then the grey text; otherwise a tappable row gets
  /// a chevron and everything else gets nothing.
  Widget? _buildTrailing(DSThemeData ds) {
    if (row.trailing != null) return row.trailing;
    if (row.additionalInfo != null) {
      return _TrailingInfo(text: row.additionalInfo!);
    }
    if (row.onTap != null) {
      return Icon(Icons.chevron_right, color: ds.colors.onSurfaceMuted);
    }
    return null;
  }
}

/// The grey text at the end of a row, capped so a long value wraps instead of
/// squeezing the title.
class _TrailingInfo extends StatelessWidget {
  const _TrailingInfo({required this.text});

  static const double _maxWidth = 168;

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: DSText(
        text,
        role: DSTextRole.caption,
        color: context.ds.colors.onSurfaceMuted,
        textAlign: TextAlign.end,
        maxLines: 2,
      ),
    );
  }
}
