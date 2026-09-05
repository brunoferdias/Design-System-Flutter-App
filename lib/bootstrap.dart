import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:design_system_flutter/features/settings/domain/settings_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composition root.
///
/// Everything the app needs from the outside world is created here and injected
/// downwards, so no widget ever constructs its own dependency. That is what
/// makes the entire tree mountable in a test with two `overrides`.
///
/// Settings are read *before* the first frame on purpose: a design-system app
/// that flashes the wrong theme for 200ms undermines its own point.
Future<void> bootstrap({required Widget Function() builder}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // A real app would forward this to Crashlytics/Sentry here.
    debugPrint('Uncaught framework error: ${details.exceptionAsString()}');
  };

  final KeyValueStore store = await SharedPreferencesStore.open();
  final SettingsRepository repository = SettingsRepositoryImpl(store);
  final AppSettings settings = await repository.load();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repository),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: builder(),
    ),
  );
}
