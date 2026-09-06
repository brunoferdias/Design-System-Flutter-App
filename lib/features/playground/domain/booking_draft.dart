enum CabinClass {
  economy(1),
  premium(1.6),
  business(2.4);

  const CabinClass(this.priceMultiplier);

  final double priceMultiplier;
}

class BookingDraft {
  const BookingDraft({
    required this.departure,
    this.name = '',
    this.email = '',
    this.cabin = CabinClass.economy,
    this.passengers = 1,
    this.flexibleFare = false,
    this.showValidation = false,
  });

  static const double baseFarePerPassenger = 149.90;
  static const double flexibleFareSurcharge = 39;
  static const int minPassengers = 1;
  static const int maxPassengers = 6;

  final String name;
  final String email;
  final CabinClass cabin;
  final int passengers;
  final bool flexibleFare;
  final DateTime departure;

  final bool showValidation;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isEmailValid {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }

  bool get isValid => isNameValid && isEmailValid;

  double get total {
    final fare = baseFarePerPassenger * passengers * cabin.priceMultiplier;
    if (!flexibleFare) return fare;
    return fare + flexibleFareSurcharge;
  }

  BookingDraft copyWith({
    String? name,
    String? email,
    CabinClass? cabin,
    int? passengers,
    bool? flexibleFare,
    DateTime? departure,
    bool? showValidation,
  }) {
    return BookingDraft(
      name: name ?? this.name,
      email: email ?? this.email,
      cabin: cabin ?? this.cabin,
      passengers: passengers ?? this.passengers,
      flexibleFare: flexibleFare ?? this.flexibleFare,
      departure: departure ?? this.departure,
      showValidation: showValidation ?? this.showValidation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingDraft &&
        other.name == name &&
        other.email == email &&
        other.cabin == cabin &&
        other.passengers == passengers &&
        other.flexibleFare == flexibleFare &&
        other.departure == departure &&
        other.showValidation == showValidation;
  }

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
