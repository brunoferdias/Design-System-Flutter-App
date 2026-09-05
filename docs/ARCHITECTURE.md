# Architecture

This document explains *why* the code is shaped the way it is. For the token and component reference, see [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md).

## The one constraint everything else follows from

> Only `lib/design_system/` — plus `lib/app/app.dart`, which mounts one of the two app widgets — may import `package:flutter/material.dart` or `package:flutter/cupertino.dart`. Everywhere else, a framework import is allowed only as `show Icons` / `show CupertinoIcons`.

Every other decision in this repository exists to make that rule liveable. If a feature screen ever *needs* an escape hatch, that is a bug in the design system — a missing component or a missing token — not a reason to break the rule.

The rule is what makes "support Material and Cupertino" a runtime setting instead of a fork. It is also what makes the design system replaceable: the app talks to `DSButton`, not to `FilledButton`.

The only sanctioned exception is icon data (`Icons`, `CupertinoIcons`), which is content rather than styling — and even that has to be imported with an explicit `show`.

The rule is not a convention people are asked to remember. `test/architecture/import_boundary_test.dart` walks `lib/` on every run and fails when a feature imports a framework wholesale, when an icon import smuggles in more than icons, or when a component exists but is missing from the barrel. A layering rule that is not executable is a layering suggestion.

## Layers

```
┌──────────────────────────────────────────────────────────────┐
│ presentation      widgets, Riverpod consumers                │
│                   knows: application, design_system, l10n    │
├──────────────────────────────────────────────────────────────┤
│ application       Notifiers, derived providers               │
│                   knows: domain                              │
├──────────────────────────────────────────────────────────────┤
│ domain            entities, value objects, repository        │
│                   interfaces — pure Dart, no Flutter         │
├──────────────────────────────────────────────────────────────┤
│ data              repository implementations, data sources   │
│                   knows: domain                              │
└──────────────────────────────────────────────────────────────┘

design_system/  and  core/  sit beside all of them: a shared kernel
that every layer may depend on and that depends on nothing but Flutter.
```

Arrows point inwards. `data` depends on `domain` (it implements interfaces declared there), never the reverse — that is the dependency inversion that lets `SettingsRepositoryImpl` be swapped for a backend client without touching a single test in `application/`.

### `domain/` — pure Dart

`BookingDraft` computes the fare. `AppSettings` describes a valid configuration. `AppLanguage` is a closed enum, so a locale the app has no translations for is unrepresentable.

Nothing here imports `dart:io`, `BuildContext`, or an HTTP client. The payoff is direct: `test/features/playground/booking_draft_test.dart` covers pricing, validation and clamping without pumping a widget.

One nuance worth naming: `AppSettings` references `DSBrand` and `DesignLanguagePreference`, which live in `design_system/`. That is intentional — the design system is a **shared kernel**, a vocabulary the domain is allowed to speak, not an upper layer reaching down.

### `data/` — the outside world

`SettingsRepositoryImpl` persists four enum names as strings. Every read is defensive:

```dart
static T _decode<T extends Enum>(String? stored, List<T> values, T fallback)
```

An unknown value — from a downgrade, a corrupted store, a renamed constant — degrades to the default instead of throwing at startup. **Persisted data is untrusted input, even when your own app wrote it.**

The `KeyValueStore` interface exists so that this behaviour is testable. `InMemoryKeyValueStore` is three methods, and it removes an entire platform channel from the test suite.

### `application/` — state

Riverpod `Notifier`s, no code generation. Writes are optimistic: state changes first so the UI reacts on the same frame, and persistence is fire-and-forget. Losing a preference must never take the app down.

`SettingsController._update` short-circuits when the next value equals the current one, which is both a rebuild optimisation and a tested behaviour (`setting the same value again does not touch storage`).

Derived providers keep the mapping logic out of widgets:

| Provider | Responsibility |
|---|---|
| `platformIsAppleProvider` | the *only* place `defaultTargetPlatform` is read |
| `designLanguageProvider` | collapses `DesignLanguagePreference` → `DesignLanguage` |
| `localeProvider` | `AppLanguage` → `Locale?` |
| `themeModeProvider` | `AppThemeMode` → Flutter's `ThemeMode` |

Isolating `platformIsApple` behind a provider is what makes "boots into Cupertino on Apple platforms" a one-line override in a test rather than an untestable branch.

### `presentation/` — widgets

Screens are thin. `PlaygroundPage` reads a `BookingDraft`, renders it, and forwards intent to the controller. `SettingsPage` is four controls and a list. Neither contains a business rule or a platform check.

## Composition root

`main()` builds the dependency graph and hands it to `ProviderScope`:

```dart
final store = await SharedPreferencesStore.open();
final repository = SettingsRepositoryImpl(store);
final settings = await repository.load();

runApp(ProviderScope(overrides: [...], child: const AuroraApp()));
```

Two properties fall out of this:

1. **No widget constructs its own dependency.** `settingsRepositoryProvider` and `initialSettingsProvider` throw `UnimplementedError` if left un-overridden, so a wiring mistake fails loudly at startup.
2. **The whole app is testable.** `pumpApp` in `test/helpers/pump_app.dart` mounts the real `AuroraApp` with an in-memory store and a fake platform. The tree under test is the tree that ships.

Settings are loaded *before* `runApp`, not inside a `FutureBuilder`. There is no loading state and no wrong-theme flash.

## Theming: one resolution, two renderings

`AuroraApp` does exactly one interesting thing:

