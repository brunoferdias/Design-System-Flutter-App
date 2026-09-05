enum OnboardingStep {
  welcome,
  designLanguage,
  appearance,
  language,
  tour;

  int get position => OnboardingStep.values.indexOf(this);

  bool get isFirst => this == OnboardingStep.welcome;

  bool get isLast => this == OnboardingStep.tour;

  static int get count => OnboardingStep.values.length;
}
