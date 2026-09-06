import 'package:design_system_flutter/app/app.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/data/key_value_store.dart';
import 'package:design_system_flutter/features/settings/data/settings_repository_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await SharedPreferencesStore.open();
  final repository = SettingsRepositoryImpl(store);
  final settings = await repository.load();

  runApp(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repository),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const AuroraApp(),
    ),
  );
}
