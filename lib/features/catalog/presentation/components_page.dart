import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:design_system_flutter/features/catalog/presentation/component_copy.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// The second tab: the list of components, grouped by what they are for.
class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = context.ds.designLanguage;

    return DSScaffold(
      title: l10n.componentsTitle,
      body: DSPageBody(
        children: [
          DSText(
            l10n.componentsSubtitle,
            color: context.ds.colors.onSurfaceMuted,
          ),
          const DSGap.lg(),
          for (final group in ComponentGroup.values)
            DSListSection(
              header: group.title(context),
              rows: [
                for (final id in ComponentId.inGroup(group))
                  DSListRow(
                    title: id.title(context),
                    subtitle: id.description(context),
                    leading: id.icon(language),
                    // The detail page is a child route, so this pushes on top
                    // of the list and the back button appears by itself.
                    onTap: () => context.goNamed(
                      AppRoute.componentDetail.routeName,
                      pathParameters: {'componentId': id.slug},
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
