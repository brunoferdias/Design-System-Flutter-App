import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The clock, as a dependency.
///
/// Injecting `now` instead of calling `DateTime.now()` inline is what lets the
/// booking tests assert on a formatted departure date without becoming flaky at
/// midnight.
final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((Ref ref) => DateTime.now, name: 'clock');

/// Holds the in-progress booking for the Playground screen.
final NotifierProvider<BookingController, BookingDraft> bookingProvider =
    NotifierProvider<BookingController, BookingDraft>(
      BookingController.new,
      name: 'booking',
    );

/// Edits a [BookingDraft].
///
/// Every method is a total function from one valid state to another — the
/// passenger count is clamped rather than trusted, so no caller can push the
/// screen into a state the domain considers impossible.
final class BookingController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() {
    final DateTime now = ref.read(clockProvider)();
    return BookingDraft(departure: now.add(const Duration(days: 21)));
  }

  void setName(String value) => state = state.copyWith(name: value);

  void setEmail(String value) => state = state.copyWith(email: value);

  void setCabin(CabinClass cabin) => state = state.copyWith(cabin: cabin);

  void setPassengers(int count) => state = state.copyWith(
    passengers: count.clamp(
      BookingDraft.minPassengers,
      BookingDraft.maxPassengers,
    ),
  );

  void setFlexibleFare({required bool enabled}) =>
      state = state.copyWith(flexibleFare: enabled);

  /// Reveals validation messages and reports whether the draft can be sent.
  bool submit() {
    state = state.copyWith(showValidation: true);
    return state.isValid;
  }

  /// Returns to a blank draft, keeping the same departure date.
  void reset() => state = BookingDraft(departure: state.departure);
}
