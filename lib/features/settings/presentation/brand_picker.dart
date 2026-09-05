import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

final class BrandPicker extends StatelessWidget {
  const BrandPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });
  final DSBrand selected;
  final ValueChanged<DSBrand> onSelected;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return Row(
      children: <Widget>[
        for (final DSBrand brand in DSBrand.values)
          Expanded(
            child: Semantics(
              button: true,
              selected: brand == selected,
              label: _label(context, brand),
              child: GestureDetector(
                onTap: () => onSelected(brand),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
                  child: Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: DSMotion.fast,
                        curve: DSMotion.standard,
                        height: 56,
                        decoration: BoxDecoration(
                          color: brand.seed,
                          borderRadius: ds.radii.surfaceAll,
                          border: Border.all(
                            color: brand == selected
                                ? ds.colors.onSurface
                                : ds.colors.separator,
                            width: brand == selected ? 3 : 1,
                          ),
                        ),
                      ),
                      const DSGap.xs(),
                      DSText(
                        _label(context, brand),
                        role: DSTextRole.caption,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static String _label(BuildContext context, DSBrand brand) {
    final l10n = context.l10n;
    return switch (brand) {
      DSBrand.aurora => l10n.brandColorAurora,
      DSBrand.forest => l10n.brandColorForest,
      DSBrand.sunset => l10n.brandColorSunset,
      DSBrand.graphite => l10n.brandColorGraphite,
    };
  }
}
