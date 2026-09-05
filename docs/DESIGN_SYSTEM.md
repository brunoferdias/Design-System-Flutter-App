# Design system reference

Aurora DS is a token-driven system with two renderings. This document is the contract: what the tokens mean, what each component guarantees, and how to extend either.

## The pipeline

```
DSBrand.seed  ──►  DSColors.fromSeed(seed, brightness, language)
                   DSTypography.of(language)
                   DSRadii.of(language)
                   DSElevation(language)
                          │
                          ▼
                   DSThemeData  ──►  DSMaterialTheme.from(ds)   ──►  ThemeData
                          │      └►  DSCupertinoTheme.from(ds)  ──►  CupertinoThemeData
                          │
                          └────────►  DSTheme (InheritedWidget)  ──►  context.ds
```

`DSThemeData` is the source of truth. `ThemeData` and `CupertinoThemeData` are projections of it, which is why restyling built-in surfaces (dialogs, pickers, the keyboard toolbar) comes for free.

## Accessing tokens

```dart
final ds = context.ds;

ds.colors.brand            // semantic role
ds.typography.subtitle     // type role
ds.radii.control           // resolved per design language
ds.elevation.shadow(DSElevation.level1, shadowColor: ds.colors.shadow)
DSSpacing.lg               // static: the grid is shared

ds.isCupertino
ds.select(material: 16.0, cupertino: 12.0)
```

`DSTheme.of` asserts when the ancestor is missing. Silently falling back to defaults is how design systems rot.

---

## Colour

Roles, never names. A component asks for `danger`, not for red.

| Role | Meaning |
|---|---|
| `brand` / `onBrand` | primary action; filled buttons, selected states, focus rings |
| `brandSubtle` / `onBrandSubtle` | low-emphasis brand wash; selected rows, indicator pills |
| `surface` | the page background |
| `surfaceElevated` | cards, sheets, grouped list rows — one step above `surface` |
| `surfaceSunken` | recessed areas; track backgrounds, code blocks |
| `onSurface` / `onSurfaceMuted` | primary and secondary content |
| `separator` | hairline dividers |
| `border` | visible container borders |
| `danger` / `onDanger` / `dangerSubtle` | destructive actions, validation errors |
| `success` / `warning` / `info` | status colours the Material scheme does not define |
| `scrim` | the wash behind modals |
| `shadow` | the tint elevation shadows use |

### Derivation

`ColorScheme.fromSeed` produces the Material 3 tonal palette, which guarantees the contrast ratios. Cupertino then overrides exactly the roles where Apple's system colours are meaningfully different:

| Role | Material | Cupertino light | Cupertino dark |
|---|---|---|---|
| `surface` | `scheme.surface` | `#F2F2F7` | `#000000` |
| `surfaceElevated` | `scheme.surfaceContainerLow` | `#FFFFFF` | `#1C1C1E` |
| `separator` | `scheme.outlineVariant` | `#3C3C43` @ 36% | `#545458` @ 60% |
| `border` | `scheme.outline` | `#C6C6C8` | `#48484A` |

Brand-derived accents are *not* overridden — the app should still look like itself on both platforms.

`DSColors.catalogue` is the ordered map the Foundations screen renders. Adding a role to it is how a role becomes documented; there is no separate list to forget.

---

## Typography

Eight roles, two sets of metrics.

| Role | Material | Cupertino | Use for |
|---|---|---|---|
| `display` | 36 / 44, w400 | 34 / 41, w700 | page hero, one per screen |
| `headline` | 28 / 36, w400 | 28 / 34, w700 | section headlines |
| `title` | 22 / 28, w500 | 22 / 28, w600 | card and dialog titles |
| `subtitle` | 16 / 24, w500 | 17 / 22, w600 | list row titles, form group labels |
| `body` | 14 / 20, w400 | 17 / 22, w400 | running text |
| `bodyStrong` | 14 / 20, w600 | 17 / 22, w600 | emphasis without a size change |
| `label` | 12 / 16, w500 | 15 / 20, w400 | buttons, tabs, overlines |
| `caption` | 11 / 16, w400 | 13 / 18, w400 | helper text, timestamps |

