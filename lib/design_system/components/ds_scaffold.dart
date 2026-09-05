import 'package:design_system_flutter/design_system/foundations/ds_breakpoints.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The frame of a page: a top bar with a title plus the page content.
///
/// It becomes a `Scaffold` on Material and a `CupertinoPageScaffold` on
/// Cupertino, so the back button and the bar behave natively on both.
class DSScaffold extends StatelessWidget {
  const DSScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    this.leading,
    super.key,
  });

  final String title;
  final Widget body;

  /// Buttons on the right of the top bar.
  final List<Widget> actions;

  /// Replaces the automatic back button when set.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final ds = context.ds;

    if (ds.isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: ds.colors.surface,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title, style: ds.typography.subtitle),
          backgroundColor: ds.colors.surfaceElevated.withValues(alpha: 0.9),
          border: Border(bottom: BorderSide(color: ds.colors.separator)),
          leading: leading,
          trailing: actions.isEmpty
              ? null
              : Row(mainAxisSize: MainAxisSize.min, children: actions),
        ),
        child: SafeArea(bottom: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: ds.colors.surface,
      appBar: AppBar(
        title: Text(title),
        leading: leading,
        actions: actions,
        // Only let Flutter add a back button when we did not provide one.
        automaticallyImplyLeading: leading == null,
      ),
      body: SafeArea(bottom: false, child: body),
    );
  }
}

/// A scrollable page body that stays centred and never gets too wide to read
/// comfortably on a tablet or desktop.
class DSPageBody extends StatelessWidget {
  const DSPageBody({
    required this.children,
    this.padding = const EdgeInsets.all(DSSpacing.lg),
    this.controller,
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    // Extra bottom padding so the last item clears the home indicator.
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: DSBreakpoints.maxContentWidth,
        ),
        child: ListView(
          controller: controller,
          padding: padding.add(
            EdgeInsets.only(bottom: safeBottom + DSSpacing.xxl),
          ),
          children: children,
        ),
      ),
    );
  }
}
