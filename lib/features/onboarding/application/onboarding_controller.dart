import 'package:design_system_flutter/features/onboarding/domain/onboarding_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which step of the introduction is on screen.
///
/// This is not saved to disk: it only lives while the introduction is open.
final onboardingStepProvider =
    NotifierProvider<OnboardingController, OnboardingStep>(
      OnboardingController.new,
    );

/// Moves between the introduction steps.
///
/// It also guards the edges, so the page never has to check whether there is a
/// next or previous step before calling.
class OnboardingController extends Notifier<OnboardingStep> {
  @override
  OnboardingStep build() => OnboardingStep.welcome;

  void next() {
    if (state.isLast) return;
    state = OnboardingStep.values[state.position + 1];
  }

  void previous() {
    if (state.isFirst) return;
    state = OnboardingStep.values[state.position - 1];
  }

  /// Back to the first step, so a replay does not start where we left off.
  void restart() {
    state = OnboardingStep.welcome;
  }
}