Material's scale bottoms out at 14pt body copy; Cupertino's body text is 17pt. Same role names, honestly different metrics — that gap is the point.

The font *family* is never specified. The platform supplies it: San Francisco on Apple, Roboto elsewhere.

`DSMaterialTheme` maps the eight roles onto Material's fifteen `TextTheme` slots, so no built-in widget can reach for a style outside the system.

Use `DSText`, which only accepts a role:

```dart
DSText('Total', role: DSTextRole.subtitle)
DSText(hex, role: DSTextRole.caption, color: ds.colors.onSurfaceMuted, maxLines: 1)
```

---

## Spacing

A strict 4-point grid, shared by both platforms.

| Token | Value | Use for |
|---|---|---|
| `xxs` | 2 | hairline gaps between tightly coupled glyphs |
| `xs` | 4 | icon/label separation |
| `sm` | 8 | the default gap inside a component |
| `md` | 12 | gap between sibling controls |
| `lg` | 16 | the default screen gutter |
| `xl` | 24 | separation between content blocks |
| `xxl` | 32 | separation between sections |
| `xxxl` | 48 | hero spacing above a page headline |

`DSGap` turns these into const widgets: `const DSGap.lg()` instead of `SizedBox(height: 16)`. Self-documenting, const, and impossible to write off-grid by accident.

---

## Radius

| Token | Material | Cupertino | Use for |
|---|---|---|---|
| `compact` | 8 | 6 | chips, badges, small inline containers |
| `control` | 20 | 10 | buttons, text fields — anything actionable |
| `surface` | 16 | 12 | cards, grouped list sections |
| `modal` | 28 | 14 | dialogs, sheets |
| `pill` | 999 | 999 | avatars, pills |

The clearest example of a token whose *value* is platform-specific while its *meaning* is not.

---

## Elevation

| Level | Value | Use for |
|---|---|---|
| `level0` | 0 | flush with the page |
| `level1` | 1 | cards, grouped lists |
| `level2` | 3 | app bars once content scrolls under them |
| `level3` | 6 | dialogs, popovers, sheets |

`DSElevation.shadow(level, shadowColor:)` returns a `List<BoxShadow>` on Material and an **empty list** on Cupertino, which expresses depth with hairlines instead. A component asks for "level 1" and gets whichever answer is right.

---

## Motion

Shared across both design languages — one calm motion system reads better than two competing ones.

| Token | Value | Use for |
|---|---|---|
| `instant` | 90ms | state changes the user should barely notice |
| `fast` | 160ms | colour and opacity transitions |
| `normal` | 240ms | layout changes inside a screen |
| `slow` | 400ms | entrances of large surfaces |

| Curve | Value | Use for |
|---|---|---|
| `enter` | `easeOutCubic` | anything entering the screen |
| `exit` | `easeInCubic` | anything leaving |
| `standard` | `easeInOutCubic` | on-screen transformations |
| `emphasized` | `easeOutBack` | confirmation moments |

---

## Breakpoints

| Class | Range | Navigation | Content |
|---|---|---|---|
| `compact` | `< 600dp` | bottom bar | single column, edge to edge |
| `medium` | `600–960dp` | icon rail | single column |
| `expanded` | `> 960dp` | extended rail | centred column |

`DSBreakpoints.maxContentWidth` (720dp) caps reading columns, so a phone screen does not become an unreadable full-width band on a desktop window. `DSPageBody` applies it automatically.

---

## Components

### Three kinds

**Wrappers** map one design-system API onto the platform widget. `DSSwitch` is `Switch` or `CupertinoSwitch`. Trivial, and still worth owning: `Switch.adaptive` adapts to the *host platform*, this adapts to the *user's choice*.

**Reconcilers** absorb a structural disagreement. `DSSegmentedControl` bridges `SegmentedButton` (takes a `Set`) and `CupertinoSlidingSegmentedControl` (takes a `Map`). `DSTextField` reconciles Material's floating label with Cupertino's stacked caption. The incompatibility stops at the component.

**System-owned** components have no platform equivalent, so the design system defines them outright: `DSBadge`, `DSAvatar`, and `DSFeedback.toast`. The toast is painted into the root `Overlay`, which is why it behaves identically under `MaterialApp` and `CupertinoApp`.

