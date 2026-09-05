import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/widgets.dart';

/// A round badge with someone's initials.
class DSAvatar extends StatelessWidget {
  const DSAvatar({required this.name, this.size = 40, super.key});

  final String name;
  final double size;

  /// "Ada Lovelace" becomes "AL", "Prince" becomes "P", an empty name "?".
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();

    final first = parts.first.characters.first;
    final last = parts.last.characters.first;
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ds.colors.brandSubtle,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: ds.typography.subtitle.copyWith(
          color: ds.colors.onBrandSubtle,
          fontSize: size * 0.36,
          height: 1,
        ),
      ),
    );
  }
}
