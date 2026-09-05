enum DesignLanguage {
  material,

  cupertino;

  bool get isMaterial => this == DesignLanguage.material;

  bool get isCupertino => this == DesignLanguage.cupertino;
}

enum DesignLanguagePreference {
  system,
  material,
  cupertino;

  DesignLanguage resolve({required bool platformIsApple}) => switch (this) {
    DesignLanguagePreference.material => DesignLanguage.material,
    DesignLanguagePreference.cupertino => DesignLanguage.cupertino,
    DesignLanguagePreference.system =>
      platformIsApple ? DesignLanguage.cupertino : DesignLanguage.material,
  };
}
