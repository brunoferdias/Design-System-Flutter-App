import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/features/playground/application/booking_controller.dart';
import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';

void main() {
  final DateTime fixedNow = DateTime.utc(2026, 3, 1);

  BookingDraft draft({
    String name = 'Ada Lovelace',
    String email = 'ada@example.com',
    CabinClass cabin = CabinClass.economy,
    int passengers = 1,
    bool flexibleFare = false,
  }) => BookingDraft(
    departure: fixedNow,
    name: name,
    email: email,
    cabin: cabin,
    passengers: passengers,
    flexibleFare: flexibleFare,
  );

  group('validation', () {
    test('a blank or whitespace-only name is rejected', () {
      expect(draft(name: '').isNameValid, isFalse);
      expect(draft(name: '   ').isNameValid, isFalse);
      expect(draft(name: 'Ada').isNameValid, isTrue);
    });

    test('the email rule accepts ordinary addresses and rejects nonsense', () {
      expect(draft(email: 'ada@example.com').isEmailValid, isTrue);
      expect(draft(email: 'ada+news@sub.example.co.uk').isEmailValid, isTrue);
      expect(draft(email: 'ada@example').isEmailValid, isFalse);
      expect(draft(email: 'ada.example.com').isEmailValid, isFalse);
      expect(draft(email: '').isEmailValid, isFalse);
    });
  });

  group('pricing', () {
    test('scales with the passenger count', () {
      expect(draft().total, closeTo(BookingDraft.baseFarePerPassenger, 0.001));
      expect(
        draft(passengers: 3).total,
        closeTo(BookingDraft.baseFarePerPassenger * 3, 0.001),
      );
    });

    test('applies the cabin multiplier', () {
      expect(
        draft(cabin: CabinClass.business).total,
        closeTo(
          BookingDraft.baseFarePerPassenger * CabinClass.business.priceMultiplier,
          0.001,
        ),
      );
    });

    test('adds the flexible-fare surcharge once per booking, not per seat', () {
      final double withoutSurcharge = draft(passengers: 4).total;
      final double withSurcharge = draft(
        passengers: 4,
        flexibleFare: true,
      ).total;

      expect(
        withSurcharge - withoutSurcharge,
        closeTo(BookingDraft.flexibleFareSurcharge, 0.001),
      );
    });
  });

  group('BookingController', () {
    ProviderContainer makeContainer() {
      final ProviderContainer container = ProviderContainer(
        overrides: [clockProvider.overrideWithValue(() => fixedNow)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('departs three weeks after the injected clock', () {
      final ProviderContainer container = makeContainer();

      expect(
        container.read(bookingProvider).departure,
        fixedNow.add(const Duration(days: 21)),
      );
    });

    test('clamps the passenger count to the allowed range', () {
      final ProviderContainer container = makeContainer();
      final BookingController controller = container.read(
        bookingProvider.notifier,
      );

      controller.setPassengers(99);
      expect(container.read(bookingProvider).passengers, BookingDraft.maxPassengers);

      controller.setPassengers(-4);
      expect(container.read(bookingProvider).passengers, BookingDraft.minPassengers);
    });

    test('submit reveals validation and reports whether the draft is valid', () {
      final ProviderContainer container = makeContainer();
      final BookingController controller = container.read(
        bookingProvider.notifier,
      );

      expect(container.read(bookingProvider).showValidation, isFalse);
      expect(controller.submit(), isFalse);
      expect(container.read(bookingProvider).showValidation, isTrue);

      controller
        ..setName('Ada Lovelace')
        ..setEmail('ada@example.com');

      expect(controller.submit(), isTrue);
    });

    test('reset clears the form but keeps the departure date', () {
      final ProviderContainer container = makeContainer();
      final BookingController controller = container.read(
        bookingProvider.notifier,
      );
      final DateTime departure = container.read(bookingProvider).departure;

      controller
        ..setName('Ada')
        ..setFlexibleFare(enabled: true)
        ..reset();

      final BookingDraft after = container.read(bookingProvider);
      expect(after.name, isEmpty);
      expect(after.flexibleFare, isFalse);
      expect(after.departure, departure);
    });
  });
}
