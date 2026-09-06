import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final bookingProvider = NotifierProvider<BookingController, BookingDraft>(
  BookingController.new,
);

class BookingController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() {
    final now = ref.read(clockProvider)();
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

  bool submit() {
    state = state.copyWith(showValidation: true);
    return state.isValid;
  }

  void reset() {
    state = BookingDraft(departure: state.departure);
  }
}
