// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aurora DS';

  @override
  String get appTagline => 'One design system, two design languages.';

  @override
  String get navFoundations => 'Foundations';

  @override
  String get navComponents => 'Components';

  @override
  String get navPlayground => 'Playground';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDone => 'Done';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCopied => 'Copied to clipboard';

  @override
  String get foundationsTitle => 'Foundations';

  @override
  String get foundationsSubtitle =>
      'The primitive values every component is built from.';

  @override
  String get foundationsColor => 'Color';

  @override
  String get foundationsColorDescription =>
      'Semantic roles resolved from a single brand seed, in light and dark.';

  @override
  String get foundationsTypography => 'Typography';

  @override
  String get foundationsTypographyDescription =>
      'A type scale that maps one-to-one onto Material and Cupertino styles.';

  @override
  String get foundationsSpacing => 'Spacing';

  @override
  String get foundationsSpacingDescription =>
      'A 4-point grid keeps rhythm consistent across both platforms.';

  @override
  String get foundationsRadius => 'Radius';

  @override
  String get foundationsRadiusDescription =>
      'Corner radii tuned per platform: softer on Material, tighter on Cupertino.';

  @override
  String get foundationsElevation => 'Elevation';

  @override
  String get foundationsElevationDescription =>
      'Material uses tonal elevation; Cupertino prefers hairline borders.';

  @override
  String get foundationsMotion => 'Motion';

  @override
  String get foundationsMotionDescription =>
      'Durations and curves shared by every animated component.';

  @override
  String get foundationsTapToCopy => 'Tap any token to copy its value.';

  @override
  String get foundationsPreviewLabel => 'Preview';

  @override
  String get componentsTitle => 'Components';

  @override
  String get componentsSubtitle =>
      'Every component below renders natively in both design languages.';

  @override
  String get componentsGroupActions => 'Actions';

  @override
  String get componentsGroupInputs => 'Inputs';

  @override
  String get componentsGroupSelection => 'Selection';

  @override
  String get componentsGroupContainment => 'Containment';

  @override
  String get componentsGroupFeedback => 'Feedback';

  @override
  String get componentButton => 'Button';

  @override
  String get componentButtonDescription =>
      'Primary, secondary, tertiary and destructive intents.';

  @override
  String get componentTextField => 'Text field';

  @override
  String get componentTextFieldDescription =>
      'Labels, hints, validation and error states.';

  @override
  String get componentSwitch => 'Switch';

  @override
  String get componentSwitchDescription =>
      'Binary preference with a platform-correct thumb.';

  @override
  String get componentSlider => 'Slider';

  @override
  String get componentSliderDescription =>
      'Continuous value selection within a range.';

  @override
  String get componentSegmented => 'Segmented control';

  @override
  String get componentSegmentedDescription =>
      'Mutually exclusive options in a compact row.';

  @override
  String get componentCard => 'Card';

  @override
  String get componentCardDescription =>
      'A surface that groups related content.';

  @override
  String get componentListSection => 'List section';

  @override
  String get componentListSectionDescription =>
      'Grouped rows with headers and separators.';

  @override
  String get componentDialog => 'Dialog';

  @override
  String get componentDialogDescription =>
      'Blocking confirmation with cancel and confirm actions.';

  @override
  String get componentActionSheet => 'Action sheet';

  @override
  String get componentActionSheetDescription =>
      'A menu of contextual actions anchored to the bottom.';

  @override
  String get componentToast => 'Toast';

  @override
  String get componentToastDescription =>
      'Transient, non-blocking feedback rendered by the design system itself.';

  @override
  String get componentProgress => 'Progress';

  @override
  String get componentProgressDescription =>
      'Indeterminate activity indicator.';

  @override
  String get componentAvatarBadge => 'Avatar & badge';

  @override
  String get componentAvatarBadgeDescription =>
      'Neutral primitives that look identical on both platforms.';

  @override
  String get showcaseEnabled => 'Enabled';

  @override
  String get showcaseDisabled => 'Disabled';

  @override
  String get showcaseLoading => 'Loading';

  @override
  String get showcaseIntentPrimary => 'Primary';

  @override
  String get showcaseIntentSecondary => 'Secondary';

  @override
  String get showcaseIntentTertiary => 'Tertiary';

  @override
  String get showcaseIntentDestructive => 'Destructive';

  @override
  String get showcaseOpenDialog => 'Open dialog';

  @override
  String get showcaseOpenActionSheet => 'Open action sheet';

  @override
  String get showcaseShowToast => 'Show toast';

  @override
  String get showcaseDialogTitle => 'Discard changes?';

  @override
  String get showcaseDialogMessage =>
      'Your edits to this component have not been saved yet.';

  @override
  String get showcaseSheetTitle => 'Share this component';

  @override
  String get showcaseSheetCopyLink => 'Copy link';

  @override
  String get showcaseSheetExportCode => 'Export code';

  @override
  String get showcaseSheetReport => 'Report an issue';

  @override
  String get showcaseToastMessage =>
      'This toast is drawn by the design system, not by the platform.';

  @override
  String get showcaseSampleLabel => 'Label';

  @override
  String get showcaseSamplePlaceholder => 'Type something…';

  @override
  String get showcaseSampleError => 'This field cannot be empty';

  @override
  String get showcaseSampleHelper =>
      'Helper text explains the expected format.';

  @override
  String get playgroundTitle => 'Playground';

  @override
  String get playgroundSubtitle =>
      'A real screen assembled only from design-system components.';

  @override
  String get bookingHeadline => 'Book your trip';

  @override
  String get bookingFieldName => 'Full name';

  @override
  String get bookingFieldNameHint => 'Ada Lovelace';

  @override
  String get bookingFieldEmail => 'Email';

  @override
  String get bookingFieldEmailHint => 'ada@example.com';

  @override
  String get bookingCabin => 'Cabin';

  @override
  String get bookingCabinEconomy => 'Economy';

  @override
  String get bookingCabinPremium => 'Premium';

  @override
  String get bookingCabinBusiness => 'Business';

  @override
  String get bookingPassengers => 'Passengers';

  @override
  String bookingPassengerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passengers',
      one: '1 passenger',
    );
    return '$_temp0';
  }

  @override
  String get bookingDeparture => 'Departure';

  @override
  String bookingDepartureValue(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get bookingFlexibleFare => 'Flexible fare';

  @override
  String get bookingFlexibleFareDescription =>
      'Change or cancel up to 24 hours before departure.';

  @override
  String get bookingTotal => 'Total';

  @override
  String bookingTotalValue(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.simpleCurrency(locale: localeName, decimalDigits: 2);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString';
  }

  @override
  String get bookingSubmit => 'Book now';

  @override
  String get bookingConfirmTitle => 'Confirm booking';

  @override
  String bookingConfirmMessage(int count, String cabin, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Book $count seats in $cabin for $name?',
      one: 'Book 1 seat in $cabin for $name?',
    );
    return '$_temp0';
  }

  @override
  String bookingSuccess(String name) {
    return 'Booking confirmed for $name.';
  }

  @override
  String get bookingErrorNameRequired => 'Please tell us who is travelling';

  @override
  String get bookingErrorEmailInvalid => 'Enter a valid email address';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionDesignLanguage => 'Design language';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsDesignLanguageDescription =>
      'Choose how every component renders. “Automatic” follows the host platform.';

  @override
  String get designLanguageAutomatic => 'Automatic';

  @override
  String get designLanguageMaterial => 'Material';

  @override
  String get designLanguageCupertino => 'Cupertino';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get settingsBrandColor => 'Brand color';

  @override
  String get settingsBrandColorDescription =>
      'The whole palette is derived from this single seed.';

  @override
  String get brandColorAurora => 'Aurora';

  @override
  String get brandColorForest => 'Forest';

  @override
  String get brandColorSunset => 'Sunset';

  @override
  String get brandColorGraphite => 'Graphite';

  @override
  String get settingsLanguageDescription =>
      'Text, dates, numbers and currency all follow this choice.';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsSourceCode => 'Source code';

  @override
  String get settingsResetTitle => 'Reset settings';

  @override
  String get settingsResetMessage =>
      'Design language, theme, brand color and language will return to their defaults.';

  @override
  String get settingsResetDone => 'Settings restored to defaults';

  @override
  String a11yCurrentDesignLanguage(String language) {
    return 'Current design language: $language';
  }

  @override
  String get a11yToggleDesignLanguage => 'Toggle design language';

  @override
  String a11yColorSwatch(String role, String value) {
    return 'Color role $role, value $value';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Start exploring';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingTryIt =>
      'Go ahead, change something. The whole app follows along.';

  @override
  String get onboardingLivePreview => 'Live preview';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Aurora DS';

  @override
  String get onboardingWelcomeBody =>
      'One design system that speaks two visual languages. Every colour, size and corner you are about to see is generated from a single set of design tokens.';

  @override
  String get onboardingDesignLanguageTitle => 'Choose a design language';

  @override
  String get onboardingDesignLanguageBody =>
      'Material 3 is the Google design language, Cupertino is the Apple one. Automatic follows your device. The components below are literally the same code.';

  @override
  String get onboardingAppearanceTitle => 'Make it yours';

  @override
  String get onboardingAppearanceBody =>
      'Light or dark, plus one brand colour that the entire palette is derived from. Nothing here is hard-coded.';

  @override
  String get onboardingLanguageTitle => 'Speak your language';

  @override
  String get onboardingLanguageBody =>
      'English, Portuguese and German. Dates, numbers and currency follow the same choice — watch this text and the example below change.';

  @override
  String get onboardingTourTitle => 'Where to go next';

  @override
  String get onboardingTourBody =>
      'Four tabs, four ways of looking at the same system.';

  @override
  String get onboardingTourFoundations =>
      'The raw tokens: colour, type, spacing, radius, elevation and motion.';

  @override
  String get onboardingTourComponents =>
      'Every component, in both design languages, with the code to copy.';

  @override
  String get onboardingTourPlayground =>
      'A real booking screen assembled only from those components.';

  @override
  String get onboardingTourSettings =>
      'The four controls that drive this whole demonstration.';

  @override
  String get settingsReplayIntro => 'Replay the introduction';
}
