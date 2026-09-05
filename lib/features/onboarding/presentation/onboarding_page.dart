import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/onboarding/application/onboarding_controller.dart';
import 'package:design_system_flutter/features/onboarding/domain/onboarding_step.dart';
import 'package:design_system_flutter/features/onboarding/presentation/onboarding_steps.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The introduction shown on the first launch.
///
/// All five steps live on this one page: changing the step swaps the content
/// with an animation, it does not navigate anywhere.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  /// How fast a swipe has to be before it counts as "next" or "back".
  static const double _swipeThreshold = 240;

  /// Which way the content should slide. Kept here because it is only about
  /// the animation, not about the step itself.
  bool _isMovingForward = true;

  void _goToNextStep() {
    setState(() => _isMovingForward = true);
    ref.read(onboardingStepProvider.notifier).next();
  }

  void _goToPreviousStep() {
    setState(() => _isMovingForward = false);
    ref.read(onboardingStepProvider.notifier).previous();
  }

  /// Ends the introduction, from the last step or from "Skip".
  ///
  /// Saving the flag is not enough to leave the page: the router only checks it
  /// when a navigation happens, so we navigate ourselves right after.
  void _finish() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    ref.read(onboardingStepProvider.notifier).restart();
    context.goNamed(AppRoute.foundations.routeName);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    // A negative velocity means the finger moved to the left, which in reading
    // order means "go forward".
    if (velocity < -_swipeThreshold) _goToNextStep();
    if (velocity > _swipeThreshold) _goToPreviousStep();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final step = ref.watch(onboardingStepProvider);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return DSScaffold(
      title: l10n.appTitle,
      actions: [
        DSButton(
          label: l10n.onboardingSkip,
          intent: DSButtonIntent.tertiary,
          onPressed: _finish,
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: AnimatedSwitcher(
                duration: DSMotion.normal,
                switchInCurve: DSMotion.enter,
                switchOutCurve: DSMotion.exit,
                transitionBuilder: (child, animation) {
                  // The new step slides in from the side we are heading to.
                  final offset = _isMovingForward ? 0.12 : -0.12;

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(offset, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                // The key is what tells AnimatedSwitcher that this is a new
                // step and it should animate.
                child: OnboardingStepView(key: ValueKey(step), step: step),
              ),
            ),
          ),
          Semantics(
            liveRegion: true,
            label: l10n.onboardingStepProgress(
              step.position + 1,
              OnboardingStep.count,
            ),
            child: _StepIndicator(currentStep: step),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              DSSpacing.lg,
              DSSpacing.md,
              DSSpacing.lg,
              bottomInset + DSSpacing.lg,
            ),
            child: Row(
              children: [
                // There is nothing to go back to on the first step.
                if (!step.isFirst) ...[
                  Expanded(
                    child: DSButton(
                      label: l10n.onboardingBack,
                      intent: DSButtonIntent.secondary,
                      expand: true,
                      onPressed: _goToPreviousStep,
                    ),
                  ),
                  const DSGap.md(),
                ],
                Expanded(
                  // Twice as wide as "Back", so the main action stands out.
                  flex: 2,
                  child: DSButton(
                    label: step.isLast
                        ? l10n.onboardingStart
                        : l10n.onboardingNext,
                    expand: true,
                    onPressed: step.isLast ? _finish : _goToNextStep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The row of dots at the bottom. The current step is a wider pill.
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final OnboardingStep currentStep;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final step in OnboardingStep.values)
          AnimatedContainer(
            duration: DSMotion.fast,
            curve: DSMotion.standard,
            margin: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
            width: step == currentStep ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: step == currentStep
                  ? ds.colors.brand
                  : ds.colors.onSurfaceMuted.withValues(alpha: 0.3),
              borderRadius: DSRadii.pillAll,
            ),
          ),
      ],
    );
  }
}
