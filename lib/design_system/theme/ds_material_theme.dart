import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Translates our tokens into the theme `MaterialApp` expects, so plain
/// Material widgets look like the rest of the app.
class DSMaterialTheme {
  static ThemeData from(DSThemeData ds) {
    final scheme = ds.colors.materialScheme;
    final radii = ds.radii;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ds.colors.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      textTheme: _textTheme(ds),
      appBarTheme: AppBarTheme(
        backgroundColor: ds.colors.surface,
        foregroundColor: ds.colors.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 3,
        centerTitle: false,
        titleTextStyle: ds.typography.title,
      ),
      cardTheme: CardThemeData(
        color: ds.colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radii.surfaceAll,
          side: BorderSide(color: ds.colors.separator),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: ds.colors.separator,
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(style: _buttonStyle(ds)),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(ds).copyWith(
          side: WidgetStatePropertyAll(BorderSide(color: ds.colors.border)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: _buttonStyle(ds)),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: ds.colors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DSSpacing.lg,
          vertical: DSSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: radii.controlAll,
          borderSide: BorderSide(color: ds.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radii.controlAll,
          borderSide: BorderSide(color: ds.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radii.controlAll,
          borderSide: BorderSide(color: ds.colors.brand, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radii.controlAll,
          borderSide: BorderSide(color: ds.colors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radii.controlAll,
          borderSide: BorderSide(color: ds.colors.danger, width: 2),
        ),
        labelStyle: ds.typography.body.copyWith(
          color: ds.colors.onSurfaceMuted,
        ),
        helperStyle: ds.typography.caption.copyWith(
          color: ds.colors.onSurfaceMuted,
        ),
        errorStyle: ds.typography.caption.copyWith(color: ds.colors.danger),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ds.colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radii.modalAll),
        titleTextStyle: ds.typography.title,
        contentTextStyle: ds.typography.body,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ds.colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: radii.modal),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ds.colors.surfaceElevated,
        indicatorColor: ds.colors.brandSubtle,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(ds.typography.label),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: ds.colors.surfaceElevated,
        indicatorColor: ds.colors.brandSubtle,
        selectedLabelTextStyle: ds.typography.label.copyWith(
          color: ds.colors.onSurface,
        ),
        unselectedLabelTextStyle: ds.typography.label.copyWith(
          color: ds.colors.onSurfaceMuted,
        ),
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: ds.typography.subtitle,
        subtitleTextStyle: ds.typography.caption.copyWith(
          color: ds.colors.onSurfaceMuted,
        ),
        iconColor: ds.colors.onSurfaceMuted,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: ds.colors.brand,
        inactiveTrackColor: ds.colors.surfaceSunken,
        thumbColor: ds.colors.brand,
      ),
      // Android slides pages forwards; Apple platforms keep the iOS swipe.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// One shared shape and size for every Material button.
  static ButtonStyle _buttonStyle(DSThemeData ds) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        ds.typography.label.copyWith(fontSize: 14),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: DSSpacing.xl, vertical: DSSpacing.md),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: ds.radii.controlAll),
      ),
    );
  }

  /// Maps our eight roles onto the fifteen slots Material expects.
  static TextTheme _textTheme(DSThemeData ds) {
    final type = ds.typography;

    return TextTheme(
      displayLarge: type.display,
      displayMedium: type.display,
      displaySmall: type.display,
      headlineLarge: type.headline,
      headlineMedium: type.headline,
      headlineSmall: type.headline,
      titleLarge: type.title,
      titleMedium: type.subtitle,
      titleSmall: type.subtitle,
      bodyLarge: type.body,
      bodyMedium: type.body,
      bodySmall: type.caption,
      labelLarge: type.label,
      labelMedium: type.label,
      labelSmall: type.caption,
    );
  }
}
