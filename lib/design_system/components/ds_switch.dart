import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class DSSwitch extends StatelessWidget {
  const DSSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Widget control = ds.isCupertino
        ? CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: ds.colors.brand,
          )
        : Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: ds.colors.onBrand,
            activeTrackColor: ds.colors.brand,
          );
    return semanticLabel == null
        ? control
        : Semantics(label: semanticLabel, child: control);
  }
}
