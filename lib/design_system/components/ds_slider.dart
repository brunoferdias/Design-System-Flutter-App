import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Continuous or stepped selection within a range.
final class DSSlider extends StatelessWidget {
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

  /// Number of discrete steps. Material draws tick marks; Cupertino, which has
  /// no notion of them, simply snaps.
  final int? divisions;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Widget control = ds.isCupertino
        ? CupertinoSlider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: ds.colors.brand,
          )
        : Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
          );
    // The underlying controls already expose the correct slider semantics and
    // value; all the design system adds is a human-readable name for it.
    return semanticLabel == null
        ? control
        : Semantics(label: semanticLabel, child: control);
  }
}
