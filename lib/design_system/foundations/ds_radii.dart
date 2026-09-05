import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/painting.dart';

final class DSRadii {
  const DSRadii({
    required this.compact,
    required this.control,
    required this.surface,
    required this.modal,
  });

  factory DSRadii.material() => const DSRadii(
    compact: Radius.circular(8),
    control: Radius.circular(20),
    surface: Radius.circular(16),
    modal: Radius.circular(28),
  );

  factory DSRadii.cupertino() => const DSRadii(
    compact: Radius.circular(6),
    control: Radius.circular(10),
    surface: Radius.circular(12),
    modal: Radius.circular(14),
  );

  factory DSRadii.of(DesignLanguage language) => switch (language) {
    DesignLanguage.material => DSRadii.material(),
    DesignLanguage.cupertino => DSRadii.cupertino(),
  };

  final Radius compact;
  final Radius control;
  final Radius surface;
  final Radius modal;
  static const Radius pill = Radius.circular(999);

  BorderRadius get compactAll => BorderRadius.all(compact);

  BorderRadius get controlAll => BorderRadius.all(control);

  BorderRadius get surfaceAll => BorderRadius.all(surface);

  BorderRadius get modalAll => BorderRadius.all(modal);

  static const BorderRadius pillAll = BorderRadius.all(pill);
}
