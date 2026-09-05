/// The pages of the introduction, in the order they are shown.
enum OnboardingStep {
  welcome,
  designLanguage,
  appearance,
  language,
  tour;

  /// How many steps there are in total.
  static int get count => OnboardingStep.values.length;

  /// The index of this step, starting at 0.
  int get position => OnboardingStep.values.indexOf(this);

  bool get isFirst => this == OnboardingStep.welcome;

  bool get isLast => this == OnboardingStep.tour;
}
