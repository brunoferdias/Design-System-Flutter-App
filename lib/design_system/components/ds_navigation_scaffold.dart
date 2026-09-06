import 'package:design_system_flutter/design_system/components/ds_gap.dart';
import 'package:design_system_flutter/design_system/components/ds_text.dart';
import 'package:design_system_flutter/design_system/foundations/ds_breakpoints.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/design_system/foundations/ds_motion.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DSNavigationDestination {
  const DSNavigationDestination({
    required this.label,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  final String label;
  final IconData materialIcon;
  final IconData cupertinoIcon;

  IconData icon(DesignLanguage language) {
    return language.isCupertino ? cupertinoIcon : materialIcon;
  }
}

class DSNavigationScaffold extends StatelessWidget {
  const DSNavigationScaffold({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.railHeader,
    required this.child,
    super.key,
  }) : assert(
         destinations.length > 1,
         'Navigation needs at least two destinations',
       );

  final List<DSNavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  final String railHeader;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final window = DSWindowSize.fromWidth(MediaQuery.sizeOf(context).width);

    if (window.isAtLeastMedium) {
      return _Rail(
        destinations: destinations,
        currentIndex: currentIndex,
        onSelected: onDestinationSelected,
        header: railHeader,
        showLabels: window == DSWindowSize.expanded,
        child: child,
      );
    }

    if (context.ds.isCupertino) {
      return _CupertinoBottomBar(
        destinations: destinations,
        currentIndex: currentIndex,
        onSelected: onDestinationSelected,
        child: child,
      );
    }

    return _MaterialBottomBar(
      destinations: destinations,
      currentIndex: currentIndex,
      onSelected: onDestinationSelected,
      child: child,
    );
  }
}

class _MaterialBottomBar extends StatelessWidget {
  const _MaterialBottomBar({
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    required this.child,
  });

  final List<DSNavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onSelected,
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.materialIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

class _CupertinoBottomBar extends StatelessWidget {
  const _CupertinoBottomBar({
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    required this.child,
  });

  final List<DSNavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return ColoredBox(
      color: ds.colors.surface,
      child: Column(
        children: [
          Expanded(child: child),
          CupertinoTabBar(
            currentIndex: currentIndex,
            onTap: onSelected,
            backgroundColor: ds.colors.surfaceElevated.withValues(alpha: 0.94),
            activeColor: ds.colors.brand,
            inactiveColor: ds.colors.onSurfaceMuted,
            border: Border(top: BorderSide(color: ds.colors.separator)),
            items: [
              for (final destination in destinations)
                BottomNavigationBarItem(
                  icon: Icon(destination.cupertinoIcon),
                  label: destination.label,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    required this.header,
    required this.showLabels,
    required this.child,
  });

  final List<DSNavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final String header;

  final bool showLabels;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    return ColoredBox(
      color: ds.colors.surface,
      child: Row(
        children: [
          Container(
            width: showLabels ? 220 : 84,
            color: ds.colors.surfaceElevated,
            child: SafeArea(
              right: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DSGap.lg(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DSSpacing.lg,
                    ),
                    child: DSText(
                      header,
                      role: DSTextRole.subtitle,
                      maxLines: 1,
                      textAlign: showLabels
                          ? TextAlign.start
                          : TextAlign.center,
                    ),
                  ),
                  const DSGap.lg(),
                  for (var i = 0; i < destinations.length; i++)
                    _RailItem(
                      destination: destinations[i],
                      isSelected: i == currentIndex,
                      showLabel: showLabels,
                      onTap: () => onSelected(i),
                    ),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: ds.colors.separator),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.destination,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final DSNavigationDestination destination;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final foreground = isSelected
        ? ds.colors.onBrandSubtle
        : ds.colors.onSurfaceMuted;

    return Semantics(
      selected: isSelected,
      button: true,
      label: destination.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: DSMotion.fast,
          curve: DSMotion.standard,
          margin: const EdgeInsets.symmetric(
            horizontal: DSSpacing.sm,
            vertical: DSSpacing.xxs,
          ),
          padding: const EdgeInsets.all(DSSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? ds.colors.brandSubtle : null,
            borderRadius: ds.radii.controlAll,
          ),
          child: Row(
            mainAxisAlignment: showLabel
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                destination.icon(ds.designLanguage),
                color: foreground,
                size: 24,
              ),
              if (showLabel) ...[
                const DSGap.md(),
                Flexible(
                  child: DSText(
                    destination.label,
                    role: DSTextRole.label,
                    color: foreground,
                    maxLines: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
