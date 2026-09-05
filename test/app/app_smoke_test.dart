import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/settings/application/settings_providers.dart';
import 'package:design_system_flutter/features/settings/domain/app_settings.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('boots into the Foundations tab under Material', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CupertinoApp), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Foundations'), findsWidgets);
  });

  testWidgets('boots into Cupertino when the host platform is Apple', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, platformIsApple: true);

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.byType(CupertinoTabBar), findsOneWidget);
  });

  testWidgets('navigates between the four tabs', (WidgetTester tester) async {
    await pumpApp(tester);

    for (final String label in <String>[
      'Components',
      'Playground',
      'Settings',
    ]) {
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
      expect(find.text(label), findsWidgets, reason: 'could not reach $label');
    }
  });

  testWidgets('opens a component detail page from the gallery', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Components').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Button').first);
    await tester.pumpAndSettle();

    // The detail page shows the slug badge and the Dart sample.
    expect(find.text('button'), findsOneWidget);
    expect(find.text('Dart'), findsOneWidget);
  });

  testWidgets('switching the design language re-skins the whole app', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);

    expect(find.byType(MaterialApp), findsOneWidget);

    container
        .read(settingsProvider.notifier)
        .setDesignLanguage(DesignLanguagePreference.cupertino);
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.byType(CupertinoTabBar), findsOneWidget);
  });

  testWidgets('switching the language translates the navigation bar', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);
    expect(find.text('Settings'), findsWidgets);

    container.read(settingsProvider.notifier).setLanguage(AppLanguage.german);
    await tester.pumpAndSettle();

    expect(find.text('Einstellungen'), findsWidgets);
    expect(find.text('Grundlagen'), findsWidgets);
  });

  testWidgets('a wide window swaps the tab bar for a navigation rail', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester, surfaceSize: const Size(1280, 900));

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Aurora DS'), findsWidgets);
  });

  testWidgets('the booking form validates before confirming', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Playground').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();

    expect(find.text('Please tell us who is travelling'), findsOneWidget);
    expect(find.text('Enter a valid email address'), findsOneWidget);
  });
}
