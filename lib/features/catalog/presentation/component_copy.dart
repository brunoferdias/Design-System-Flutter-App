import 'package:design_system_flutter/core/extensions/build_context_x.dart';
import 'package:design_system_flutter/design_system/foundations/ds_design_language.dart';
import 'package:design_system_flutter/features/catalog/domain/component_id.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

extension ComponentCopy on ComponentId {
  String title(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case ComponentId.button:
        return l10n.componentButton;
      case ComponentId.textField:
        return l10n.componentTextField;
      case ComponentId.toggle:
        return l10n.componentSwitch;
      case ComponentId.slider:
        return l10n.componentSlider;
      case ComponentId.segmentedControl:
        return l10n.componentSegmented;
      case ComponentId.card:
        return l10n.componentCard;
      case ComponentId.listSection:
        return l10n.componentListSection;
      case ComponentId.avatarBadge:
        return l10n.componentAvatarBadge;
      case ComponentId.dialog:
        return l10n.componentDialog;
      case ComponentId.actionSheet:
        return l10n.componentActionSheet;
      case ComponentId.toast:
        return l10n.componentToast;
      case ComponentId.progress:
        return l10n.componentProgress;
    }
  }

  String description(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case ComponentId.button:
        return l10n.componentButtonDescription;
      case ComponentId.textField:
        return l10n.componentTextFieldDescription;
      case ComponentId.toggle:
        return l10n.componentSwitchDescription;
      case ComponentId.slider:
        return l10n.componentSliderDescription;
      case ComponentId.segmentedControl:
        return l10n.componentSegmentedDescription;
      case ComponentId.card:
        return l10n.componentCardDescription;
      case ComponentId.listSection:
        return l10n.componentListSectionDescription;
      case ComponentId.avatarBadge:
        return l10n.componentAvatarBadgeDescription;
      case ComponentId.dialog:
        return l10n.componentDialogDescription;
      case ComponentId.actionSheet:
        return l10n.componentActionSheetDescription;
      case ComponentId.toast:
        return l10n.componentToastDescription;
      case ComponentId.progress:
        return l10n.componentProgressDescription;
    }
  }

  IconData icon(DesignLanguage language) {
    final isCupertino = language.isCupertino;

    switch (this) {
      case ComponentId.button:
        return isCupertino
            ? CupertinoIcons.rectangle_fill
            : Icons.smart_button_outlined;
      case ComponentId.textField:
        return isCupertino ? CupertinoIcons.textbox : Icons.text_fields;
      case ComponentId.toggle:
        return isCupertino
            ? CupertinoIcons.switch_camera
            : Icons.toggle_on_outlined;
      case ComponentId.slider:
        return isCupertino ? CupertinoIcons.slider_horizontal_3 : Icons.tune;
      case ComponentId.segmentedControl:
        return isCupertino
            ? CupertinoIcons.square_split_1x2
            : Icons.view_week_outlined;
      case ComponentId.card:
        return isCupertino
            ? CupertinoIcons.rectangle_stack
            : Icons.credit_card_outlined;
      case ComponentId.listSection:
        return isCupertino
            ? CupertinoIcons.list_bullet
            : Icons.list_alt_outlined;
      case ComponentId.avatarBadge:
        return isCupertino
            ? CupertinoIcons.person_circle
            : Icons.account_circle_outlined;
      case ComponentId.dialog:
        return isCupertino
            ? CupertinoIcons.exclamationmark_bubble
            : Icons.chat_bubble_outline;
      case ComponentId.actionSheet:
        return isCupertino ? CupertinoIcons.square_arrow_up : Icons.ios_share;
      case ComponentId.toast:
        return isCupertino ? CupertinoIcons.bell : Icons.notifications_none;
      case ComponentId.progress:
        return isCupertino
            ? CupertinoIcons.arrow_2_circlepath
            : Icons.hourglass_empty;
    }
  }
}

extension ComponentGroupCopy on ComponentGroup {
  String title(BuildContext context) {
    final l10n = context.l10n;

    switch (this) {
      case ComponentGroup.actions:
        return l10n.componentsGroupActions;
      case ComponentGroup.inputs:
        return l10n.componentsGroupInputs;
      case ComponentGroup.selection:
        return l10n.componentsGroupSelection;
      case ComponentGroup.containment:
        return l10n.componentsGroupContainment;
      case ComponentGroup.feedback:
        return l10n.componentsGroupFeedback;
    }
  }
}