```dart
final brightness = switch (themeMode) {
  ThemeMode.light  => Brightness.light,
  ThemeMode.dark   => Brightness.dark,
  ThemeMode.system => MediaQuery.platformBrightnessOf(context),
};

final ds = DSThemeData.resolve(designLanguage: ..., brightness: brightness, brand: ...);

return DSTheme(
  data: ds,
  child: switch (designLanguage) {
    DesignLanguage.material  => MaterialApp.router(theme: DSMaterialTheme.from(ds), ...),
    DesignLanguage.cupertino => CupertinoApp.router(theme: DSCupertinoTheme.from(ds), ...),
  },
);
```

Three decisions are packed in here:

* **Brightness is resolved eagerly** rather than delegated to `MaterialApp`'s `theme`/`darkTheme` pair. One resolved theme means `DSTheme` and `ThemeData` cannot disagree — and `CupertinoApp` has no `darkTheme`, so this is the only way to give both paths identical behaviour.
* **`DSTheme` sits above both app widgets**, so tokens survive the swap and remain reachable from the root `Overlay` (which is how `DSFeedback.toast` works under either app).
* **Both localization delegate sets are always registered.** In Cupertino mode a Material widget can still surface — the text-selection toolbar, for instance — and a missing delegate only fails at the moment the user reaches for it.

`DSThemeData` implements `==` over `(designLanguage, brand, brightness)` only. Every other field is a pure function of those three, so the comparison is both correct and cheap, and `DSTheme.updateShouldNotify` does not rebuild the world every frame.

## Navigation

`go_router` with `StatefulShellRoute.indexedStack`. Four branches, each preserving its own navigation history; tapping the active tab pops it to its root.

Page transitions are chosen *per navigation*, not at router construction:

```dart
Page<void> adaptivePage(Widget child, GoRouterState state) =>
    switch (ref.read(designLanguageProvider)) {
      DesignLanguage.cupertino => CupertinoPage<void>(key: state.pageKey, child: child),
      DesignLanguage.material  => MaterialPage<void>(key: state.pageKey, child: child),
    };
```

`ref.read` rather than `ref.watch`: the router is infrastructure and must not be rebuilt when a setting changes, but each push should honour the setting as it is *now*.

A single `redirect` guards the introduction: while `AppSettings.hasCompletedOnboarding` is false every location resolves to `/onboarding`, and once it is true `/onboarding` resolves back to `/foundations`. Because the guard reads the same persisted setting the rest of the app does, "has this person seen the intro?" has exactly one answer in the codebase.

Routes are declared once in the `AppRoute` enum. Detail-page slugs (`/components/segmented-control`) are written out explicitly instead of derived from Dart identifiers, so renaming a constant cannot break a bookmark. An unrecognised slug falls back to the gallery — deep links are user input.

### Navigation shell (`DSNavigationScaffold`)

`AdaptiveShell` resolves two independent axes:

| | `< 600dp` | `600–960dp` | `> 960dp` |
|---|---|---|---|
| Material | `NavigationBar` | icon rail | extended rail |
| Cupertino | `CupertinoTabBar` | icon rail | extended rail |

`CupertinoTabScaffold` is deliberately not used: it owns its own navigation state, which would fight `go_router`'s. Composing `CupertinoTabBar` by hand keeps the router authoritative while still rendering Apple's real tab bar.

The rail is shared by both design languages — a rail is a *layout* decision, not a platform one — but it is painted entirely from design tokens, so it still looks native on each.


## Onboarding: state that outlives its widget

The introduction is the one screen where a naive implementation breaks in an instructive way.

Steps 2–4 mutate the real settings so the app changes *underneath* the introduction. Changing the design language swaps `MaterialApp` for `CupertinoApp`, which tears down and rebuilds everything below it. A `PageView` cannot survive that: the `State` may be preserved, but the scroll position is recreated from `PageController.initialPage`, so the flow silently jumps back to step 1.

The fix is to stop treating "which step am I on" as widget state. `onboardingStepProvider` holds it, the widget renders it through an `AnimatedSwitcher`, and a horizontal drag gesture supplies the swipe affordance a `PageView` would have given for free.

This is the general lesson the whole repository is built around: **anything that must survive a design-language switch belongs above the app widget** — the tokens in `DSTheme`, the router in a provider, and the onboarding step in Riverpod.

## Testing strategy

| Level | What it protects | Example |
|---|---|---|
| Pure unit | business rules | flexible fare is charged once per booking, not per seat |
| Repository | persistence + corruption recovery | an unrecognised stored value degrades to its default |
| Controller | state transitions + derived providers | an explicit design language wins over the platform |
| Component | both renderings of one widget | `DSButton` produces `FilledButton` / `CupertinoButton` |
| Localization | translation quality, not just presence | `pt.settingsTitle != en.settingsTitle` |
| App | boot, navigation, deep links, breakpoints | switching the design language re-skins the whole app |
| Onboarding | the introduction flow end to end | switching to Cupertino on step 2 keeps you on step 2 |
| Architecture | the layering rules themselves | no feature file imports `material.dart` |

Two patterns are worth copying:

**Loop the design language.** Interactive component tests assert in both renderings inside a single test, so a Cupertino-only regression cannot hide behind a Material-only assertion.

**Inject the clock.** `clockProvider` is a `DateTime Function()`. It makes a formatted departure date assertable instead of flaky at midnight.

## What is deliberately absent

* **Code generation.** No `freezed`, no `riverpod_generator`, no `build_runner`. `copyWith` and `==` are hand-written. In a reference repository the code you read should be the code that runs.
* **A network layer.** It would add plumbing without adding insight; the repository seam already shows where it would go.
* **Font assets.** The type scale specifies size, weight and line height and lets the platform supply the family — San Francisco on Apple, Roboto elsewhere. That is what "adaptive typography" should mean.
* **Golden tests.** Flutter's test environment renders text with a placeholder font, which makes golden files a poor proxy for visual regression here. Behaviour is asserted structurally instead.
