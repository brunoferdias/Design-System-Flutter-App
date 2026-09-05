/// The sections the component gallery is grouped into.
enum ComponentGroup { actions, inputs, selection, containment, feedback }

/// Every component the gallery can show.
///
/// A closed enum instead of a list of strings: a new component cannot be added
/// without the compiler forcing you to give it a title, a description and a live
/// demo, so the gallery can never fall out of sync with the system.
///
/// The [slug] is part of the app's URL contract (`/components/text-field`), so
/// it is written out explicitly rather than derived from the constant name —
/// renaming a Dart identifier must not break someone's bookmark.
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

  /// The URL segment for this component's detail page.
  final String slug;

  final ComponentGroup group;

  /// Parses a slug coming from a deep link. Returns `null` when unknown.
  static ComponentId? fromSlug(String? slug) {
    if (slug == null) return null;
    for (final ComponentId id in values) {
      if (id.slug == slug) return id;
    }
    return null;
  }

  /// The components of one group, in declaration order.
  static List<ComponentId> inGroup(ComponentGroup group) =>
      values.where((ComponentId id) => id.group == group).toList();
}
