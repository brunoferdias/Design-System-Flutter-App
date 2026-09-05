import 'package:flutter/foundation.dart';

/// The cabin classes on offer, each with its price multiplier.
///
/// Business rules live on the domain object, not in the widget: the screen
/// renders `draft.total`, it does not know how to compute it.
enum CabinClass {
  economy(1),
  premium(1.6),
  business(2.4);

  const CabinClass(this.priceMultiplier);

  final double priceMultiplier;
}

/// A booking the user is in the middle of filling in.
///
/// Pure Dart: no Flutter, no `BuildContext`, no formatting. That is what makes
/// the pricing and validation rules testable in microseconds and reusable if
/// this ever became a package shared with a backend.
@immutable
final class BookingDraft {
  const BookingDraft({
    required this.departure,
    this.name = '',
    this.email = '',
    this.cabin = CabinClass.economy,
    this.passengers = 1,
    this.flexibleFare = false,
    this.showValidation = false,
  });

  /// The fare before multipliers, per passenger.
  static const double baseFarePerPassenger = 149.90;

  /// What the flexible-fare option adds to the whole booking.
  static const double flexibleFareSurcharge = 39;

  static const int minPassengers = 1;
  static const int maxPassengers = 6;

  final String name;
  final String email;
  final CabinClass cabin;
  final int passengers;
  final bool flexibleFare;
  final DateTime departure;

  /// Errors stay hidden until the user tries to submit — validating as they
  /// type would flag every field the instant it is focused.
  final bool showValidation;

  bool get isNameValid => name.trim().isNotEmpty;

  /// Intentionally permissive. Over-strict client-side email regexes reject
  /// valid addresses; the authoritative check belongs on the server.
  bool get isEmailValid =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());

  bool get isValid => isNameValid && isEmailValid;

  /// Total price, in the app's single currency.
  double get total =>
      baseFarePerPassenger * passengers * cabin.priceMultiplier +
      (flexibleFare ? flexibleFareSurcharge : 0);

  BookingDraft copyWith({
    String? name,
    String? email,
    CabinClass? cabin,
    int? passengers,
    bool? flexibleFare,
    DateTime? departure,
    bool? showValidation,
  }) => BookingDraft(
    name: name ?? this.name,
    email: email ?? this.email,
    cabin: cabin ?? this.cabin,
    passengers: passengers ?? this.passengers,
    flexibleFare: flexibleFare ?? this.flexibleFare,
    departure: departure ?? this.departure,
    showValidation: showValidation ?? this.showValidation,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingDraft &&
          other.name == name &&
          other.email == email &&
          other.cabin == cabin &&
          other.passengers == passengers &&
          other.flexibleFare == flexibleFare &&
          other.departure == departure &&
          other.showValidation == showValidation;

  @override
  int get hashCode => Object.hash(
    name,
    email,
    cabin,
    passengers,
    flexibleFare,
    departure,
    showValidation,
  );
}
