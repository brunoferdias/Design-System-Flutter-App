import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DSSwitch extends StatelessWidget {
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

    final Widget control;
    if (ds.isCupertino) {
      control = CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: ds.colors.brand,
      );
    } else {
      control = Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: ds.colors.onBrand,
        activeTrackColor: ds.colors.brand,
      );
    }

    if (semanticLabel == null) return control;
    return Semantics(label: semanticLabel, child: control);
  }
}
