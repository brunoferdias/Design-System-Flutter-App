import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DSSegment<T> {
  const DSSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

class DSSegmentedControl<T extends Object> extends StatelessWidget {
  const DSSegmentedControl({
    required this.segments,
    required this.value,
    required this.onChanged,
    super.key,
  }) : assert(
         segments.length > 1,
         'A segmented control needs at least two options',
       );

  final List<DSSegment<T>> segments;

  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    if (ds.isCupertino) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<T>(
          groupValue: value,
          backgroundColor: ds.colors.surfaceSunken,
          thumbColor: ds.colors.surfaceElevated,
          padding: const EdgeInsets.all(DSSpacing.xxs),
          onValueChanged: (next) {
            if (next != null) onChanged(next);
          },
          children: {
            for (final segment in segments)
              segment.value: Padding(
                padding: const EdgeInsets.symmetric(vertical: DSSpacing.sm),
                child: Text(
                  segment.label,
                  style: ds.typography.label.copyWith(
                    color: ds.colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          },
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<T>(
        segments: [
          for (final segment in segments)
            ButtonSegment<T>(
              value: segment.value,
              label: Text(segment.label),
              icon: segment.icon == null ? null : Icon(segment.icon),
            ),
        ],
        selected: {value},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onChanged(selection.first),
        style: SegmentedButton.styleFrom(
          textStyle: ds.typography.label,
          selectedBackgroundColor: ds.colors.brandSubtle,
          selectedForegroundColor: ds.colors.onBrandSubtle,
          side: BorderSide(color: ds.colors.border),
        ),
      ),
    );
  }
}
