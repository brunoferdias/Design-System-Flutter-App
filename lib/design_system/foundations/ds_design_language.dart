/// Which native look the app is currently rendering with.
enum DesignLanguage {
  material,
  cupertino;

  bool get isCupertino => this == DesignLanguage.cupertino;
}

/// What the user chose in Settings. `system` follows the platform.
enum DesignLanguagePreference {
  system,
  material,
  cupertino;

  /// Turns the preference into the language the app should actually render.
  DesignLanguage resolve({required bool platformIsApple}) {
    switch (this) {
      case DesignLanguagePreference.material:
        return DesignLanguage.material;
      case DesignLanguagePreference.cupertino:
        return DesignLanguage.cupertino;
      case DesignLanguagePreference.system:
        return platformIsApple
            ? DesignLanguage.cupertino
            : DesignLanguage.material;
    }
  }
}
