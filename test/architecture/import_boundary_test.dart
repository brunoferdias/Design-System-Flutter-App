import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const String designSystemDir = 'lib/design_system/';
  const String generatedDir = 'lib/l10n/generated/';
  const String appRoot = 'lib/app/app.dart';

  final RegExp unrestrictedImport = RegExp(
    r"^import 'package:flutter/(material|cupertino)\.dart';",
    multiLine: true,
  );
  final RegExp scopedImport = RegExp(
    r"^import 'package:flutter/(material|cupertino)\.dart' show ",
    multiLine: true,
  );

  List<File> dartFilesUnder(String path) => Directory(path)
      .listSync(recursive: true)
      .whereType<File>()
      .where((File file) => file.path.endsWith('.dart'))
      .toList();

  test('only the design system and the app root may import the frameworks', () {
    final List<String> offenders = <String>[];

    for (final File file in dartFilesUnder('lib')) {
      final String path = file.path;
      if (path.startsWith(designSystemDir) ||
          path.startsWith(generatedDir) ||
          path == appRoot) {
        continue;
      }
      if (unrestrictedImport.hasMatch(file.readAsStringSync())) {
        offenders.add(path);
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These files import material.dart or cupertino.dart directly. '
          'Feature code must go through package:design_system_flutter/'
          'design_system/design_system.dart, and may only import the icon '
          'sets with a "show" clause.',
    );
  });

  test('feature imports of the frameworks are limited to icon sets', () {
    for (final File file in dartFilesUnder('lib/features')) {
      final String source = file.readAsStringSync();
      for (final RegExpMatch match in scopedImport.allMatches(source)) {
        final String line = source
            .substring(match.start, source.indexOf(';', match.start))
            .trim();
        expect(
          line.endsWith('show Icons') || line.endsWith('show CupertinoIcons'),
          isTrue,
          reason: '${file.path} imports more than an icon set: $line',
        );
      }
    }
  });

  test('the design system exports every component it defines', () {
    final String barrel = File(
      'lib/design_system/design_system.dart',
    ).readAsStringSync();

    for (final File file in dartFilesUnder('lib/design_system/components')) {
      final String name = file.uri.pathSegments.last;
      expect(
        barrel.contains(name),
        isTrue,
        reason: '$name is not exported from design_system.dart',
      );
    }
  });
}
