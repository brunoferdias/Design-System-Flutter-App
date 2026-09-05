import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:design_system_flutter/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(initializeDateFormatting);

  Future<AppLocalizations> load(String code) =>
      AppLocalizations.delegate.load(Locale(code));

  test('the app ships exactly the three advertised locales', () {
    expect(
      AppLocalizations.supportedLocales.map((Locale l) => l.languageCode),
      containsAll(<String>['en', 'pt', 'de']),
    );
    expect(AppLocalizations.supportedLocales, hasLength(3));
  });

  test('every locale is fully translated, with no English left behind', () async {
    final AppLocalizations en = await load('en');
    final AppLocalizations pt = await load('pt');
    final AppLocalizations de = await load('de');

    // A representative sample across every screen. If a key were missing from
    // an ARB file, `flutter gen-l10n` would have failed the build first; this
    // guards against the subtler bug of a key copied over untranslated.
    expect(pt.settingsTitle, isNot(en.settingsTitle));
    expect(de.settingsTitle, isNot(en.settingsTitle));
    expect(pt.navComponents, isNot(en.navComponents));
    expect(de.foundationsTitle, isNot(en.foundationsTitle));
    expect(pt.bookingSubmit, isNot(en.bookingSubmit));

    // Proper nouns are deliberately identical in all three.
    expect(pt.appTitle, en.appTitle);
    expect(de.designLanguageMaterial, en.designLanguageMaterial);
  });

  group('plurals', () {
    test('English selects the right form', () async {
      final AppLocalizations en = await load('en');
      expect(en.bookingPassengerCount(1), '1 passenger');
      expect(en.bookingPassengerCount(4), '4 passengers');
    });

    test('Portuguese and German select the right form', () async {
      final AppLocalizations pt = await load('pt');
      expect(pt.bookingPassengerCount(1), '1 passageiro');
      expect(pt.bookingPassengerCount(4), '4 passageiros');

      final AppLocalizations de = await load('de');
      expect(de.bookingPassengerCount(1), '1 reisende Person');
      expect(de.bookingPassengerCount(4), '4 reisende Personen');
    });
  });

  group('locale-aware formatting', () {
    final DateTime departure = DateTime.utc(2026, 3, 22);

    test('dates follow each locale conventions', () async {
      final String en = (await load('en')).bookingDepartureValue(departure);
      final String pt = (await load('pt')).bookingDepartureValue(departure);
      final String de = (await load('de')).bookingDepartureValue(departure);

      expect(en, contains('March'));
      expect(pt, contains('março'));
      expect(de, contains('März'));
      expect(<String>{en, pt, de}, hasLength(3));
    });

    test('currency follows each locale conventions', () async {
      final String en = (await load('en')).bookingTotalValue(1234.5);
      final String de = (await load('de')).bookingTotalValue(1234.5);

      // English groups with commas, German with dots and a decimal comma.
      expect(en, contains('1,234.50'));
      expect(de, contains('1.234,50'));
    });
  });
}
