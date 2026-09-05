import 'package:flutter/animation.dart';

/// Motion tokens: how long things take and how they ease.
///
/// Sharing these across both design languages is deliberate — motion is the one
/// foundation where a single, calm system reads better than two competing ones.
abstract final class DSMotion {
  /// 90ms — state changes the user should barely notice (hover, ripple fade).
  static const Duration instant = Duration(milliseconds: 90);

  /// 160ms — the default for colour and opacity transitions.
  static const Duration fast = Duration(milliseconds: 160);

  /// 240ms — layout changes inside a screen.
  static const Duration normal = Duration(milliseconds: 240);

  /// 400ms — entrances of large surfaces (sheets, dialogs).
  static const Duration slow = Duration(milliseconds: 400);

  /// Standard easing for anything entering the screen.
  static const Curve enter = Curves.easeOutCubic;

  /// Standard easing for anything leaving the screen.
  static const Curve exit = Curves.easeInCubic;

  /// Symmetric easing for on-screen transformations.
  static const Curve standard = Curves.easeInOutCubic;

  /// Playful overshoot, reserved for confirmation moments.
  static const Curve emphasized = Curves.easeOutBack;
}
