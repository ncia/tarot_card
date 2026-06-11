import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_rm.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('be'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('ml'),
    Locale('ms'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('rm'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @navReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get navReading;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get navChat;

  /// No description provided for @navMeanings.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get navMeanings;

  /// No description provided for @readingIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult the\nSpirits'**
  String get readingIntroTitle;

  /// No description provided for @readingIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The mystical forces are waiting...'**
  String get readingIntroSubtitle;

  /// No description provided for @readingIntroButton.
  ///
  /// In en, this message translates to:
  /// **'Consult Spirits'**
  String get readingIntroButton;

  /// No description provided for @readingSpreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the\nMysteries'**
  String get readingSpreadTitle;

  /// No description provided for @readingSpreadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Tarot Readings'**
  String get readingSpreadSubtitle;

  /// No description provided for @readingSpreadMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'What awaits you in the future...'**
  String get readingSpreadMessageTitle;

  /// No description provided for @readingSpreadMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Prepare for an unexpected journey that brings both challenge and great reward.'**
  String get readingSpreadMessageBody;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Powered\nTarot Chat'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Your Tarot Insights'**
  String get chatSubtitle;

  /// No description provided for @chatName.
  ///
  /// In en, this message translates to:
  /// **'Emilia'**
  String get chatName;

  /// No description provided for @chatBadge.
  ///
  /// In en, this message translates to:
  /// **'AI Chat ✨'**
  String get chatBadge;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Chat Interface Area'**
  String get chatPlaceholder;

  /// No description provided for @meaningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed\nMeanings'**
  String get meaningsTitle;

  /// No description provided for @meaningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Dive into Tarot Cards'**
  String get meaningsSubtitle;

  /// No description provided for @meaningsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Card Details Area'**
  String get meaningsPlaceholder;

  /// No description provided for @card_name_major_00.
  ///
  /// In en, this message translates to:
  /// **'0. The Fool'**
  String get card_name_major_00;

  /// No description provided for @card_upright_major_00.
  ///
  /// In en, this message translates to:
  /// **'New beginnings, adventure, infinite possibilities, freedom, innocence'**
  String get card_upright_major_00;

  /// No description provided for @card_reversed_major_00.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, foolishness, carelessness, taking too big risks, unreality'**
  String get card_reversed_major_00;

  /// No description provided for @card_name_major_01.
  ///
  /// In en, this message translates to:
  /// **'I. The Magician'**
  String get card_name_major_01;

  /// No description provided for @card_upright_major_01.
  ///
  /// In en, this message translates to:
  /// **'Creativity, will, ability, power of new beginnings, determination'**
  String get card_upright_major_01;

  /// No description provided for @card_reversed_major_01.
  ///
  /// In en, this message translates to:
  /// **'Manipulation, wasted talent, deception, lack of confidence, hidden intentions'**
  String get card_reversed_major_01;

  /// No description provided for @card_name_major_02.
  ///
  /// In en, this message translates to:
  /// **'II. The High Priestess'**
  String get card_name_major_02;

  /// No description provided for @card_upright_major_02.
  ///
  /// In en, this message translates to:
  /// **'Intuition, unconscious, mystery, wisdom, inner voice'**
  String get card_upright_major_02;

  /// No description provided for @card_reversed_major_02.
  ///
  /// In en, this message translates to:
  /// **'Ignoring intuition, shallow knowledge, hidden enemies, revealing secrets'**
  String get card_reversed_major_02;

  /// No description provided for @card_name_major_03.
  ///
  /// In en, this message translates to:
  /// **'III. The Empress'**
  String get card_name_major_03;

  /// No description provided for @card_upright_major_03.
  ///
  /// In en, this message translates to:
  /// **'Abundance, motherhood, beauty, fruits of nature, creativity'**
  String get card_upright_major_03;

  /// No description provided for @card_reversed_major_03.
  ///
  /// In en, this message translates to:
  /// **'Overprotection, dependence, creative block, laziness, stagnation'**
  String get card_reversed_major_03;

  /// No description provided for @card_name_major_04.
  ///
  /// In en, this message translates to:
  /// **'IV. The Emperor'**
  String get card_name_major_04;

  /// No description provided for @card_upright_major_04.
  ///
  /// In en, this message translates to:
  /// **'Authority, structure, stability, fatherhood, control, responsibility'**
  String get card_upright_major_04;

  /// No description provided for @card_reversed_major_04.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, desire for control, lack of flexibility, incompetence, repression'**
  String get card_reversed_major_04;

  /// No description provided for @card_name_major_05.
  ///
  /// In en, this message translates to:
  /// **'V. The Hierophant'**
  String get card_name_major_05;

  /// No description provided for @card_upright_major_05.
  ///
  /// In en, this message translates to:
  /// **'Tradition, belief, education, spiritual guidance, conservatism'**
  String get card_upright_major_05;

  /// No description provided for @card_reversed_major_05.
  ///
  /// In en, this message translates to:
  /// **'Rebellion, breaking conventions, dogmatic attitude, outdated ideas, bad advice'**
  String get card_reversed_major_05;

  /// No description provided for @card_name_major_06.
  ///
  /// In en, this message translates to:
  /// **'VI. The Lovers'**
  String get card_name_major_06;

  /// No description provided for @card_upright_major_06.
  ///
  /// In en, this message translates to:
  /// **'Love, harmony, relationships, important choices, trust'**
  String get card_upright_major_06;

  /// No description provided for @card_reversed_major_06.
  ///
  /// In en, this message translates to:
  /// **'Discord, wrong choices, loss of trust, temptation, imbalance'**
  String get card_reversed_major_06;

  /// No description provided for @card_name_major_07.
  ///
  /// In en, this message translates to:
  /// **'VII. The Chariot'**
  String get card_name_major_07;

  /// No description provided for @card_upright_major_07.
  ///
  /// In en, this message translates to:
  /// **'Willpower, victory, determination, direction, drive towards success'**
  String get card_upright_major_07;

  /// No description provided for @card_reversed_major_07.
  ///
  /// In en, this message translates to:
  /// **'Loss of control, loss of direction, helplessness, aggression, obstacles'**
  String get card_reversed_major_07;

  /// No description provided for @card_name_major_08.
  ///
  /// In en, this message translates to:
  /// **'VIII. Strength'**
  String get card_name_major_08;

  /// No description provided for @card_upright_major_08.
  ///
  /// In en, this message translates to:
  /// **'Courage, patience, inner strength, gentle control, compassion'**
  String get card_upright_major_08;

  /// No description provided for @card_reversed_major_08.
  ///
  /// In en, this message translates to:
  /// **'Fear, weakness, loss of self-control, impulsiveness, arrogance'**
  String get card_reversed_major_08;

  /// No description provided for @card_name_major_09.
  ///
  /// In en, this message translates to:
  /// **'IX. The Hermit'**
  String get card_name_major_09;

  /// No description provided for @card_upright_major_09.
  ///
  /// In en, this message translates to:
  /// **'Introspection, wisdom, solitude, enlightenment, spiritual guide'**
  String get card_upright_major_09;

  /// No description provided for @card_reversed_major_09.
  ///
  /// In en, this message translates to:
  /// **'Isolation, loneliness, escapism, foolish stubbornness, reclusiveness'**
  String get card_reversed_major_09;

  /// No description provided for @card_name_major_10.
  ///
  /// In en, this message translates to:
  /// **'X. Wheel of Fortune'**
  String get card_name_major_10;

  /// No description provided for @card_upright_major_10.
  ///
  /// In en, this message translates to:
  /// **'Turning point, destiny, luck, continuous change, opportunity'**
  String get card_upright_major_10;

  /// No description provided for @card_reversed_major_10.
  ///
  /// In en, this message translates to:
  /// **'Bad luck, resistance, uncontrollable change, repetition of misfortune'**
  String get card_reversed_major_10;

  /// No description provided for @card_name_major_11.
  ///
  /// In en, this message translates to:
  /// **'XI. Justice'**
  String get card_name_major_11;

  /// No description provided for @card_upright_major_11.
  ///
  /// In en, this message translates to:
  /// **'Fairness, truth, karma, balance, rational decisions'**
  String get card_upright_major_11;

  /// No description provided for @card_reversed_major_11.
  ///
  /// In en, this message translates to:
  /// **'Unfairness, prejudice, dishonesty, unavoidable punishment, imbalance'**
  String get card_reversed_major_11;

  /// No description provided for @card_name_major_12.
  ///
  /// In en, this message translates to:
  /// **'XII. The Hanged Man'**
  String get card_name_major_12;

  /// No description provided for @card_upright_major_12.
  ///
  /// In en, this message translates to:
  /// **'Sacrifice, new perspective, waiting, insight, temporary suspension'**
  String get card_upright_major_12;

  /// No description provided for @card_reversed_major_12.
  ///
  /// In en, this message translates to:
  /// **'Meaningless sacrifice, delay, refusing progress, selfishness'**
  String get card_reversed_major_12;

  /// No description provided for @card_name_major_13.
  ///
  /// In en, this message translates to:
  /// **'XIII. Death'**
  String get card_name_major_13;

  /// No description provided for @card_upright_major_13.
  ///
  /// In en, this message translates to:
  /// **'End and new beginning, change, transition, clearing the past'**
  String get card_upright_major_13;

  /// No description provided for @card_reversed_major_13.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, stagnation, clinging to the old, fear'**
  String get card_reversed_major_13;

  /// No description provided for @card_name_major_14.
  ///
  /// In en, this message translates to:
  /// **'XIV. Temperance'**
  String get card_name_major_14;

  /// No description provided for @card_upright_major_14.
  ///
  /// In en, this message translates to:
  /// **'Harmony, balance, moderation, healing, sense of purpose'**
  String get card_upright_major_14;

  /// No description provided for @card_reversed_major_14.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, excess, extreme actions, disharmony, conflict'**
  String get card_reversed_major_14;

  /// No description provided for @card_name_major_15.
  ///
  /// In en, this message translates to:
  /// **'XV. The Devil'**
  String get card_name_major_15;

  /// No description provided for @card_upright_major_15.
  ///
  /// In en, this message translates to:
  /// **'Obsession, materialism, bondage, temptation, destructive desires'**
  String get card_upright_major_15;

  /// No description provided for @card_reversed_major_15.
  ///
  /// In en, this message translates to:
  /// **'Liberation, breaking free from bondage, independence, enlightenment, freedom'**
  String get card_reversed_major_15;

  /// No description provided for @card_name_major_16.
  ///
  /// In en, this message translates to:
  /// **'XVI. The Tower'**
  String get card_name_major_16;

  /// No description provided for @card_upright_major_16.
  ///
  /// In en, this message translates to:
  /// **'Sudden change, destruction, liberation, revelation, collapse'**
  String get card_upright_major_16;

  /// No description provided for @card_reversed_major_16.
  ///
  /// In en, this message translates to:
  /// **'Averting disaster, delaying unavoidable change, ignoring warnings'**
  String get card_reversed_major_16;

  /// No description provided for @card_name_major_17.
  ///
  /// In en, this message translates to:
  /// **'XVII. The Star'**
  String get card_name_major_17;

  /// No description provided for @card_upright_major_17.
  ///
  /// In en, this message translates to:
  /// **'Hope, inspiration, serenity, healing and positivity, spiritual guidance'**
  String get card_upright_major_17;

  /// No description provided for @card_reversed_major_17.
  ///
  /// In en, this message translates to:
  /// **'Despair, disappointment, lack of inspiration, pessimism, confusion'**
  String get card_reversed_major_17;

  /// No description provided for @card_name_major_18.
  ///
  /// In en, this message translates to:
  /// **'XVIII. The Moon'**
  String get card_name_major_18;

  /// No description provided for @card_upright_major_18.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, illusion, intuition, hidden truths, deception'**
  String get card_upright_major_18;

  /// No description provided for @card_reversed_major_18.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, discovery of secrets, resolution of anxiety, revealing truth'**
  String get card_reversed_major_18;

  /// No description provided for @card_name_major_19.
  ///
  /// In en, this message translates to:
  /// **'XIX. The Sun'**
  String get card_name_major_19;

  /// No description provided for @card_upright_major_19.
  ///
  /// In en, this message translates to:
  /// **'Success, positivity, vitality, happiness and achievement, joy'**
  String get card_upright_major_19;

  /// No description provided for @card_reversed_major_19.
  ///
  /// In en, this message translates to:
  /// **'Delayed success, exaggeration, decreased vitality, the dark side of joy'**
  String get card_reversed_major_19;

  /// No description provided for @card_name_major_20.
  ///
  /// In en, this message translates to:
  /// **'XX. Judgement'**
  String get card_name_major_20;

  /// No description provided for @card_upright_major_20.
  ///
  /// In en, this message translates to:
  /// **'Rebirth, decision, forgiveness, new calling, inner awakening'**
  String get card_upright_major_20;

  /// No description provided for @card_reversed_major_20.
  ///
  /// In en, this message translates to:
  /// **'Regret, self-doubt, fear of change, lingering attachment, punishment'**
  String get card_reversed_major_20;

  /// No description provided for @card_name_major_21.
  ///
  /// In en, this message translates to:
  /// **'XXI. The World'**
  String get card_name_major_21;

  /// No description provided for @card_upright_major_21.
  ///
  /// In en, this message translates to:
  /// **'Completion, achievement, integration, new dimension, successful ending'**
  String get card_upright_major_21;

  /// No description provided for @card_reversed_major_21.
  ///
  /// In en, this message translates to:
  /// **'Incompletion, postponement, stagnation, fear of success, delay'**
  String get card_reversed_major_21;

  /// No description provided for @card_name_cups_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Cups'**
  String get card_name_cups_01;

  /// No description provided for @card_upright_cups_01.
  ///
  /// In en, this message translates to:
  /// **'New emotions, beginning of love, intuition, spiritual fulfillment'**
  String get card_upright_cups_01;

  /// No description provided for @card_reversed_cups_01.
  ///
  /// In en, this message translates to:
  /// **'Emotional blockage, feeling unloved, emptiness, sadness'**
  String get card_reversed_cups_01;

  /// No description provided for @card_name_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Cups'**
  String get card_name_cups_02;

  /// No description provided for @card_upright_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Relationship harmony, union, love, mutual respect, cooperation'**
  String get card_upright_cups_02;

  /// No description provided for @card_reversed_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Relationship discord, separation, misunderstanding, imbalance, unrequited love'**
  String get card_reversed_cups_02;

  /// No description provided for @card_name_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Cups'**
  String get card_name_cups_03;

  /// No description provided for @card_upright_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Celebration, friendship, community, joy, creative fulfillment'**
  String get card_upright_cups_03;

  /// No description provided for @card_reversed_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Excessive drinking, exclusion, cliques, love triangle, cancelled celebration'**
  String get card_reversed_cups_03;

  /// No description provided for @card_name_cups_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Cups'**
  String get card_name_cups_04;

  /// No description provided for @card_upright_cups_04.
  ///
  /// In en, this message translates to:
  /// **'Indifference, boredom, meditation, missed opportunities, introspection'**
  String get card_upright_cups_04;

  /// No description provided for @card_reversed_cups_04.
  ///
  /// In en, this message translates to:
  /// **'New awareness, seizing opportunities, renewed vitality, awakening'**
  String get card_reversed_cups_04;

  /// No description provided for @card_name_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Cups'**
  String get card_name_cups_05;

  /// No description provided for @card_upright_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Loss, sorrow, regret over the past, pessimism'**
  String get card_upright_cups_05;

  /// No description provided for @card_reversed_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Overcoming loss, acceptance, healing, finding new hope'**
  String get card_reversed_cups_05;

  /// No description provided for @card_name_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Cups'**
  String get card_name_cups_06;

  /// No description provided for @card_upright_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Nostalgia for the past, childhood, innocence, old friends, memories'**
  String get card_upright_cups_06;

  /// No description provided for @card_reversed_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Stuck in the past, ignoring the future, independence, growth'**
  String get card_reversed_cups_06;

  /// No description provided for @card_name_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Cups'**
  String get card_name_cups_07;

  /// No description provided for @card_upright_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Illusion, dreams, confusion of choices, escapism, daydreaming'**
  String get card_upright_cups_07;

  /// No description provided for @card_reversed_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Facing reality, clear goals, waking from illusion, determination'**
  String get card_reversed_cups_07;

  /// No description provided for @card_name_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Cups'**
  String get card_name_cups_08;

  /// No description provided for @card_upright_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Disappointment, departure, abandonment for deeper meaning, resignation'**
  String get card_upright_cups_08;

  /// No description provided for @card_reversed_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Inability to leave, clinging to the past, relationship recovery, fear'**
  String get card_reversed_cups_08;

  /// No description provided for @card_name_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Cups'**
  String get card_name_cups_09;

  /// No description provided for @card_upright_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Wish fulfillment, satisfaction, sensual pleasure, pride, happiness'**
  String get card_upright_cups_09;

  /// No description provided for @card_reversed_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Dissatisfaction, vanity, superficial success, greed, avarice'**
  String get card_reversed_cups_09;

  /// No description provided for @card_name_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Cups'**
  String get card_name_cups_10;

  /// No description provided for @card_upright_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Family happiness, peace, emotional fulfillment, harmonious relationships'**
  String get card_upright_cups_10;

  /// No description provided for @card_reversed_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Family conflict, broken home, discord, loss of peace'**
  String get card_reversed_cups_10;

  /// No description provided for @card_name_cups_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Cups'**
  String get card_name_cups_11;

  /// No description provided for @card_upright_cups_11.
  ///
  /// In en, this message translates to:
  /// **'New inspiration, creativity, emotional message, intuition'**
  String get card_upright_cups_11;

  /// No description provided for @card_reversed_cups_11.
  ///
  /// In en, this message translates to:
  /// **'Emotional immaturity, creative block, bad news, sensitivity'**
  String get card_reversed_cups_11;

  /// No description provided for @card_name_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Cups'**
  String get card_name_cups_12;

  /// No description provided for @card_upright_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Romance, charm, emotional approach, imagination, chivalry'**
  String get card_upright_cups_12;

  /// No description provided for @card_reversed_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Unreality, capriciousness, jealousy, unreliability, deception'**
  String get card_reversed_cups_12;

  /// No description provided for @card_name_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Cups'**
  String get card_name_cups_13;

  /// No description provided for @card_upright_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Empathy, tenderness, spiritual intuition, emotional stability, consideration'**
  String get card_upright_cups_13;

  /// No description provided for @card_reversed_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Emotional excess, instability, dependent nature, victim mentality'**
  String get card_reversed_cups_13;

  /// No description provided for @card_name_cups_14.
  ///
  /// In en, this message translates to:
  /// **'King of Cups'**
  String get card_name_cups_14;

  /// No description provided for @card_upright_cups_14.
  ///
  /// In en, this message translates to:
  /// **'Emotional control, balance, diplomacy, tolerance, wise advice'**
  String get card_upright_cups_14;

  /// No description provided for @card_reversed_cups_14.
  ///
  /// In en, this message translates to:
  /// **'Emotional manipulation, coldness, instability, moodiness, ruthlessness'**
  String get card_reversed_cups_14;

  /// No description provided for @card_name_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Pentacles'**
  String get card_name_pentacles_01;

  /// No description provided for @card_upright_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'New opportunities, financial beginnings, abundance, practical achievement'**
  String get card_upright_pentacles_01;

  /// No description provided for @card_reversed_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'Lost opportunities, financial loss, delay, bad investment'**
  String get card_reversed_pentacles_01;

  /// No description provided for @card_name_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Pentacles'**
  String get card_name_pentacles_02;

  /// No description provided for @card_upright_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Balance, adaptability, time/financial management, flexibility'**
  String get card_upright_pentacles_02;

  /// No description provided for @card_reversed_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, overwhelmed, financial difficulties, stress'**
  String get card_reversed_pentacles_02;

  /// No description provided for @card_name_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Pentacles'**
  String get card_name_pentacles_03;

  /// No description provided for @card_upright_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Teamwork, collaboration, skill, recognized effort, construction'**
  String get card_upright_pentacles_03;

  /// No description provided for @card_reversed_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Lack of collaboration, lack of skill, unrecognized effort, conflict of opinions'**
  String get card_reversed_pentacles_03;

  /// No description provided for @card_name_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Pentacles'**
  String get card_name_pentacles_04;

  /// No description provided for @card_upright_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Stability, possessiveness, conservatism, stinginess, accumulation'**
  String get card_upright_pentacles_04;

  /// No description provided for @card_reversed_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Cost of greed, loss, financial mismanagement, letting go of attachment'**
  String get card_reversed_pentacles_04;

  /// No description provided for @card_name_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Pentacles'**
  String get card_name_pentacles_05;

  /// No description provided for @card_upright_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Poverty, financial/emotional lack, exclusion, adversity'**
  String get card_upright_pentacles_05;

  /// No description provided for @card_reversed_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Financial recovery, helping hand, overcoming adversity, positive change'**
  String get card_reversed_pentacles_05;

  /// No description provided for @card_name_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Pentacles'**
  String get card_name_pentacles_06;

  /// No description provided for @card_upright_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Charity, sharing, patronage, fairness, giving and receiving'**
  String get card_upright_pentacles_06;

  /// No description provided for @card_reversed_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, debt, inequality, showing off, exploitation'**
  String get card_reversed_pentacles_06;

  /// No description provided for @card_name_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Pentacles'**
  String get card_name_pentacles_07;

  /// No description provided for @card_upright_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Patience, long-term vision, waiting for reward for effort, evaluation'**
  String get card_upright_pentacles_07;

  /// No description provided for @card_reversed_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Impatience, fruitless effort, delay, frustration, investment failure'**
  String get card_reversed_pentacles_07;

  /// No description provided for @card_name_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Pentacles'**
  String get card_name_pentacles_08;

  /// No description provided for @card_upright_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Craftsmanship, dedication, attention to detail, mastery'**
  String get card_upright_pentacles_08;

  /// No description provided for @card_reversed_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Boredom, trap of perfectionism, laziness, loss of passion'**
  String get card_reversed_pentacles_08;

  /// No description provided for @card_name_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Pentacles'**
  String get card_name_pentacles_09;

  /// No description provided for @card_upright_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Achievement, independence, leisure, financial comfort, self-reward'**
  String get card_upright_pentacles_09;

  /// No description provided for @card_reversed_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Overspending, superficial glamour, dependence, financial instability'**
  String get card_reversed_pentacles_09;

  /// No description provided for @card_name_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Pentacles'**
  String get card_name_pentacles_10;

  /// No description provided for @card_upright_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Family business, accumulation of wealth, legacy, stable life, tradition'**
  String get card_upright_pentacles_10;

  /// No description provided for @card_reversed_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Loss of wealth, family disputes, rebellion against tradition, instability'**
  String get card_reversed_pentacles_10;

  /// No description provided for @card_name_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Pentacles'**
  String get card_name_pentacles_11;

  /// No description provided for @card_upright_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Realistic goals, new studies, opportunities, practicality, planning'**
  String get card_upright_pentacles_11;

  /// No description provided for @card_reversed_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Delayed plans, lack of practicality, laziness, procrastination'**
  String get card_reversed_pentacles_11;

  /// No description provided for @card_name_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Pentacles'**
  String get card_name_pentacles_12;

  /// No description provided for @card_upright_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Diligence, responsibility, perseverance, gradual progress, reliability'**
  String get card_upright_pentacles_12;

  /// No description provided for @card_reversed_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Stubbornness, apathy, workaholism, lack of flexibility, stagnation'**
  String get card_reversed_pentacles_12;

  /// No description provided for @card_name_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Pentacles'**
  String get card_name_pentacles_13;

  /// No description provided for @card_upright_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Practical care, practical advice, abundance, generosity, comfort'**
  String get card_upright_pentacles_13;

  /// No description provided for @card_reversed_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Overcontrol, possessiveness, selfishness, financial insecurity, overspending'**
  String get card_reversed_pentacles_13;

  /// No description provided for @card_name_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'King of Pentacles'**
  String get card_name_pentacles_14;

  /// No description provided for @card_upright_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'Wealth and success, business acumen, authority, strong patron'**
  String get card_upright_pentacles_14;

  /// No description provided for @card_reversed_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'Materialism, corruption, greed, stubbornness, oppressive authority'**
  String get card_reversed_pentacles_14;

  /// No description provided for @card_name_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Swords'**
  String get card_name_swords_01;

  /// No description provided for @card_upright_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Clear insight, new ideas, truth, mental breakthrough'**
  String get card_upright_swords_01;

  /// No description provided for @card_reversed_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Confusion, misinformation, loss of judgment, lack of communication'**
  String get card_reversed_swords_01;

  /// No description provided for @card_name_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Swords'**
  String get card_name_swords_02;

  /// No description provided for @card_upright_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Indecision, blindness, emotional blockade, avoiding difficult decisions'**
  String get card_upright_swords_02;

  /// No description provided for @card_reversed_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Decision, facing facts, mistakes due to lack of information'**
  String get card_reversed_swords_02;

  /// No description provided for @card_name_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Swords'**
  String get card_name_swords_03;

  /// No description provided for @card_upright_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Heartbreak, sorrow, separation, wounds, painful truth'**
  String get card_upright_swords_03;

  /// No description provided for @card_reversed_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Overcoming pain, healing, forgiveness, shaking off sorrow'**
  String get card_reversed_swords_03;

  /// No description provided for @card_name_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Swords'**
  String get card_name_swords_04;

  /// No description provided for @card_upright_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Rest, recovery, meditation, stress relief, inner peace'**
  String get card_upright_swords_04;

  /// No description provided for @card_reversed_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Exhaustion, refusal to recover, forced rest, extreme stress'**
  String get card_reversed_swords_04;

  /// No description provided for @card_name_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Swords'**
  String get card_name_swords_05;

  /// No description provided for @card_upright_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Pyrrhic victory, betrayal, conflict, hostility, meanness'**
  String get card_upright_swords_05;

  /// No description provided for @card_reversed_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Conflict resolution, reconciliation, compromise, admitting defeat, giving up revenge'**
  String get card_reversed_swords_05;

  /// No description provided for @card_name_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Swords'**
  String get card_name_swords_06;

  /// No description provided for @card_upright_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Transition, moving away from pain, healing journey, movement, travel'**
  String get card_upright_swords_06;

  /// No description provided for @card_reversed_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, past wounds holding back, delay'**
  String get card_reversed_swords_06;

  /// No description provided for @card_name_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Swords'**
  String get card_name_swords_07;

  /// No description provided for @card_upright_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Deception, trickery, strategy, covert actions, escape'**
  String get card_upright_swords_07;

  /// No description provided for @card_reversed_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Confession, revealing secrets, deception exposed, guilt, head-on confrontation'**
  String get card_reversed_swords_07;

  /// No description provided for @card_name_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Swords'**
  String get card_name_swords_08;

  /// No description provided for @card_upright_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Self-imposed limitation, helplessness, limited thinking, prison of fear'**
  String get card_upright_swords_08;

  /// No description provided for @card_reversed_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Liberation, breaking free from one\'s own prison, new perspective'**
  String get card_reversed_swords_08;

  /// No description provided for @card_name_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Swords'**
  String get card_name_swords_09;

  /// No description provided for @card_upright_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, despair, insomnia, guilt, inner fear'**
  String get card_upright_swords_09;

  /// No description provided for @card_reversed_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, light of hope, resolving insomnia, facing facts'**
  String get card_reversed_swords_09;

  /// No description provided for @card_name_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Swords'**
  String get card_name_swords_10;

  /// No description provided for @card_upright_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Ruin, deep wounds, betrayal, hitting rock bottom, arrival of an end'**
  String get card_upright_swords_10;

  /// No description provided for @card_reversed_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Recovery from ruin, the worst is over, survival, reconstruction'**
  String get card_reversed_swords_10;

  /// No description provided for @card_name_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Swords'**
  String get card_name_swords_11;

  /// No description provided for @card_upright_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Curiosity, keen analytical skills, truth-seeking, new ideas'**
  String get card_upright_swords_11;

  /// No description provided for @card_reversed_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Rashness, impatience, cynicism, baseless rumors, rudeness'**
  String get card_reversed_swords_11;

  /// No description provided for @card_name_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Swords'**
  String get card_name_swords_12;

  /// No description provided for @card_upright_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Charge, ambition, intellectual drive, swift and decisive action'**
  String get card_upright_swords_12;

  /// No description provided for @card_reversed_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, aggression, inconsiderate words/actions, impulsiveness, ruthlessness'**
  String get card_reversed_swords_12;

  /// No description provided for @card_name_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Swords'**
  String get card_name_swords_13;

  /// No description provided for @card_upright_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Independence, clear communication, sharp judgment, honesty, objectivity'**
  String get card_upright_swords_13;

  /// No description provided for @card_reversed_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Heartlessness, cruelty, excessive criticism, resentment, isolation'**
  String get card_reversed_swords_13;

  /// No description provided for @card_name_swords_14.
  ///
  /// In en, this message translates to:
  /// **'King of Swords'**
  String get card_name_swords_14;

  /// No description provided for @card_upright_swords_14.
  ///
  /// In en, this message translates to:
  /// **'Authority, intellectual insight, logic, fairness, principles, expert'**
  String get card_upright_swords_14;

  /// No description provided for @card_reversed_swords_14.
  ///
  /// In en, this message translates to:
  /// **'Abuse of power, irrationality, cruelty, desire for control, dictatorship'**
  String get card_reversed_swords_14;

  /// No description provided for @card_name_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Wands'**
  String get card_name_wands_01;

  /// No description provided for @card_upright_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Passion, inspiration, creative power, new potential, vitality'**
  String get card_upright_wands_01;

  /// No description provided for @card_reversed_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Delayed passion, lack of inspiration, loss of motivation, identity confusion'**
  String get card_reversed_wands_01;

  /// No description provided for @card_name_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Wands'**
  String get card_name_wands_02;

  /// No description provided for @card_upright_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Planning, vision, long-term goals, determination, exploration'**
  String get card_upright_wands_02;

  /// No description provided for @card_reversed_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Lack of planning, procrastination, stagnation due to fear, limited vision'**
  String get card_reversed_wands_02;

  /// No description provided for @card_name_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Wands'**
  String get card_name_wands_03;

  /// No description provided for @card_upright_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Realization of hopes, progress, expansion, foresight, leadership'**
  String get card_upright_wands_03;

  /// No description provided for @card_reversed_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Delayed growth, frustration, unexpected obstacles, narrow-mindedness'**
  String get card_reversed_wands_03;

  /// No description provided for @card_name_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Wands'**
  String get card_name_wands_04;

  /// No description provided for @card_upright_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Celebration, comfort, joy of achievement, welcome, domestic event'**
  String get card_upright_wands_04;

  /// No description provided for @card_reversed_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Cancelled event, domestic discord, temporary stability, delayed celebration'**
  String get card_reversed_wands_04;

  /// No description provided for @card_name_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Wands'**
  String get card_name_wands_05;

  /// No description provided for @card_upright_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Competition, conflict, disagreement, disputes, challenge'**
  String get card_upright_wands_05;

  /// No description provided for @card_reversed_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Compromise, avoidance of conflict, cooperation, pursuit of peace, calming confusion'**
  String get card_reversed_wands_05;

  /// No description provided for @card_name_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Wands'**
  String get card_name_wands_06;

  /// No description provided for @card_upright_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Success, public recognition, victory, confidence, rise of a leader'**
  String get card_upright_wands_06;

  /// No description provided for @card_reversed_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Defeat, dishonor, lack of recognition, arrogance, fall from grace'**
  String get card_reversed_wands_06;

  /// No description provided for @card_name_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Wands'**
  String get card_name_wands_07;

  /// No description provided for @card_upright_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Courage, defense, standing up to competition, firm belief, perseverance'**
  String get card_upright_wands_07;

  /// No description provided for @card_reversed_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Giving up, feeling overwhelmed, compromise, loss of confidence, cowardice'**
  String get card_reversed_wands_07;

  /// No description provided for @card_name_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Wands'**
  String get card_name_wands_08;

  /// No description provided for @card_upright_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Rapid progress, quick conclusion, news, agility, speed'**
  String get card_upright_wands_08;

  /// No description provided for @card_reversed_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Delay, confusion, mistakes due to haste, communication breakdown'**
  String get card_reversed_wands_08;

  /// No description provided for @card_name_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Wands'**
  String get card_name_wands_09;

  /// No description provided for @card_upright_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Resilience, defensive stance, continuing despite exhaustion, vigilance, endurance test'**
  String get card_upright_wands_09;

  /// No description provided for @card_reversed_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Fatigue, paranoia, giving up, stubbornness, unnecessary resistance'**
  String get card_reversed_wands_09;

  /// No description provided for @card_name_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Wands'**
  String get card_name_wands_10;

  /// No description provided for @card_upright_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Excessive burden, extreme pressure, responsibility, oppression, breaking point'**
  String get card_upright_wands_10;

  /// No description provided for @card_reversed_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Laying down burden, avoiding responsibility, burnout, delegation, overcoming'**
  String get card_reversed_wands_10;

  /// No description provided for @card_name_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Wands'**
  String get card_name_wands_11;

  /// No description provided for @card_upright_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Exploration, discovery, passionate ideas, energy, charm'**
  String get card_upright_wands_11;

  /// No description provided for @card_reversed_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Loss of direction, immaturity, easily bored, vain delusions, irresponsibility'**
  String get card_reversed_wands_11;

  /// No description provided for @card_name_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Wands'**
  String get card_name_wands_12;

  /// No description provided for @card_upright_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Passionate advancement, adventurous spirit, action, energy, confidence'**
  String get card_upright_wands_12;

  /// No description provided for @card_reversed_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Impulsive action, arrogance, capriciousness, anger, lack of planning'**
  String get card_reversed_wands_12;

  /// No description provided for @card_name_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Wands'**
  String get card_name_wands_13;

  /// No description provided for @card_upright_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Charisma, courage, independence, brightness, charm, vibrancy'**
  String get card_upright_wands_13;

  /// No description provided for @card_reversed_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, ostentation, jealousy, capriciousness, aggression'**
  String get card_reversed_wands_13;

  /// No description provided for @card_name_wands_14.
  ///
  /// In en, this message translates to:
  /// **'King of Wands'**
  String get card_name_wands_14;

  /// No description provided for @card_upright_wands_14.
  ///
  /// In en, this message translates to:
  /// **'Charismatic leadership, vision, inspiration, boldness, entrepreneur'**
  String get card_upright_wands_14;

  /// No description provided for @card_reversed_wands_14.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, impulsive anger, unreality, arrogance, ruthlessness'**
  String get card_reversed_wands_14;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'be',
    'bg',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fa',
    'fi',
    'fr',
    'hi',
    'hr',
    'hu',
    'hy',
    'id',
    'it',
    'ja',
    'ko',
    'lt',
    'lv',
    'ml',
    'ms',
    'no',
    'pl',
    'pt',
    'rm',
    'ro',
    'ru',
    'sk',
    'sl',
    'sr',
    'sv',
    'th',
    'tl',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'ml':
      return AppLocalizationsMl();
    case 'ms':
      return AppLocalizationsMs();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'rm':
      return AppLocalizationsRm();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
