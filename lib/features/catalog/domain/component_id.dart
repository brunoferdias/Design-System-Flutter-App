/// The sections the catalogue is split into.
enum ComponentGroup { actions, inputs, selection, containment, feedback }

/// Every component shown in the catalogue.
///
/// The slug is what appears in the URL (`/components/text-field`), so it has to
/// stay stable even if the enum value is renamed.
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

  /// Finds a component by its slug, or returns null when the URL points at
  /// something that does not exist.
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
