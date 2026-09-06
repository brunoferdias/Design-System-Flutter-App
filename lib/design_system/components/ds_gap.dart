import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:flutter/widgets.dart';

class DSGap extends StatelessWidget {
  const DSGap(this.size, {super.key});

  const DSGap.xs({super.key}) : size = DSSpacing.xs;
  const DSGap.sm({super.key}) : size = DSSpacing.sm;
  const DSGap.md({super.key}) : size = DSSpacing.md;
  const DSGap.lg({super.key}) : size = DSSpacing.lg;
  const DSGap.xl({super.key}) : size = DSSpacing.xl;
  const DSGap.xxl({super.key}) : size = DSSpacing.xxl;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}
