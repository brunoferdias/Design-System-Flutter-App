import 'package:design_system_flutter/design_system/foundations/ds_breakpoints.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Ergonomic accessors used across the feature layer.
///
/// Small on purpose: every entry here has to earn its place by removing a line
/// of ceremony that would otherwise be repeated in dozens of `build` methods.
extension BuildContextX on BuildContext {
  /// The generated translations for the active locale.
  ///
  /// `context.l10n.settingsTitle` instead of
  /// `AppLocalizations.of(context).settingsTitle`.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The Material 3 window size class for the current layout.
  ///
  /// Reads via `MediaQuery.sizeOf`, so a widget that uses it rebuilds on resize
  /// but not on, say, a keyboard insets change.
  DSWindowSize get windowSize =>
      DSWindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
