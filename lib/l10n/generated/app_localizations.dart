import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('pt'),
  ];

  /// Name of the application, shown in the OS task switcher.
  ///
  /// In en, this message translates to:
  /// **'Aurora DS'**
  String get appTitle;

  /// Short marketing line shown on the home header.
  ///
  /// In en, this message translates to:
  /// **'One design system, two design languages.'**
  String get appTagline;

  /// Bottom navigation label for the design tokens section.
  ///
  /// In en, this message translates to:
  /// **'Foundations'**
  String get navFoundations;

  /// Bottom navigation label for the component gallery.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get navComponents;

  /// Bottom navigation label for the realistic demo screen.
  ///
  /// In en, this message translates to:
  /// **'Playground'**
  String get navPlayground;

  /// Bottom navigation label for the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Dismisses a dialog without applying changes.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Accepts the action proposed by a dialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Closes a sheet or dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Finishes the current step.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// Restores default values.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// Destructive action label.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Persists the current input.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Toast shown after copying a design token value.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get commonCopied;

  /// Title of the foundations page.
  ///
  /// In en, this message translates to:
  /// **'Foundations'**
  String get foundationsTitle;

  /// Subtitle of the foundations page.
  ///
  /// In en, this message translates to:
  /// **'The primitive values every component is built from.'**
  String get foundationsSubtitle;

  /// Section title for color tokens.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get foundationsColor;

  /// Explains the color token section.
  ///
  /// In en, this message translates to:
  /// **'Semantic roles resolved from a single brand seed, in light and dark.'**
  String get foundationsColorDescription;

  /// Section title for type tokens.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get foundationsTypography;

  /// Explains the typography section.
  ///
  /// In en, this message translates to:
  /// **'A type scale that maps one-to-one onto Material and Cupertino styles.'**
  String get foundationsTypographyDescription;

  /// Section title for spacing tokens.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get foundationsSpacing;

  /// Explains the spacing section.
  ///
  /// In en, this message translates to:
  /// **'A 4-point grid keeps rhythm consistent across both platforms.'**
  String get foundationsSpacingDescription;

  /// Section title for corner radius tokens.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get foundationsRadius;

  /// Explains the radius section.
  ///
  /// In en, this message translates to:
  /// **'Corner radii tuned per platform: softer on Material, tighter on Cupertino.'**
  String get foundationsRadiusDescription;

  /// Section title for elevation tokens.
  ///
  /// In en, this message translates to:
  /// **'Elevation'**
  String get foundationsElevation;

  /// Explains the elevation section.
  ///
  /// In en, this message translates to:
  /// **'Material uses tonal elevation; Cupertino prefers hairline borders.'**
  String get foundationsElevationDescription;

  /// Section title for motion tokens.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get foundationsMotion;

  /// Explains the motion section.
  ///
  /// In en, this message translates to:
  /// **'Durations and curves shared by every animated component.'**
  String get foundationsMotionDescription;

  /// Hint shown above the token grid.
  ///
  /// In en, this message translates to:
  /// **'Tap any token to copy its value.'**
  String get foundationsTapToCopy;

  /// Label above a live token preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get foundationsPreviewLabel;

  /// Title of the component gallery.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get componentsTitle;

  /// Subtitle of the component gallery.
  ///
  /// In en, this message translates to:
  /// **'Every component below renders natively in both design languages.'**
  String get componentsSubtitle;

  /// Gallery group containing buttons.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get componentsGroupActions;

  /// Gallery group containing text fields.
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get componentsGroupInputs;

  /// Gallery group containing switches and sliders.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get componentsGroupSelection;

  /// Gallery group containing cards and lists.
  ///
  /// In en, this message translates to:
  /// **'Containment'**
  String get componentsGroupContainment;

  /// Gallery group containing dialogs and toasts.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get componentsGroupFeedback;

  /// Name of the button component.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get componentButton;

  /// Describes the button component.
  ///
  /// In en, this message translates to:
  /// **'Primary, secondary, tertiary and destructive intents.'**
  String get componentButtonDescription;

  /// Name of the text field component.
  ///
  /// In en, this message translates to:
  /// **'Text field'**
  String get componentTextField;

  /// Describes the text field component.
  ///
  /// In en, this message translates to:
  /// **'Labels, hints, validation and error states.'**
  String get componentTextFieldDescription;

  /// Name of the switch component.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get componentSwitch;

  /// Describes the switch component.
  ///
  /// In en, this message translates to:
  /// **'Binary preference with a platform-correct thumb.'**
  String get componentSwitchDescription;

  /// Name of the slider component.
  ///
  /// In en, this message translates to:
  /// **'Slider'**
  String get componentSlider;

  /// Describes the slider component.
  ///
  /// In en, this message translates to:
  /// **'Continuous value selection within a range.'**
  String get componentSliderDescription;

  /// Name of the segmented control component.
  ///
  /// In en, this message translates to:
  /// **'Segmented control'**
  String get componentSegmented;

  /// Describes the segmented control.
  ///
  /// In en, this message translates to:
  /// **'Mutually exclusive options in a compact row.'**
  String get componentSegmentedDescription;

  /// Name of the card component.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get componentCard;

  /// Describes the card component.
  ///
  /// In en, this message translates to:
  /// **'A surface that groups related content.'**
  String get componentCardDescription;

  /// Name of the list section component.
  ///
  /// In en, this message translates to:
  /// **'List section'**
  String get componentListSection;

  /// Describes the list section component.
  ///
  /// In en, this message translates to:
  /// **'Grouped rows with headers and separators.'**
  String get componentListSectionDescription;

  /// Name of the dialog component.
  ///
  /// In en, this message translates to:
  /// **'Dialog'**
  String get componentDialog;

  /// Describes the dialog component.
  ///
  /// In en, this message translates to:
  /// **'Blocking confirmation with cancel and confirm actions.'**
  String get componentDialogDescription;

  /// Name of the action sheet component.
  ///
  /// In en, this message translates to:
  /// **'Action sheet'**
  String get componentActionSheet;

  /// Describes the action sheet component.
  ///
  /// In en, this message translates to:
  /// **'A menu of contextual actions anchored to the bottom.'**
  String get componentActionSheetDescription;

  /// Name of the toast component.
  ///
  /// In en, this message translates to:
  /// **'Toast'**
  String get componentToast;

  /// Describes the toast component.
  ///
  /// In en, this message translates to:
  /// **'Transient, non-blocking feedback rendered by the design system itself.'**
  String get componentToastDescription;

  /// Name of the progress indicator component.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get componentProgress;

  /// Describes the progress component.
  ///
  /// In en, this message translates to:
  /// **'Indeterminate activity indicator.'**
  String get componentProgressDescription;

  /// Name of the avatar and badge components.
  ///
  /// In en, this message translates to:
  /// **'Avatar & badge'**
  String get componentAvatarBadge;

  /// Describes avatar and badge.
  ///
  /// In en, this message translates to:
  /// **'Neutral primitives that look identical on both platforms.'**
  String get componentAvatarBadgeDescription;

  /// State label for an interactive demo.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get showcaseEnabled;

  /// State label for an interactive demo.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get showcaseDisabled;

  /// State label for an interactive demo.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get showcaseLoading;

  /// Button intent name.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get showcaseIntentPrimary;

  /// Button intent name.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get showcaseIntentSecondary;

  /// Button intent name.
  ///
  /// In en, this message translates to:
  /// **'Tertiary'**
  String get showcaseIntentTertiary;

  /// Button intent name.
  ///
  /// In en, this message translates to:
  /// **'Destructive'**
  String get showcaseIntentDestructive;

  /// Button that opens the demo dialog.
  ///
  /// In en, this message translates to:
  /// **'Open dialog'**
  String get showcaseOpenDialog;

  /// Button that opens the demo action sheet.
  ///
  /// In en, this message translates to:
  /// **'Open action sheet'**
  String get showcaseOpenActionSheet;

  /// Button that shows the demo toast.
  ///
  /// In en, this message translates to:
  /// **'Show toast'**
  String get showcaseShowToast;

  /// Title of the demo dialog.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get showcaseDialogTitle;

  /// Body of the demo dialog.
  ///
  /// In en, this message translates to:
  /// **'Your edits to this component have not been saved yet.'**
  String get showcaseDialogMessage;

  /// Title of the demo action sheet.
  ///
  /// In en, this message translates to:
  /// **'Share this component'**
  String get showcaseSheetTitle;

  /// Action sheet option.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get showcaseSheetCopyLink;

  /// Action sheet option.
  ///
  /// In en, this message translates to:
  /// **'Export code'**
  String get showcaseSheetExportCode;

  /// Destructive action sheet option.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get showcaseSheetReport;

  /// Message shown inside the demo toast.
  ///
  /// In en, this message translates to:
  /// **'This toast is drawn by the design system, not by the platform.'**
  String get showcaseToastMessage;

  /// Label of the demo text field.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get showcaseSampleLabel;

  /// Placeholder of the demo text field.
  ///
  /// In en, this message translates to:
  /// **'Type something…'**
  String get showcaseSamplePlaceholder;

  /// Error message of the demo text field.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get showcaseSampleError;

  /// Helper text of the demo text field.
  ///
  /// In en, this message translates to:
  /// **'Helper text explains the expected format.'**
  String get showcaseSampleHelper;

  /// Title of the realistic demo screen.
  ///
  /// In en, this message translates to:
  /// **'Playground'**
  String get playgroundTitle;

  /// Subtitle of the demo screen.
  ///
  /// In en, this message translates to:
  /// **'A real screen assembled only from design-system components.'**
  String get playgroundSubtitle;

  /// Headline of the booking form.
  ///
  /// In en, this message translates to:
  /// **'Book your trip'**
  String get bookingHeadline;

  /// Label of the name field.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get bookingFieldName;

  /// Placeholder of the name field.
  ///
  /// In en, this message translates to:
  /// **'Ada Lovelace'**
  String get bookingFieldNameHint;

  /// Label of the email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get bookingFieldEmail;

  /// Placeholder of the email field.
  ///
  /// In en, this message translates to:
  /// **'ada@example.com'**
  String get bookingFieldEmailHint;

  /// Label of the cabin class selector.
  ///
  /// In en, this message translates to:
  /// **'Cabin'**
  String get bookingCabin;

  /// Cabin class option.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get bookingCabinEconomy;

  /// Cabin class option.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get bookingCabinPremium;

  /// Cabin class option.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get bookingCabinBusiness;

  /// Label of the passenger slider.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get bookingPassengers;

  /// Pluralized passenger count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 passenger} other{{count} passengers}}'**
  String bookingPassengerCount(int count);

  /// Label of the departure date row.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get bookingDeparture;

  /// Departure date formatted for the active locale.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String bookingDepartureValue(DateTime date);

  /// Label of the flexible fare switch.
  ///
  /// In en, this message translates to:
  /// **'Flexible fare'**
  String get bookingFlexibleFare;

  /// Explains the flexible fare option.
  ///
  /// In en, this message translates to:
  /// **'Change or cancel up to 24 hours before departure.'**
  String get bookingFlexibleFareDescription;

  /// Label of the total price row.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get bookingTotal;

  /// Total price formatted as currency for the active locale.
  ///
  /// In en, this message translates to:
  /// **'{amount}'**
  String bookingTotalValue(double amount);

  /// Submits the booking form.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookingSubmit;

  /// Title of the booking confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get bookingConfirmTitle;

  /// Body of the booking confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Book 1 seat in {cabin} for {name}?} other{Book {count} seats in {cabin} for {name}?}}'**
  String bookingConfirmMessage(int count, String cabin, String name);

  /// Toast shown after a successful booking.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed for {name}.'**
  String bookingSuccess(String name);

  /// Validation error for an empty name.
  ///
  /// In en, this message translates to:
  /// **'Please tell us who is travelling'**
  String get bookingErrorNameRequired;

  /// Validation error for a malformed email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get bookingErrorEmailInvalid;

  /// Title of the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'Design language'**
  String get settingsSectionDesignLanguage;

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// Settings section header.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// Explains the design language setting.
  ///
  /// In en, this message translates to:
  /// **'Choose how every component renders. “Automatic” follows the host platform.'**
  String get settingsDesignLanguageDescription;

  /// Design language option that follows the platform.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get designLanguageAutomatic;

  /// Design language option forcing Material 3.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get designLanguageMaterial;

  /// Design language option forcing Cupertino.
  ///
  /// In en, this message translates to:
  /// **'Cupertino'**
  String get designLanguageCupertino;

  /// Label of the theme mode selector.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeMode;

  /// Theme option that follows the OS.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// Label of the brand seed color picker.
  ///
  /// In en, this message translates to:
  /// **'Brand color'**
  String get settingsBrandColor;

  /// Explains the brand color setting.
  ///
  /// In en, this message translates to:
  /// **'The whole palette is derived from this single seed.'**
  String get settingsBrandColorDescription;

  /// Name of a brand seed color.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get brandColorAurora;

  /// Name of a brand seed color.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get brandColorForest;

  /// Name of a brand seed color.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get brandColorSunset;

  /// Name of a brand seed color.
  ///
  /// In en, this message translates to:
  /// **'Graphite'**
  String get brandColorGraphite;

  /// Explains the language setting.
  ///
  /// In en, this message translates to:
  /// **'Text, dates, numbers and currency all follow this choice.'**
  String get settingsLanguageDescription;

  /// Locale option that follows the OS.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// Locale option: English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Locale option: Portuguese, always in its own language.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// Locale option: German, always in its own language.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Application version row.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// Row linking to the GitHub repository.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get settingsSourceCode;

  /// Row that restores default settings.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get settingsResetTitle;

  /// Body of the reset confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Design language, theme, brand color and language will return to their defaults.'**
  String get settingsResetMessage;

  /// Toast shown after resetting settings.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to defaults'**
  String get settingsResetDone;

  /// Screen-reader announcement for the design language toggle.
  ///
  /// In en, this message translates to:
  /// **'Current design language: {language}'**
  String a11yCurrentDesignLanguage(String language);

  /// Screen-reader label of the app bar toggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle design language'**
  String get a11yToggleDesignLanguage;

  /// Screen-reader label of a color swatch.
  ///
  /// In en, this message translates to:
  /// **'Color role {role}, value {value}'**
  String a11yColorSwatch(String role, String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
