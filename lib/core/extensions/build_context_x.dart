import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
