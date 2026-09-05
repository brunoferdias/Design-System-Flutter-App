# Aurora DS

**One design system, two design languages.** A production-shaped Flutter app that renders every screen natively in **Material 3** *and* **Cupertino**, fully localized in **English, Portuguese and German** — built to be read as a reference for architecture, design-system design and internationalization.

[![CI](https://github.com/brunodias/design_system_flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/brunodias/design_system_flutter/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.44-blue?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> 🇧🇷 [Leia em português](README.pt-BR.md)

---

## What this repository actually demonstrates

Most "design system" samples are a gallery of widgets. This one tries to answer the harder question: **what has to be true about your architecture for a design system to survive contact with a real app?**

| | |
|---|---|
| **A token pipeline, not a theme file** | One brand seed → semantic colour roles, a type scale, radii, elevation and motion → `ThemeData` *and* `CupertinoThemeData`. Both frameworks are *outputs* of the same source of truth, so they cannot drift. |
| **Adaptive by choice, not by platform** | The user picks Material or Cupertino at runtime, on any device. Swapping re-mounts the whole app — `MaterialApp` ⇄ `CupertinoApp` — and every screen follows without a single edit. |
| **A hard import boundary** | Exactly one file outside `lib/design_system/` imports `material.dart` or `cupertino.dart` — `lib/app/app.dart`, which mounts one of the two app widgets. Feature code physically *cannot* reach around the system, and a test enforces it. |
| **Localization as a first-class concern** | 161 keys × 3 languages, with plurals, locale-aware dates and currency. Missing translations fail the build, not the user. |
| **Layered features** | `domain` (pure Dart) → `data` (I/O) → `application` (state) → `presentation` (widgets), with dependency inversion at the repository seam. |
| **Tests that would catch a regression** | 65 tests covering token resolution, both renderings of every interactive component, persistence, pure business rules, translation quality, the onboarding flow, full-app navigation — and the import boundary itself. |

---

## Quick start

```bash
flutter --version        # 3.44.2 or newer
flutter pub get
flutter gen-l10n         # generates lib/l10n/generated (also run by `flutter run`)
flutter run
```

Useful commands:

```bash
flutter test                       # 65 tests
flutter analyze --fatal-infos      # the analyzer is part of the contract
dart format lib test
flutter run -d chrome              # deep links work: /components/segmented-control
```

---

## The idea in one diagram

```
                    ┌──────────────────────────────┐
   user settings ──►│  AppSettings (pure Dart)     │
                    │  designLanguage · themeMode  │
                    │  brand · language            │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │  DSThemeData.resolve(...)    │   ← the single source of truth
                    │  colors · typography         │
                    │  radii · elevation · motion  │
                    └───────┬──────────────┬───────┘
                            │              │
              ┌─────────────▼──┐        ┌──▼──────────────┐
              │ ThemeData      │        │ CupertinoTheme  │
              │ (Material 3)   │        │ Data            │
              └─────────┬──────┘        └──────┬──────────┘
                        │                      │
              ┌─────────▼──────┐        ┌──────▼──────────┐
              │  MaterialApp   │        │  CupertinoApp   │
              └─────────┬──────┘        └──────┬──────────┘
                        └───────┬──────────────┘
                                │
                    ┌───────────▼──────────────┐
                    │  DSButton · DSTextField  │  ← one API, two renderings
                    │  DSListSection · …       │
                    └───────────┬──────────────┘
                                │
                    ┌───────────▼──────────────┐
                    │  Feature screens         │  ← never import material/cupertino
                    └──────────────────────────┘
```

The two framework themes are **derived**, never hand-written. Change `DSBrand.aurora`'s seed and the Material dialog, the Cupertino picker, the navigation rail and the toast all move together.

---

## Architecture

```
lib/
├── main.dart                     composition root: build dependencies, runApp
├── app/
│   ├── app.dart                  resolves settings → DSThemeData → MaterialApp | CupertinoApp
│   ├── application/              derived providers (design language, locale, theme mode)
│   ├── router/                   go_router config + the enum of every route
│   └── widgets/                  the adaptive navigation shell (tab bar ⇄ rail)
├── core/                         cross-cutting helpers (context extensions, app metadata)
├── design_system/                ← the only place allowed to import material/cupertino
│   ├── foundations/              tokens: colour, type, spacing, radii, elevation, motion
│   ├── theme/                    DSThemeData + the two theme builders
│   ├── components/               16 DS* components
│   └── design_system.dart        the public barrel; features import this and nothing else
├── features/
│   ├── onboarding/               interactive five-step introduction
│   ├── foundations/              live token reference screen
│   ├── catalog/                  component gallery + deep-linkable detail pages
│   ├── playground/               a realistic booking screen built only from DS components
│   └── settings/                 the four controls that drive the demonstration
└── l10n/
    ├── arb/                      app_en.arb · app_pt.arb · app_de.arb
    └── generated/                produced by `flutter gen-l10n` (committed)
```

### Layering rules

Each feature is split the same way, and the dependencies only ever point downwards:

```
presentation ──► application ──► domain ◄── data
   widgets        controllers     entities     repositories,
   (Riverpod      (Notifier,      + repository  data sources
    consumers)     pure state)     interfaces
```

* **`domain/`** is pure Dart — no `BuildContext`, no Flutter, no I/O. `BookingDraft` knows the pricing rules; `AppSettings` knows what a valid configuration is. This is why the business-rule tests run in milliseconds.
* **`data/`** implements the interfaces the domain declares. `SettingsRepositoryImpl` writes through a narrow `KeyValueStore` seam, so tests swap `SharedPreferences` for `InMemoryKeyValueStore` without a platform channel.
* **`application/`** holds Riverpod `Notifier`s. State transitions are total functions; nothing here touches widgets.
* **`presentation/`** is widgets only, and they are only allowed to speak design-system.

### Dependency injection

Everything the app needs from the outside world is created in `main()` and injected downwards:

```dart
runApp(
  ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(repository),
      initialSettingsProvider.overrideWithValue(settings),
    ],
    child: const AuroraApp(),
  ),
);
```

Both providers throw if left un-overridden, so a missing dependency is a loud startup failure rather than a silent default. The whole app mounts in a widget test with the same two overrides plus one for the platform — see `test/helpers/pump_app.dart`.

Settings are read from disk **before the first frame**. A design-system app that flashes the wrong theme for 200ms undermines its own point.

---

## The design system

### Tokens

| Token | Type | Platform-dependent? | Notes |
|---|---|---|---|
| `DSColors` | semantic roles | partly | Generated from one seed via the Material 3 tonal algorithm; Cupertino overrides grouped backgrounds and hairline separators |
| `DSTypography` | 8 roles | yes | Material bottoms out at 14pt body, Cupertino at 17pt — same role names, different metrics |
| `DSSpacing` | 4-point grid | no | `xxs` 2 → `xxxl` 48; rhythm is shared deliberately |
| `DSRadii` | 4 roles + pill | yes | Material corners are noticeably softer than Cupertino's |
| `DSElevation` | 4 levels | yes | Material tints and casts shadows; Cupertino returns an empty shadow list and relies on borders |
| `DSMotion` | 4 durations, 4 curves | no | One calm motion system reads better than two competing ones |
| `DSBreakpoints` | 3 window classes | no | Aligned with the Material 3 size classes |

Tokens are published through a plain `InheritedWidget` (`DSTheme`) that sits **above** `MaterialApp`/`CupertinoApp`, so they survive the swap between the two and are trivially available in tests:

```dart
final ds = context.ds;           // DSThemeData
ds.colors.brand                  // semantic role, never a hex literal
ds.radii.control                 // resolved for the active design language
ds.select(material: 16, cupertino: 12);
```

### Components

16 components, each with a single API and two renderings:

| Group | Components |
|---|---|
| Actions | `DSButton` (4 intents, loading, icon, expand), `DSIconButton` |
| Inputs | `DSTextField` (label, helper, error, disabled) |
| Selection | `DSSwitch`, `DSSlider`, `DSSegmentedControl<T>` |
| Containment | `DSCard`, `DSListSection` / `DSListRow`, `DSAvatar`, `DSBadge` |
| Feedback | `DSFeedback.confirm`, `DSFeedback.actionSheet`, `DSFeedback.toast`, `DSProgressIndicator` |
| Layout | `DSScaffold`, `DSPageBody`, `DSNavigationScaffold`, `DSSectionHeader`, `DSGap`, `DSText` |

Three kinds of component show up, and the distinction matters:

1. **Wrappers** — `DSSwitch` picks `Switch` or `CupertinoSwitch`. Trivial, and still worth owning: `Switch.adaptive` adapts to the *host*, this adapts to the *user's choice*.
2. **Reconcilers** — `DSSegmentedControl` bridges `SegmentedButton` (takes a `Set`) and `CupertinoSlidingSegmentedControl` (takes a `Map`). `DSTextField` reconciles a floating label with a stacked caption. The incompatibility stops at the component.
3. **System-owned** — `DSBadge`, `DSAvatar` and `DSFeedback.toast` have no Cupertino equivalent, so the design system defines them outright. The toast is painted into the root `Overlay`, which is why it behaves identically under both app widgets.

### The import rule

`lib/design_system/design_system.dart` is the entire public surface. Feature files import that barrel and, at most, an icon set with an explicit `show Icons` / `show CupertinoIcons`. The only file outside the design system that imports a framework wholesale is `lib/app/app.dart`, which exists precisely to mount `MaterialApp` or `CupertinoApp`.

This is not a convention anyone has to remember — `test/architecture/import_boundary_test.dart` walks `lib/` and fails the build if a feature reaches around the system, if an icon import smuggles in more than icons, or if a component is defined but never exported from the barrel.

---

## Localization

Three languages, no fallbacks in disguise:

| | English | Português | Deutsch |
|---|---|---|---|
| Keys | 161 | 161 | 161 |
| Plurals | ✅ | ✅ | ✅ |
| Dates | `Sunday, March 22, 2026` | `domingo, 22 de março de 2026` | `Sonntag, 22. März 2026` |
| Currency | `$1,234.50` | `R$ 1.234,50` | `1.234,50 €` |

`l10n.yaml` sets `required-resource-attributes: true` and writes any missing message to `l10n_missing.json`, so an untranslated key is a build-time problem. `test/l10n/localizations_test.dart` goes further and asserts that translations are actually *different* from English — catching the subtler bug of a key copied over but never translated.

**Adding a language** is three steps:

1. Copy `lib/l10n/arb/app_en.arb` to `app_<code>.arb`, translate the values, keep the keys.
2. Add the case to `AppLanguage` in `lib/features/settings/domain/app_settings.dart` and a label key for it.
3. Run `flutter gen-l10n`. The settings screen picks it up automatically.

Nothing else changes — the language list in the UI is generated from the enum.

---

## Onboarding

First launch redirects to `/onboarding`, a five-step introduction that teaches the app **by letting you drive it**. Steps 2–4 are not illustrations — they mutate the real settings, so the whole app re-skins, re-themes and re-translates underneath the introduction while it is still on screen.

| Step | What it says | What you can do |
|---|---|---|
| **Welcome** | one design system, one set of tokens | — |
| **Design language** | Material vs. Cupertino vs. Automatic | switch it, and the live preview below (a text field, a switch and a button) re-renders in the other framework |
| **Appearance** | light/dark and one brand seed | switch either, and the swatch grid redraws from the regenerated palette |
| **Language** | English · Português · Deutsch | switch it, and the introduction copy, the date, the plural and the currency in the preview all change |
| **Tour** | what each of the four tabs is for | finish, or skip at any point |

Two details worth noting:

* **The step lives in app state, not in the widget.** `onboardingStepProvider` survives the `MaterialApp` ⇄ `CupertinoApp` remount, so changing the design language on step 2 leaves you on step 2 instead of bouncing back to the start. A `PageView` cannot do this — its scroll position is rebuilt from `initialPage` when the scrollable is re-attached — so the step content is driven by an `AnimatedSwitcher` with a horizontal swipe gesture on top.
* **Completion is persisted like any other setting.** `AppSettings.hasCompletedOnboarding` goes through the same repository, and `Reset settings` deliberately preserves it — resetting your theme should not replay the tutorial. Settings has a **Replay the introduction** row for when you actually want it.

---

## Navigation

`go_router` with a `StatefulShellRoute.indexedStack`: four branches, each keeping its own history. Page transitions are chosen per navigation from the active design language, so a Cupertino session gets the horizontal push with an interactive back-swipe and a Material session gets the fade-forwards transition.

Every route is declared once in `AppRoute`, and component detail pages are deep-linkable:

```
/onboarding                       ← first launch redirects here
/foundations
/components
/components/segmented-control     ← try it on the web build
/playground
/settings
```

Slugs are written out explicitly rather than derived from Dart identifiers — renaming a constant must not break someone's bookmark. An unknown slug falls back to the gallery instead of crashing, because deep links are user input.

### Responsive layout

| Window | Navigation | Content |
|---|---|---|
| `< 600dp` | bottom bar (`NavigationBar` / `CupertinoTabBar`) | single column |
| `600–960dp` | icon rail | single column, capped at 720dp |
| `> 960dp` | extended rail with labels | centred column, capped at 720dp |

---

## Testing

```
test/
├── architecture/import_boundary_test.dart   the layering rules, enforced by the test suite
├── helpers/pump_app.dart              mounts a component, or the whole app, with real themes + l10n
├── design_system/
│   ├── ds_theme_test.dart             token resolution, palette derivation, equality
│   ├── ds_button_test.dart            both renderings, disabled, loading
│   └── ds_components_test.dart        switch, text field, segmented control, avatar, toast lifecycle
├── features/
│   ├── settings/                      repository round-trip, corrupt-value recovery, controller + derived providers
│   ├── onboarding/                    first launch, live re-skin mid-flow, replay from settings
│   └── playground/                    pricing rules, validation, clamping, injected clock
├── l10n/localizations_test.dart       coverage, plurals, date and currency formatting per locale
└── app/app_smoke_test.dart            boot, tab navigation, deep link, language switch, design-language switch, breakpoints
```

Two habits worth stealing:

* **Loop the design language.** Interactive components are asserted in *both* renderings inside one test, so a Cupertino-only regression cannot hide.
* **Inject the clock.** `clockProvider` makes the formatted departure date assertable instead of flaky at midnight.

```dart
for (final language in DesignLanguage.values) {
  await pumpComponent(tester, DSSwitch(...), designLanguage: language);
  await tester.tap(find.byType(DSSwitch));
  expect(received, isTrue, reason: 'no change reported in $language');
}
```

---

## Quality gates

CI runs on every push and pull request:

1. `flutter gen-l10n` + `git diff --exit-code` — generated localizations must match the ARB files.
2. `dart format --set-exit-if-changed`
3. `flutter analyze --fatal-infos` — with `strict-casts`, `strict-inference`, `strict-raw-types` and ~30 extra lints, including `always_use_package_imports`, `require_trailing_commas` and `avoid_dynamic_calls`.
4. `flutter test`
5. `flutter build web --release`

---

## Recipes

<details>
<summary><b>Add a component</b></summary>

1. Create `lib/design_system/components/ds_thing.dart`. Branch on `context.ds.isCupertino` **once**, at the top of `build`.
2. Export it from `lib/design_system/design_system.dart`.
3. Add a constant to `ComponentId` with its URL slug and group.
4. Add title/description keys to the three ARB files and wire them in `component_copy.dart`.
5. Add the live specimen to `component_demo.dart` and a snippet to `component_code.dart`.

The enum makes steps 4 and 5 non-optional: the `switch` statements will not compile until every case is handled.
</details>

<details>
<summary><b>Add a colour role</b></summary>

Add the field to `DSColors`, resolve it in `fromSeed` (with a Cupertino override if the platforms genuinely disagree), and add it to `catalogue`. The Foundations screen renders that map, so a new role documents itself.
</details>

<details>
<summary><b>Add a screen</b></summary>

Create `lib/features/<name>/presentation/<name>_page.dart` returning a `DSScaffold` + `DSPageBody`, add a value to `AppRoute`, and register it in `app_router.dart`. If it needs state, add a `domain/` entity and an `application/` notifier first — the widget should be the last thing you write.
</details>

<details>
<summary><b>Add a brand</b></summary>

Add a constant to `DSBrand` with its seed colour and a label key to the ARB files. The settings picker iterates `DSBrand.values`, so it appears on its own.
</details>

---

## Deliberate trade-offs

Worth stating plainly, since a reference repo should be honest about its edges:

* **`CupertinoApp` swaps in wholesale.** More faithful than tinting a `MaterialApp`, but it means Material-only widgets (`ListTile`, `InkWell`, `Card`) are unavailable in Cupertino mode. That constraint is enforced by the import rule rather than by convention.
* **One resolved theme instead of `theme`/`darkTheme`.** Brightness is resolved in `AuroraApp` so `DSTheme` and `ThemeData` can never disagree — and because `CupertinoApp` has no `darkTheme` to begin with.
* **No code generation.** Riverpod without `riverpod_generator`, hand-written `copyWith`/`==` instead of `freezed`. More typing, but the code you read is the code that runs — which matters more in a reference than in a product.
* **No font assets.** Type is specified by size, weight and line height; the family stays the platform default (San Francisco on Apple, Roboto elsewhere), which is what "adaptive" should mean.
* **`shared_preferences` for persistence.** Behind a `KeyValueStore` interface, so it is a one-file swap.

---

## Further reading

* [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — layers, dependency rules and the reasoning behind them
* [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md) — token reference and component contracts

## License

MIT — see [LICENSE](LICENSE).
