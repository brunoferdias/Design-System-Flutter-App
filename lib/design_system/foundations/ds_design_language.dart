/// The two visual dialects the design system can speak.
///
/// Everything else in `lib/design_system` is written against this enum: tokens
/// resolve platform-specific values from it and components branch on it exactly
/// once, at the very edge of the widget tree.
enum DesignLanguage {
  /// Material 3 — Google's design language.
  material,

  /// Cupertino — Apple's Human Interface Guidelines.
  cupertino;

  bool get isMaterial => this == DesignLanguage.material;

  bool get isCupertino => this == DesignLanguage.cupertino;
}

/// What the *user* asked for, which may defer the decision to the host platform.
///
/// Kept separate from [DesignLanguage] on purpose: a resolved theme can never
/// be "automatic", so the type system prevents an unresolved value from
/// reaching a component.
enum DesignLanguagePreference {
  /// Follow the platform the app is running on.
  system,
  material,
  cupertino;

  /// Collapses the preference into a concrete [DesignLanguage].
  ///
  /// [platformIsApple] is injected rather than read from `defaultTargetPlatform`
  /// so that this function stays pure and trivially testable.
  DesignLanguage resolve({required bool platformIsApple}) => switch (this) {
    DesignLanguagePreference.material => DesignLanguage.material,
    DesignLanguagePreference.cupertino => DesignLanguage.cupertino,
    DesignLanguagePreference.system =>
      platformIsApple ? DesignLanguage.cupertino : DesignLanguage.material,
  };
}
