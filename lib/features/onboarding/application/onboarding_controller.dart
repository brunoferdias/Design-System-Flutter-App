import 'package:design_system_flutter/features/onboarding/domain/onboarding_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NotifierProvider<OnboardingController, OnboardingStep>
onboardingStepProvider = NotifierProvider<OnboardingController, OnboardingStep>(
  OnboardingController.new,
  name: 'onboardingStep',
);

final class OnboardingController extends Notifier<OnboardingStep> {
  @override
  OnboardingStep build() => OnboardingStep.welcome;

  void goTo(OnboardingStep step) => state = step;

  void next() {
    if (state.isLast) return;
    state = OnboardingStep.values[state.position + 1];
  }

  void previous() {
    if (state.isFirst) return;
    state = OnboardingStep.values[state.position - 1];
  }

  void restart() => state = OnboardingStep.welcome;
}
