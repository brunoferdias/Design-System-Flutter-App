import 'package:design_system_flutter/features/playground/domain/booking_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((Ref ref) => DateTime.now, name: 'clock');

final NotifierProvider<BookingController, BookingDraft> bookingProvider =
    NotifierProvider<BookingController, BookingDraft>(
      BookingController.new,
      name: 'booking',
    );

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

  bool submit() {
    state = state.copyWith(showValidation: true);
    return state.isValid;
  }

  void reset() => state = BookingDraft(departure: state.departure);
}
