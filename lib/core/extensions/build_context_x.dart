import 'package:design_system_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Shortcut so pages can write `context.l10n.appTitle` instead of
/// `AppLocalizations.of(context).appTitle`.
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
