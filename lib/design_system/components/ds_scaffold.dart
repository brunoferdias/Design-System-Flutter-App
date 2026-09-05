import 'package:design_system_flutter/design_system/foundations/ds_breakpoints.dart';
import 'package:design_system_flutter/design_system/foundations/ds_spacing.dart';
import 'package:design_system_flutter/design_system/theme/ds_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class DSScaffold extends StatelessWidget {
  const DSScaffold({
    required this.title,
    required this.body,
    this.actions = const <Widget>[],
    this.leading,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
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
        automaticallyImplyLeading: leading == null,
      ),
      body: SafeArea(bottom: false, child: body),
    );
  }
}

final class DSPageBody extends StatelessWidget {
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
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: DSBreakpoints.maxContentWidth,
      ),
      child: ListView(
        controller: controller,
        padding: padding.add(
          EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + DSSpacing.xxl,
          ),
        ),
        children: children,
      ),
    ),
  );
}
