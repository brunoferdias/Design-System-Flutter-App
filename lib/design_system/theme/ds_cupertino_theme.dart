import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';

class DSCupertinoTheme {
  static CupertinoThemeData from(DSThemeData ds) {
    return CupertinoThemeData(
      brightness: ds.brightness,
      primaryColor: ds.colors.brand,
      primaryContrastingColor: ds.colors.onBrand,
      scaffoldBackgroundColor: ds.colors.surface,
      barBackgroundColor: ds.colors.surfaceElevated,
      applyThemeToAll: true,
      textTheme: CupertinoTextThemeData(
        primaryColor: ds.colors.brand,
        textStyle: ds.typography.body,
        actionTextStyle: ds.typography.body.copyWith(color: ds.colors.brand),
        tabLabelTextStyle: ds.typography.caption,
        navTitleTextStyle: ds.typography.subtitle,
        navLargeTitleTextStyle: ds.typography.display,
        navActionTextStyle: ds.typography.body.copyWith(color: ds.colors.brand),
        pickerTextStyle: ds.typography.body,
        dateTimePickerTextStyle: ds.typography.body,
      ),
    );
  }
}
