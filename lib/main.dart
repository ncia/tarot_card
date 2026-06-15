import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tarot/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/economy_service.dart';
import 'widgets/top_floating_icons.dart';
import 'screens/shop_screen.dart';
import 'screens/growth_screen.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env");
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
    await EconomyService().initializeNewUser();
  } catch (e) {
    debugPrint('Firebase initialization failed (not configured yet?): $e');
  }

  runApp(const TarotApp());
}

class TarotApp extends StatelessWidget {
  const TarotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '타로마녀',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ko'), // Korean
        Locale('ja'), // Japanese
        Locale('zh'), // Chinese
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
        Locale('ru'), // Russian
        Locale('pt'), // Portuguese
        Locale('it'), // Italian
        Locale('th'), // Thai
        Locale('vi'), // Vietnamese
        Locale('hi'), // Hindi
        Locale('id'), // Indonesian
        Locale('ar'), // Arabic
        Locale('be'), // Belarusian
        Locale('bg'), // Bulgarian
        Locale('ca'), // Catalan
        Locale('cs'), // Czech
        Locale('da'), // Danish
        Locale('el'), // Greek
        Locale('et'), // Estonian
        Locale('fa'), // Persian
        Locale('fi'), // Finnish
        Locale('hr'), // Croatian
        Locale('hu'), // Hungarian
        Locale('hy'), // Armenian
        Locale('lt'), // Lithuanian
        Locale('lv'), // Latvian
        Locale('ms'), // Malay
        Locale('no'), // Norwegian
        Locale('pl'), // Polish
        Locale('rm'), // Romansh
        Locale('ro'), // Romanian
        Locale('sk'), // Slovak
        Locale('sl'), // Slovenian
        Locale('sr'), // Serbian
        Locale('sv'), // Swedish
        Locale('tl'), // Filipino/Tagalog
        Locale('tr'), // Turkish
        Locale('uk'), // Ukrainian
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // Chinese Simplified
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // Chinese Traditional
        Locale('ml'), // Malayalam
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en');
        // 1. 완벽 일치 (언어 + 스크립트)
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.scriptCode == locale.scriptCode) {
            return supportedLocale;
          }
        }
        // 2. 언어 코드만 일치
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        // 3. 일치하는 언어가 없으면 기본값(영어) 사용
        return const Locale('en');
      },
      navigatorKey: globalNavigatorKey,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Stack(
                children: [
                  if (child != null) child,
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Material(
                      type: MaterialType.transparency,
                      child: TopFloatingIcons(
                        onShop: () {
                          if (globalNavigatorKey.currentContext == null) return;
                          Navigator.push(
                            globalNavigatorKey.currentContext!,
                            MaterialPageRoute(builder: (context) => const ShopScreen()),
                          );
                        },
                        onGrowth: () {
                          if (globalNavigatorKey.currentContext == null) return;
                          Navigator.push(
                            globalNavigatorKey.currentContext!,
                            MaterialPageRoute(builder: (context) => const GrowthScreen()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      home: const MainScreen(),
    );
  }
}
