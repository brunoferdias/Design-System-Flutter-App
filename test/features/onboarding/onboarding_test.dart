import 'package:design_system_flutter/features/onboarding/domain/onboarding_step.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('a first launch opens the introduction', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, settings: AppSettings.defaults);

    expect(find.text('Welcome to Aurora DS'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('a returning user goes straight to the app', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Welcome to Aurora DS'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('skipping records completion and opens Foundations', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pumpApp(
      tester,
      settings: AppSettings.defaults,
    );

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(container.read(settingsProvider).hasCompletedOnboarding, isTrue);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Foundations'), findsWidgets);
  });

  testWidgets('every step can be reached and the last one finishes', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pumpApp(
      tester,
      settings: AppSettings.defaults,
    );

    for (int i = 0; i < OnboardingStep.count - 1; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Where to go next'), findsOneWidget);

    await tester.tap(find.text('Start exploring'));
    await tester.pumpAndSettle();

    expect(container.read(settingsProvider).hasCompletedOnboarding, isTrue);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('the design language step re-skins the app while it is open', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, settings: AppSettings.defaults);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.tap(find.text('Cupertino'));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.text('Choose a design language'), findsOneWidget);
  });

  testWidgets('the language step translates the introduction itself', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, settings: AppSettings.defaults);

    for (int i = 0; i < 3; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Speak your language'), findsOneWidget);

    await tester.tap(find.text('Português'));
    await tester.pumpAndSettle();

    expect(find.text('Fale o seu idioma'), findsOneWidget);
    expect(find.text('Avançar'), findsOneWidget);
  });

  testWidgets('settings can replay the introduction', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pumpApp(
      tester,
      surfaceSize: const Size(420, 1600),
    );

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Replay the introduction'));
    await tester.pumpAndSettle();

    expect(container.read(settingsProvider).hasCompletedOnboarding, isFalse);
    expect(find.text('Welcome to Aurora DS'), findsOneWidget);
  });
}
