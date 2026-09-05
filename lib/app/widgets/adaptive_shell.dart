import 'package:design_system_flutter/app/router/app_routes.dart';
import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The navigation chrome wrapped around every top-level destination.
///
/// Two independent axes decide what this renders:
///
/// * **design language** — a Material `NavigationBar` or a `CupertinoTabBar`;
/// * **window size** — a bottom bar on phones, a side rail from 600dp up.
///
/// Both are resolved here, once, so no screen below ever has to care.
final class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({required this.navigationShell, super.key});

  /// `go_router`'s indexed stack: keeps each tab's navigation history alive.
  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    // Tapping the active tab pops it back to its root — the behaviour users
    // expect from both platforms.
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final List<_TabSpec> tabs = _TabSpec.all(context);

    if (context.windowSize.isAtLeastMedium) {
      return _RailLayout(
        tabs: tabs,
        currentIndex: navigationShell.currentIndex,
        onSelected: _onTabSelected,
        child: navigationShell,
      );
    }

    return ds.isCupertino
        ? _CupertinoBottomBarLayout(
            tabs: tabs,
            currentIndex: navigationShell.currentIndex,
            onSelected: _onTabSelected,
            child: navigationShell,
          )
        : _MaterialBottomBarLayout(
            tabs: tabs,
            currentIndex: navigationShell.currentIndex,
            onSelected: _onTabSelected,
            child: navigationShell,
          );
  }
}

/// A destination, with the icon each design language prefers for it.
@immutable
final class _TabSpec {
  const _TabSpec({
    required this.tab,
    required this.label,
    required this.materialIcon,
    required this.cupertinoIcon,
  });

  /// Built from the localizations so the labels follow the selected language.
  static List<_TabSpec> all(BuildContext context) {
    final l10n = context.l10n;
    return <_TabSpec>[
      _TabSpec(
        tab: AppTab.foundations,
        label: l10n.navFoundations,
        materialIcon: Icons.palette_outlined,
        cupertinoIcon: CupertinoIcons.paintbrush,
      ),
      _TabSpec(
        tab: AppTab.components,
        label: l10n.navComponents,
        materialIcon: Icons.widgets_outlined,
        cupertinoIcon: CupertinoIcons.square_stack_3d_up,
      ),
      _TabSpec(
        tab: AppTab.playground,
        label: l10n.navPlayground,
        materialIcon: Icons.science_outlined,
        cupertinoIcon: CupertinoIcons.wand_stars,
      ),
      _TabSpec(
        tab: AppTab.settings,
        label: l10n.navSettings,
        materialIcon: Icons.settings_outlined,
        cupertinoIcon: CupertinoIcons.settings,
      ),
    ];
  }

  final AppTab tab;
  final String label;
  final IconData materialIcon;
  final IconData cupertinoIcon;

  IconData icon(DesignLanguage language) =>
      language.isCupertino ? cupertinoIcon : materialIcon;
}

final class _MaterialBottomBarLayout extends StatelessWidget {
  const _MaterialBottomBarLayout({
    required this.tabs,
    required this.currentIndex,
    required this.onSelected,
    required this.child,
  });

  final List<_TabSpec> tabs;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: child,
    bottomNavigationBar: NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelected,
      destinations: <Widget>[
        for (final _TabSpec tab in tabs)
          NavigationDestination(
            icon: Icon(tab.materialIcon),
            label: tab.label,
          ),
      ],
    ),
  );
}

final class _CupertinoBottomBarLayout extends StatelessWidget {
  const _CupertinoBottomBarLayout({
    required this.tabs,
    required this.currentIndex,
    required this.onSelected,
    required this.child,
  });

  final List<_TabSpec> tabs;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    // `CupertinoTabScaffold` owns its own navigation state, which would fight
    // `go_router`'s. Composing the bar by hand keeps the router authoritative
    // while still rendering Apple's real tab bar.
    return ColoredBox(
      color: ds.colors.surface,
      child: Column(
        children: <Widget>[
          Expanded(child: child),
          CupertinoTabBar(
            currentIndex: currentIndex,
            onTap: onSelected,
            backgroundColor: ds.colors.surfaceElevated.withValues(alpha: 0.94),
            activeColor: ds.colors.brand,
            inactiveColor: ds.colors.onSurfaceMuted,
            border: Border(top: BorderSide(color: ds.colors.separator)),
            items: <BottomNavigationBarItem>[
              for (final _TabSpec tab in tabs)
                BottomNavigationBarItem(
                  icon: Icon(tab.cupertinoIcon),
                  label: tab.label,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The wide-window layout: a persistent rail beside the content.
///
/// Shared by both design languages — a rail is a *layout* decision, not a
/// platform one — but painted entirely from design tokens so it still looks
/// native on each.
final class _RailLayout extends StatelessWidget {
  const _RailLayout({
    required this.tabs,
    required this.currentIndex,
    required this.onSelected,
    required this.child,
  });

  final List<_TabSpec> tabs;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final bool extended = context.windowSize == DSWindowSize.expanded;

    final Widget rail = Container(
      width: extended ? 220 : 84,
      color: ds.colors.surfaceElevated,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DSGap.lg(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
              child: DSText(
                context.l10n.appTitle,
                role: DSTextRole.subtitle,
                maxLines: 1,
                textAlign: extended ? TextAlign.start : TextAlign.center,
              ),
            ),
            const DSGap.lg(),
            for (int i = 0; i < tabs.length; i++)
              _RailItem(
                spec: tabs[i],
                selected: i == currentIndex,
                extended: extended,
                onTap: () => onSelected(i),
              ),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: ds.colors.surface,
      child: Row(
        children: <Widget>[
          rail,
          VerticalDivider(width: 1, thickness: 1, color: ds.colors.separator),
          Expanded(child: child),
        ],
      ),
    );
  }
}

final class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.spec,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;
    final Color foreground = selected
        ? ds.colors.onBrandSubtle
        : ds.colors.onSurfaceMuted;

    return Semantics(
      selected: selected,
      button: true,
      label: spec.label,
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
          padding: const EdgeInsets.symmetric(
            horizontal: DSSpacing.md,
            vertical: DSSpacing.md,
          ),
          decoration: BoxDecoration(
            color: selected ? ds.colors.brandSubtle : null,
            borderRadius: ds.radii.controlAll,
          ),
          child: Row(
            mainAxisAlignment: extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                spec.icon(ds.designLanguage),
                color: foreground,
                size: 24,
              ),
              if (extended) ...<Widget>[
                const DSGap.md(),
                Flexible(
                  child: DSText(
                    spec.label,
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
