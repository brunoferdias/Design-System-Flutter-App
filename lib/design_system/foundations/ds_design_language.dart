enum DesignLanguage {
  material,
  cupertino;

  bool get isCupertino => this == DesignLanguage.cupertino;
}

enum DesignLanguagePreference {
  system,
  material,
  cupertino;

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
