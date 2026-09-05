import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class DSProgressIndicator extends StatelessWidget {
  const DSProgressIndicator({this.size = 24, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return SizedBox.square(
      dimension: size,
      child: ds.isCupertino
          ? CupertinoActivityIndicator(
              radius: size / 2,
              color: ds.colors.onSurfaceMuted,
            )
          : CircularProgressIndicator(strokeWidth: 2.5, color: ds.colors.brand),
    );
  }
}
