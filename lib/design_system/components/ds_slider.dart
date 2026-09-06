import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DSSlider extends StatelessWidget {
  const DSSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.semanticLabel,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    final Widget control;
    if (ds.isCupertino) {
      control = CupertinoSlider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: ds.colors.brand,
      );
    } else {
      control = Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
      );
    }

    if (semanticLabel == null) return control;
    return Semantics(label: semanticLabel, child: control);
  }
}
