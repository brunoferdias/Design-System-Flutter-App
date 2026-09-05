import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);

  Future<void> clear();
}
