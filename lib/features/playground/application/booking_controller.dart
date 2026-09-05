import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where "now" comes from.
///
/// The tests replace this with a fixed date so the default departure day does
/// not change while they run.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The booking form currently on screen.
final bookingProvider = NotifierProvider<BookingController, BookingDraft>(
  BookingController.new,
);

/// Every change the playground form can make.
class BookingController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() {
    final now = ref.read(clockProvider)();
    // A trip three weeks out is a sensible default to show in the form.
    return BookingDraft(departure: now.add(const Duration(days: 21)));
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setCabin(CabinClass cabin) {
    state = state.copyWith(cabin: cabin);
  }

  /// Keeps the slider inside the allowed range, whatever it sends us.
  void setPassengers(int count) {
    final safeCount = count.clamp(
      BookingDraft.minPassengers,
      BookingDraft.maxPassengers,
    );
    state = state.copyWith(passengers: safeCount);
  }

  void setFlexibleFare({required bool enabled}) {
    state = state.copyWith(flexibleFare: enabled);
  }

  /// Turns the error messages on and reports whether the form can be sent.
  bool submit() {
    state = state.copyWith(showValidation: true);
    return state.isValid;
  }

  /// Clears the form but keeps the departure date the user was looking at.
  void reset() {
    state = BookingDraft(departure: state.departure);
  }
}
