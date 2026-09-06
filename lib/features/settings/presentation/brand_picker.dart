import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/widgets.dart';

class BrandPicker extends StatelessWidget {
  const BrandPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final DSBrand selected;
  final ValueChanged<DSBrand> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final brand in DSBrand.values)
          Expanded(
            child: _BrandSwatch(
              brand: brand,
              isSelected: brand == selected,
              onTap: () => onSelected(brand),
            ),
          ),
      ],
    );
  }
}

class _BrandSwatch extends StatelessWidget {
  const _BrandSwatch({
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  final DSBrand brand;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final label = _brandLabel(context, brand);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
          child: Column(
            children: [
              AnimatedContainer(
                duration: DSMotion.fast,
                curve: DSMotion.standard,
                height: 56,
                decoration: BoxDecoration(
                  color: brand.seed,
                  borderRadius: ds.radii.surfaceAll,
                  border: Border.all(
                    color: isSelected
                        ? ds.colors.onSurface
                        : ds.colors.separator,
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
              const DSGap.xs(),
              DSText(
                label,
                role: DSTextRole.caption,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _brandLabel(BuildContext context, DSBrand brand) {
  final l10n = context.l10n;

  switch (brand) {
    case DSBrand.aurora:
      return l10n.brandColorAurora;
    case DSBrand.forest:
      return l10n.brandColorForest;
    case DSBrand.sunset:
      return l10n.brandColorSunset;
    case DSBrand.graphite:
      return l10n.brandColorGraphite;
  }
}
