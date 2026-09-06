enum ComponentGroup { actions, inputs, selection, containment, feedback }

enum ComponentId {
  button('button', ComponentGroup.actions),
  textField('text-field', ComponentGroup.inputs),
  toggle('switch', ComponentGroup.selection),
  slider('slider', ComponentGroup.selection),
  segmentedControl('segmented-control', ComponentGroup.selection),
  card('card', ComponentGroup.containment),
  listSection('list-section', ComponentGroup.containment),
  avatarBadge('avatar-badge', ComponentGroup.containment),
  dialog('dialog', ComponentGroup.feedback),
  actionSheet('action-sheet', ComponentGroup.feedback),
  toast('toast', ComponentGroup.feedback),
  progress('progress', ComponentGroup.feedback);

  const ComponentId(this.slug, this.group);

  final String slug;
  final ComponentGroup group;

  static ComponentId? fromSlug(String? slug) {
    if (slug == null) return null;

    for (final id in values) {
      if (id.slug == slug) return id;
    }
    return null;
  }

  static List<ComponentId> inGroup(ComponentGroup group) {
    return values.where((id) => id.group == group).toList();
  }
}
