import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

extension ComponentCopy on ComponentId {
  String title(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ComponentId.button => l10n.componentButton,
      ComponentId.textField => l10n.componentTextField,
      ComponentId.toggle => l10n.componentSwitch,
      ComponentId.slider => l10n.componentSlider,
      ComponentId.segmentedControl => l10n.componentSegmented,
      ComponentId.card => l10n.componentCard,
      ComponentId.listSection => l10n.componentListSection,
      ComponentId.avatarBadge => l10n.componentAvatarBadge,
      ComponentId.dialog => l10n.componentDialog,
      ComponentId.actionSheet => l10n.componentActionSheet,
      ComponentId.toast => l10n.componentToast,
      ComponentId.progress => l10n.componentProgress,
    };
  }

  String description(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ComponentId.button => l10n.componentButtonDescription,
      ComponentId.textField => l10n.componentTextFieldDescription,
      ComponentId.toggle => l10n.componentSwitchDescription,
      ComponentId.slider => l10n.componentSliderDescription,
      ComponentId.segmentedControl => l10n.componentSegmentedDescription,
      ComponentId.card => l10n.componentCardDescription,
      ComponentId.listSection => l10n.componentListSectionDescription,
      ComponentId.avatarBadge => l10n.componentAvatarBadgeDescription,
      ComponentId.dialog => l10n.componentDialogDescription,
      ComponentId.actionSheet => l10n.componentActionSheetDescription,
      ComponentId.toast => l10n.componentToastDescription,
      ComponentId.progress => l10n.componentProgressDescription,
    };
  }

  IconData icon(DesignLanguage language) {
    final bool cupertino = language.isCupertino;
    return switch (this) {
      ComponentId.button =>
        cupertino ? CupertinoIcons.rectangle_fill : Icons.smart_button_outlined,
      ComponentId.textField =>
        cupertino ? CupertinoIcons.textbox : Icons.text_fields,
      ComponentId.toggle =>
        cupertino ? CupertinoIcons.switch_camera : Icons.toggle_on_outlined,
      ComponentId.slider =>
        cupertino ? CupertinoIcons.slider_horizontal_3 : Icons.tune,
      ComponentId.segmentedControl =>
        cupertino ? CupertinoIcons.square_split_1x2 : Icons.view_week_outlined,
      ComponentId.card =>
        cupertino ? CupertinoIcons.rectangle_stack : Icons.credit_card_outlined,
      ComponentId.listSection =>
        cupertino ? CupertinoIcons.list_bullet : Icons.list_alt_outlined,
      ComponentId.avatarBadge =>
        cupertino
            ? CupertinoIcons.person_circle
            : Icons.account_circle_outlined,
      ComponentId.dialog =>
        cupertino
            ? CupertinoIcons.exclamationmark_bubble
            : Icons.chat_bubble_outline,
      ComponentId.actionSheet =>
        cupertino ? CupertinoIcons.square_arrow_up : Icons.ios_share,
      ComponentId.toast =>
        cupertino ? CupertinoIcons.bell : Icons.notifications_none,
      ComponentId.progress =>
        cupertino ? CupertinoIcons.arrow_2_circlepath : Icons.hourglass_empty,
    };
  }
}

extension ComponentGroupCopy on ComponentGroup {
  String title(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ComponentGroup.actions => l10n.componentsGroupActions,
      ComponentGroup.inputs => l10n.componentsGroupInputs,
      ComponentGroup.selection => l10n.componentsGroupSelection,
      ComponentGroup.containment => l10n.componentsGroupContainment,
      ComponentGroup.feedback => l10n.componentsGroupFeedback,
    };
  }
}
