import 'package:design_system_flutter/app/app.dart';
import 'package:design_system_flutter/bootstrap.dart';

/// The entry point stays deliberately empty.
///
/// All wiring lives in [bootstrap], which the integration tests and any future
/// flavour entry point (`main_dev.dart`, `main_staging.dart`) reuse verbatim.
Future<void> main() => bootstrap(builder: AuroraApp.new);
