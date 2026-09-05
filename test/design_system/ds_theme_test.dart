import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:design_system_flutter/design_system/design_system.dart';

void main() {
  group('DesignLanguagePreference.resolve', () {
    test('system follows the host platform', () {
      expect(
        DesignLanguagePreference.system.resolve(platformIsApple: true),
        DesignLanguage.cupertino,
      );
      expect(
        DesignLanguagePreference.system.resolve(platformIsApple: false),
        DesignLanguage.material,
      );
    });

    test('an explicit preference ignores the host platform', () {
      expect(
        DesignLanguagePreference.material.resolve(platformIsApple: true),
        DesignLanguage.material,
      );
      expect(
        DesignLanguagePreference.cupertino.resolve(platformIsApple: false),
        DesignLanguage.cupertino,
      );
    });
  });

  group('DSThemeData', () {
    DSThemeData resolve({
      DesignLanguage language = DesignLanguage.material,
      Brightness brightness = Brightness.light,
      DSBrand brand = DSBrand.aurora,
    }) => DSThemeData.resolve(
      designLanguage: language,
      brightness: brightness,
      brand: brand,
    );

    test('geometry and type differ between the two design languages', () {
      final DSThemeData material = resolve();
      final DSThemeData cupertino = resolve(language: DesignLanguage.cupertino);

      expect(
        cupertino.radii.control.x,
        lessThan(material.radii.control.x),
        reason: 'Cupertino corners are tighter than Material 3 corners',
      );
      expect(
        cupertino.typography.body.fontSize,
        greaterThan(material.typography.body.fontSize!),
        reason: 'Cupertino body text is 17pt against Material 14pt',
      );
    });

    test('elevation casts shadows on Material but not on Cupertino', () {
      final DSThemeData material = resolve();
      final DSThemeData cupertino = resolve(language: DesignLanguage.cupertino);

      expect(
        material.elevation.shadow(
          DSElevation.level1,
          shadowColor: const Color(0xFF000000),
        ),
        isNotEmpty,
      );
      expect(
        cupertino.elevation.shadow(
          DSElevation.level1,
          shadowColor: const Color(0xFF000000),
        ),
        isEmpty,
      );
    });

    test('every brand seed produces a distinct palette', () {
      final Set<Color> brandColors = DSBrand.values
          .map((DSBrand brand) => resolve(brand: brand).colors.brand)
          .toSet();

      expect(brandColors, hasLength(DSBrand.values.length));
    });

    test('dark mode inverts the surface/content relationship', () {
      final DSThemeData light = resolve();
      final DSThemeData dark = resolve(brightness: Brightness.dark);

      expect(light.isDark, isFalse);
      expect(dark.isDark, isTrue);
      expect(
        dark.colors.surface.computeLuminance(),
        lessThan(light.colors.surface.computeLuminance()),
      );
      expect(
        dark.colors.onSurface.computeLuminance(),
        greaterThan(light.colors.onSurface.computeLuminance()),
      );
    });

    test('the colour catalogue documents every role exactly once', () {
      final Map<String, Color> catalogue = resolve().colors.catalogue;

      expect(catalogue, isNotEmpty);
      expect(catalogue.keys.toSet(), hasLength(catalogue.length));
      expect(catalogue.containsKey('brand'), isTrue);
      expect(catalogue.containsKey('danger'), isTrue);
    });

    test('equality is driven by the three inputs, not by object identity', () {
      expect(resolve(), equals(resolve()));
      expect(resolve(), isNot(equals(resolve(brand: DSBrand.forest))));
      expect(
        resolve(),
        isNot(equals(resolve(language: DesignLanguage.cupertino))),
      );
    });
  });
}
