enum OnboardingStep {
  welcome,
  designLanguage,
  appearance,
  language,
  tour;

  static int get count => OnboardingStep.values.length;

  int get position => OnboardingStep.values.indexOf(this);

  bool get isFirst => this == OnboardingStep.welcome;

  bool get isLast => this == OnboardingStep.tour;
}
