import 'package:shared_preferences/shared_preferences.dart';

abstract class KeyValueStore {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);
}

class SharedPreferencesStore implements KeyValueStore {
  const SharedPreferencesStore(this._preferences);

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
