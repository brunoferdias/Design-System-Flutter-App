import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  group('DSSwitch', () {
    testWidgets('maps onto each platform widget', (WidgetTester tester) async {
      await pumpComponent(
        tester,
        DSSwitch(value: true, onChanged: (bool _) {}),
      );
      expect(find.byType(Switch), findsOneWidget);

      await pumpComponent(
        tester,
        DSSwitch(value: true, onChanged: (bool _) {}),
        designLanguage: DesignLanguage.cupertino,
      );
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });

    testWidgets('reports changes on both platforms', (
      WidgetTester tester,
    ) async {
      for (final DesignLanguage language in DesignLanguage.values) {
        bool? received;
        await pumpComponent(
          tester,
          DSSwitch(value: false, onChanged: (bool next) => received = next),
          designLanguage: language,
        );

        await tester.tap(find.byType(DSSwitch));
        await tester.pumpAndSettle();

        expect(received, isTrue, reason: 'no change reported in $language');
      }
    });
  });

  group('DSTextField', () {
    testWidgets('shows the error message in place of the helper text', (
      WidgetTester tester,
    ) async {
      for (final DesignLanguage language in DesignLanguage.values) {
        await pumpComponent(
          tester,
          const DSTextField(
            label: 'Email',
            helperText: 'We never share it',
            errorText: 'Invalid address',
          ),
          designLanguage: language,
        );

        expect(find.text('Invalid address'), findsOneWidget);
        expect(find.text('We never share it'), findsNothing);
      }
    });

    testWidgets('accepts input on both platforms', (WidgetTester tester) async {
      for (final DesignLanguage language in DesignLanguage.values) {
        String value = '';
        await pumpComponent(
          tester,
          DSTextField(label: 'Name', onChanged: (String next) => value = next),
          designLanguage: language,
        );

        await tester.enterText(find.byType(EditableText), 'Ada');
        expect(value, 'Ada', reason: 'text not reported in $language');
      }
    });
  });

  group('DSSegmentedControl', () {
    testWidgets('reports the newly selected value on both platforms', (
      WidgetTester tester,
    ) async {
      for (final DesignLanguage language in DesignLanguage.values) {
        String? selected;
        await pumpComponent(
          tester,
          DSSegmentedControl<String>(
            value: 'a',
            onChanged: (String next) => selected = next,
            segments: const <DSSegment<String>>[
              DSSegment<String>(value: 'a', label: 'Economy'),
              DSSegment<String>(value: 'b', label: 'Business'),
            ],
          ),
          designLanguage: language,
        );

        await tester.tap(find.text('Business'));
        await tester.pumpAndSettle();

        expect(selected, 'b', reason: 'no selection reported in $language');
      }
    });
  });

  group('DSAvatar', () {
    test('derives at most two initials, ignoring extra whitespace', () {
      expect(const DSAvatar(name: 'Ada Lovelace').initials, 'AL');
      expect(const DSAvatar(name: '  grace   hopper ').initials, 'GH');
      expect(const DSAvatar(name: 'Prince').initials, 'P');
      expect(const DSAvatar(name: '   ').initials, '?');
    });
  });

  group('DSFeedback.toast', () {
    testWidgets('appears in the overlay and removes itself', (
      WidgetTester tester,
    ) async {
      await pumpComponent(
        tester,
        Builder(
          builder: (BuildContext context) => DSButton(
            label: 'Show',
            onPressed: () => DSFeedback.toast(context, 'Saved'),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsNothing);
    });
  });
}