### Contracts

| Component | API highlights | Material | Cupertino |
|---|---|---|---|
| `DSButton` | `intent`, `icon`, `isLoading`, `expand` | `FilledButton` / `OutlinedButton` / `TextButton` | `CupertinoButton.filled` / bordered / plain |
| `DSIconButton` | `semanticLabel` **required** | `IconButton` + tooltip | `CupertinoButton`, 44pt target |
| `DSTextField` | `label`, `helperText`, `errorText`, `enabled` | `TextField` + `InputDecoration` | caption + `CupertinoTextField` + footnote |
| `DSSwitch` | `value`, `onChanged`, `semanticLabel` | `Switch` | `CupertinoSwitch` |
| `DSSlider` | `min`, `max`, `divisions` | `Slider` with ticks | `CupertinoSlider`, snaps |
| `DSSegmentedControl<T>` | `segments`, `value` | `SegmentedButton` | `CupertinoSlidingSegmentedControl` |
| `DSCard` | `onTap` optional | bordered card + ink splash | flat surface + opacity fade |
| `DSListSection` | `header`, `footer`, `rows` | card + full-bleed dividers | `CupertinoListSection.insetGrouped` |
| `DSFeedback.confirm` | returns `Future<bool>` | `AlertDialog` | `CupertinoAlertDialog` |
| `DSFeedback.actionSheet` | returns `Future<T?>` | modal bottom sheet | `CupertinoActionSheet` |
| `DSFeedback.toast` | fire and forget | root `Overlay` | root `Overlay` |
| `DSProgressIndicator` | `size` | `CircularProgressIndicator` | `CupertinoActivityIndicator` |
| `DSScaffold` | `title`, `actions`, `leading` | `Scaffold` + `AppBar` | `CupertinoPageScaffold` + nav bar |
| `DSNavigationScaffold` | `destinations`, `currentIndex`, `railHeader` | `NavigationBar` or rail | `CupertinoTabBar` or rail |

### Conventions

* **`onPressed: null` disables.** The same convention Flutter itself uses, so components compose with forms and `ValueListenableBuilder` without special cases.
* **Intent, not appearance.** Callers say `DSButtonIntent.destructive`; the system decides what that looks like today.
* **Semantics are required where they cannot be inferred.** `DSIconButton.semanticLabel` is a required parameter — an icon with no visible label must always carry one for assistive technology.
* **Branch once.** A component switches on `ds.isCupertino` at the top of `build` and never again.
* **Data, not widgets, for list rows.** `DSListRow` is a plain value object, which is what lets one section render as `ListTile`s or `CupertinoListTile`s.

---

## Extending the system

### A new component

1. `lib/design_system/components/ds_thing.dart` — branch on `context.ds.isCupertino` once.
2. Export it from `design_system.dart`.
3. Add a `ComponentId` constant with its URL slug and group.
4. Add title/description keys to all three ARB files, wire them in `component_copy.dart`.
5. Add a live specimen to `component_demo.dart` and a snippet to `component_code.dart`.

Steps 4 and 5 are enforced by the compiler: the `switch` statements over `ComponentId` are exhaustive and will not build until every case is handled. The gallery cannot fall out of sync with the system.

### A new colour role

Add the field to `DSColors`, resolve it in `fromSeed` (with a Cupertino override only if the platforms genuinely disagree), and add it to `catalogue`. The Foundations screen renders that map, so the role documents itself.

### A new brand

Add a constant to `DSBrand` with its seed colour, and a label key to the ARB files. The settings picker iterates `DSBrand.values`.

### When the platforms disagree

Ask in this order:

1. **Is the difference meaningful to the user?** If not, pick one and share it (that is why motion and spacing are shared).
2. **Is it a value or a structure?** A different value belongs in a token (`DSRadii.of`). A different structure belongs in the component (`DSTextField`).
3. **Does neither platform define it?** Then the design system owns it outright (`DSBadge`, `DSFeedback.toast`).

Adding a `ds.select(...)` call inside a *feature* is the signal that one of these three answers was skipped.
