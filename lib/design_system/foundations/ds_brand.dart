import 'package:flutter/painting.dart';

enum DSBrand {
  aurora(Color(0xFF4C5FD5)),
  forest(Color(0xFF2E7D5B)),
  sunset(Color(0xFFD4622A)),
  graphite(Color(0xFF4A5560));

  const DSBrand(this.seed);
  final Color seed;
  static const DSBrand fallback = DSBrand.aurora;
}
