import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_code.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_copy.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_demo.dart';
import 'package:flutter/widgets.dart';

final class ComponentDetailPage extends StatelessWidget {
  const ComponentDetailPage({required this.componentId, super.key});
  final ComponentId componentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ds = context.ds;

    return DSScaffold(
      title: componentId.title(context),
      body: DSPageBody(
        children: <Widget>[
          DSText(
            componentId.description(context),
            color: ds.colors.onSurfaceMuted,
          ),
          const DSGap.md(),
          Wrap(
            spacing: DSSpacing.sm,
            runSpacing: DSSpacing.sm,
            children: <Widget>[
              DSBadge(
                ds.select(material: 'Material 3', cupertino: 'Cupertino'),
                tone: DSBadgeTone.brand,
              ),
              DSBadge(componentId.slug),
            ],
          ),
          DSSectionHeader(title: l10n.foundationsPreviewLabel),
          DSCard(child: ComponentDemo(componentId: componentId)),
          const DSSectionHeader(title: 'Dart'),
          _CodeBlock(code: componentId.codeSample),
        ],
      ),
    );
  }
}

final class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ds.colors.surfaceSunken,
        borderRadius: ds.radii.surfaceAll,
        border: Border.all(color: ds.colors.separator),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: Text(
          code,
          style: ds.typography.caption.copyWith(
            fontFamily: 'monospace',
            fontFamilyFallback: const <String>['Menlo', 'Courier New'],
            height: 1.5,
            color: ds.colors.onSurface,
          ),
        ),
      ),
    );
  }
}
