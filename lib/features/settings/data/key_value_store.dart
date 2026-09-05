import 'package:shared_preferences/shared_preferences.dart';

/// The narrowest possible view of persistent storage.
///
/// Introducing this seam — rather than letting the repository talk to
/// `SharedPreferences` directly — is what makes the repository testable without
/// a platform channel, and what would let the same repository run on a web
/// backend tomorrow.
abstract interface class KeyValueStore {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);
}

/// The production implementation, backed by `shared_preferences`.
final class SharedPreferencesStore implements KeyValueStore {
  const SharedPreferencesStore(this._preferences);

  /// Opens the platform store. Called once, during bootstrap.
  static Future<SharedPreferencesStore> open() async =>
      SharedPreferencesStore(await SharedPreferences.getInstance());

  final SharedPreferences _preferences;

  @override
  String? readString(String key) => _preferences.getString(key);

  @override
  Future<void> writeString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}

/// An in-memory store used by tests and by the widget previews.
final class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, String>? seed])
    : _values = <String, String>{...?seed};

  final Map<String, String> _values;

  @override
  String? readString(String key) => _values[key];

  @override
  Future<void> writeString(String key, String value) async =>
      _values[key] = value;

  @override
  Future<void> remove(String key) async => _values.remove(key);
}
