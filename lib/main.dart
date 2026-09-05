import 'package:design_system_flutter/app/app.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  // Needed because we touch the device storage before calling runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // Reading the settings here, before the first frame, means the app can open
  // straight into the right screen with the right theme -- no flash of the
  // default look while something loads.
  final store = await SharedPreferencesStore.open();
  final repository = SettingsRepositoryImpl(store);
  final settings = await repository.load();

  runApp(
    ProviderScope(
      // These two providers throw until they are given a value here.
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repository),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const AuroraApp(),
    ),
  );
}
