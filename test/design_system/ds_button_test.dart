import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  group('DSButton', () {
    testWidgets('renders a Material button under the Material language', (
      WidgetTester tester,
    ) async {
      await pumpComponent(tester, DSButton(label: 'Book', onPressed: () {}));

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(CupertinoButton), findsNothing);
      expect(find.text('Book'), findsOneWidget);
    });

    testWidgets('renders a Cupertino button under the Cupertino language', (
      WidgetTester tester,
    ) async {
      await pumpComponent(
        tester,
        DSButton(label: 'Book', onPressed: () {}),
        designLanguage: DesignLanguage.cupertino,
      );

      expect(find.byType(CupertinoButton), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.text('Book'), findsOneWidget);
    });

    testWidgets('a null callback disables the underlying platform button', (
      WidgetTester tester,
    ) async {
      await pumpComponent(
        tester,
        const DSButton(label: 'Book', onPressed: null),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );

      await pumpComponent(
        tester,
        const DSButton(label: 'Book', onPressed: null),
        designLanguage: DesignLanguage.cupertino,
      );
      expect(
        tester.widget<CupertinoButton>(find.byType(CupertinoButton)).enabled,
        isFalse,
      );
    });

    testWidgets('shows a platform-correct spinner while loading', (
      WidgetTester tester,
    ) async {
      await pumpComponent(
        tester,
        DSButton(label: 'Book', isLoading: true, onPressed: () {}),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Book'), findsNothing);

      await pumpComponent(
        tester,
        DSButton(label: 'Book', isLoading: true, onPressed: () {}),
        designLanguage: DesignLanguage.cupertino,
      );
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('a loading button ignores taps', (WidgetTester tester) async {
      int taps = 0;
      await pumpComponent(
        tester,
        DSButton(label: 'Book', isLoading: true, onPressed: () => taps++),
      );

      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      await tester.pump();

      expect(taps, 0);
    });
  });
}
