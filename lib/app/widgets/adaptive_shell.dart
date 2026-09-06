import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DSNavigationScaffold(
      currentIndex: navigationShell.currentIndex,
      railHeader: l10n.appTitle,
      onDestinationSelected: (index) {
        final isCurrentTab = index == navigationShell.currentIndex;
        navigationShell.goBranch(index, initialLocation: isCurrentTab);
      },
      destinations: [
        DSNavigationDestination(
          label: l10n.navFoundations,
          materialIcon: Icons.palette_outlined,
          cupertinoIcon: CupertinoIcons.paintbrush,
        ),
        DSNavigationDestination(
          label: l10n.navComponents,
          materialIcon: Icons.widgets_outlined,
          cupertinoIcon: CupertinoIcons.square_stack_3d_up,
        ),
        DSNavigationDestination(
          label: l10n.navPlayground,
          materialIcon: Icons.science_outlined,
          cupertinoIcon: CupertinoIcons.wand_stars,
        ),
        DSNavigationDestination(
          label: l10n.navSettings,
          materialIcon: Icons.settings_outlined,
          cupertinoIcon: CupertinoIcons.settings,
        ),
      ],
      child: navigationShell,
    );
  }
}
