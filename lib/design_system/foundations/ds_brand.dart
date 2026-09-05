import 'package:flutter/painting.dart';

/// The seed colours the whole palette can be generated from.
///
/// Exposing the seed — rather than a frozen list of hex values — is what makes
/// the palette a *system*: change one entry here and every surface, border and
/// state colour in both design languages moves with it.
enum DSBrand {
  aurora(Color(0xFF4C5FD5)),
  forest(Color(0xFF2E7D5B)),
  sunset(Color(0xFFD4622A)),
  graphite(Color(0xFF4A5560));

  const DSBrand(this.seed);

  /// The single source colour every role is derived from.
  final Color seed;

  static const DSBrand fallback = DSBrand.aurora;
}
