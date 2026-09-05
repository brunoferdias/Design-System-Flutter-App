import 'package:shared_preferences/shared_preferences.dart';

/// A tiny wrapper around key/value storage.
///
/// The repository talks to this instead of to SharedPreferences directly, so
/// tests can hand it [InMemoryKeyValueStore] and run without a device.
abstract class KeyValueStore {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);
}

/// The real storage, backed by the device's preferences file.
class SharedPreferencesStore implements KeyValueStore {
  const SharedPreferencesStore(this._preferences);

  /// Opens the preferences file. Call this once, before `runApp`.
  static Future<SharedPreferencesStore> open() async {
    final preferences = await SharedPreferences.getInstance();
    return SharedPreferencesStore(preferences);
  }

  final SharedPreferences _preferences;

  @override
  String? readString(String key) => _preferences.getString(key);

  @override
  Future<void> writeString(String key, String value) {
    return _preferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}

/// A store that keeps everything in a map. Used by the tests.
class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, String>? seed]) : _values = {...?seed};

  final Map<String, String> _values;

  @override
  String? readString(String key) => _values[key];

  @override
  Future<void> writeString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}
