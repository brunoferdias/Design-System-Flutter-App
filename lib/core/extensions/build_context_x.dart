import 'package:design_system_flutter/design_system/foundations/ds_breakpoints.dart';
import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  DSWindowSize get windowSize =>
      DSWindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
