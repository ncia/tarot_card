import 'package:flutter/material.dart';
import 'reading_tab_navigator.dart';
import 'chat_screen.dart';
import 'meanings_screen.dart';
import 'my_menu_screen.dart';
import 'diary_screen.dart';
import 'growth_screen.dart';
import 'shop_screen.dart';
import '../widgets/custom_image_icon.dart';
import '../widgets/coin_widget.dart';
import '../widgets/magic_dust_widget.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../widgets/top_floating_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  Widget? _overlayScreen;

  final List<Widget> _screens = [
    const ReadingTabNavigator(),
    const ChatScreen(),
    const DiaryScreen(),
    const MeaningsScreen(),
    const MyMenuScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService().init().then((_) {
      AudioService().playMysteriousBgm();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AudioService().stopBgm();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      AudioService().pauseBgm();
    } else if (state == AppLifecycleState.resumed) {
      AudioService().resumeBgm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (_overlayScreen != null) _overlayScreen!,
          TopFloatingIcons(
            showBackButton: false,
            onBack: () {
              setState(() {
                _overlayScreen = null;
              });
            },
            onShop: () {
              setState(() {
                _overlayScreen = const ShopScreen();
              });
            },
            onGrowth: () {
              setState(() {
                _overlayScreen = const GrowthScreen();
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _overlayScreen = null;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_meanings.png'),
            label: AppLocalizations.of(context)!.navReading,
          ),
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_chat.png'),
            label: AppLocalizations.of(context)!.navChat,
          ),
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_diary.png'),
            label: '타로 일기',
          ),
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_reading.png'),
            label: AppLocalizations.of(context)!.navMeanings,
          ),
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_account.png'),
            label: AppLocalizations.of(context)!.navMyMenu,
          ),
        ],
      ),
    );
  }
}
