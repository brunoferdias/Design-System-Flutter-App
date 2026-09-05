import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:flutter/painting.dart';

/// Corner radius tokens.
///
/// This is the clearest example of a token whose *value* is platform-specific
/// while its *meaning* is not. A component asks for `radii.control`; whether it
/// gets Material's generously rounded corner or Cupertino's tighter one is the
/// theme's business, not the component's.
final class DSRadii {
  const DSRadii({
    required this.compact,
    required this.control,
    required this.surface,
    required this.modal,
  });

  /// Radii tuned for Material 3, which leans into large, soft corners.
  factory DSRadii.material() => const DSRadii(
    compact: Radius.circular(8),
    control: Radius.circular(20),
    surface: Radius.circular(16),
    modal: Radius.circular(28),
  );

  /// Radii tuned for Cupertino, which is noticeably tighter.
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

  /// Chips, badges, small inline containers.
  final Radius compact;

  /// Buttons, text fields — anything the user can act on.
  final Radius control;

  /// Cards and grouped list sections.
  final Radius surface;

  /// Dialogs, sheets, anything that floats above the page.
  final Radius modal;

  /// A fully rounded corner, for pills and avatars.
  static const Radius pill = Radius.circular(999);

  BorderRadius get compactAll => BorderRadius.all(compact);

  BorderRadius get controlAll => BorderRadius.all(control);

  BorderRadius get surfaceAll => BorderRadius.all(surface);

  BorderRadius get modalAll => BorderRadius.all(modal);

  static const BorderRadius pillAll = BorderRadius.all(pill);
}
