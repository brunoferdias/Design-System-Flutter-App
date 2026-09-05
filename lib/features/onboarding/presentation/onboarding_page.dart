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

final class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const double _swipeThreshold = 240;

  bool _forward = true;

  void _goTo(OnboardingStep step) {
    setState(
      () =>
          _forward = step.position >= ref.read(onboardingStepProvider).position,
    );
    ref.read(onboardingStepProvider.notifier).goTo(step);
  }

  void _advance(int delta) {
    final OnboardingStep current = ref.read(onboardingStepProvider);
    final int next = current.position + delta;
    if (next < 0 || next >= OnboardingStep.count) return;
    _goTo(OnboardingStep.values[next]);
  }

  void _finish() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    ref.read(onboardingStepProvider.notifier).restart();
    context.goNamed(AppRoute.foundations.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final OnboardingStep step = ref.watch(onboardingStepProvider);

    return DSScaffold(
      title: l10n.appTitle,
      actions: <Widget>[
        DSButton(
          label: l10n.onboardingSkip,
          intent: DSButtonIntent.tertiary,
          onPressed: _finish,
        ),
      ],
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                final double velocity = details.primaryVelocity ?? 0;
                if (velocity < -_swipeThreshold) _advance(1);
                if (velocity > _swipeThreshold) _advance(-1);
              },
              child: AnimatedSwitcher(
                duration: DSMotion.normal,
                switchInCurve: DSMotion.enter,
                switchOutCurve: DSMotion.exit,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(_forward ? 0.12 : -0.12, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                child: OnboardingStepView(
                  key: ValueKey<OnboardingStep>(step),
                  step: step,
                ),
              ),
            ),
          ),
          Semantics(
            liveRegion: true,
            label: l10n.onboardingStepProgress(
              step.position + 1,
              OnboardingStep.count,
            ),
            child: _StepIndicator(current: step),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              DSSpacing.lg,
              DSSpacing.md,
              DSSpacing.lg,
              MediaQuery.viewPaddingOf(context).bottom + DSSpacing.lg,
            ),
            child: Row(
              children: <Widget>[
                if (!step.isFirst) ...<Widget>[
                  Expanded(
                    child: DSButton(
                      label: l10n.onboardingBack,
                      intent: DSButtonIntent.secondary,
                      expand: true,
                      onPressed: () => _advance(-1),
                    ),
                  ),
                  const DSGap.md(),
                ],
                Expanded(
                  flex: 2,
                  child: DSButton(
                    label: step.isLast
                        ? l10n.onboardingStart
                        : l10n.onboardingNext,
                    expand: true,
                    onPressed: step.isLast ? _finish : () => _advance(1),
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

final class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current});

  final OnboardingStep current;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (final OnboardingStep step in OnboardingStep.values)
          AnimatedContainer(
            duration: DSMotion.fast,
            curve: DSMotion.standard,
            margin: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
            width: step == current ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: step == current
                  ? ds.colors.brand
                  : ds.colors.onSurfaceMuted.withValues(alpha: 0.3),
              borderRadius: DSRadii.pillAll,
            ),
          ),
      ],
    );
  }
}
