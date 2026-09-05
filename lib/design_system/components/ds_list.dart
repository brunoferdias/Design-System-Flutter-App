import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
final class DSListRow {
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
  final IconData? leading;
  final Widget? trailing;
  final String? additionalInfo;
  final VoidCallback? onTap;
  final bool isDestructive;
}

final class DSListSection extends StatelessWidget {
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
  Widget build(BuildContext context) => context.ds.isCupertino
      ? _buildCupertino(context)
      : _buildMaterial(context);

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
      children: <Widget>[
        for (final DSListRow row in rows)
          CupertinoListTile.notched(
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
            trailing:
                row.trailing ??
                (row.onTap == null ? null : const CupertinoListTileChevron()),
            onTap: row.onTap,
            backgroundColor: ds.colors.surfaceElevated,
          ),
      ],
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final ds = context.ds;
    return Padding(
      padding: const EdgeInsets.only(bottom: DSSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              children: <Widget>[
                for (int i = 0; i < rows.length; i++) ...<Widget>[
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

final class _MaterialRow extends StatelessWidget {
  const _MaterialRow({required this.row});
  final DSListRow row;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Color titleColor = row.isDestructive
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
      trailing: switch ((row.trailing, row.additionalInfo)) {
        (final Widget trailing?, _) => trailing,
        (null, final String info?) => _TrailingInfo(text: info),
        (null, null) when row.onTap != null => Icon(
          Icons.chevron_right,
          color: ds.colors.onSurfaceMuted,
        ),
        _ => null,
      },
    );
  }
}

final class _TrailingInfo extends StatelessWidget {
  const _TrailingInfo({required this.text});
  static const double _maxWidth = 168;
  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
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
