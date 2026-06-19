import 'package:flutter/material.dart';
import 'reading_tab_navigator.dart';
import 'chat_screen.dart';
import 'meanings_screen.dart';
import 'my_menu_screen.dart';
import 'my_menu_tab_navigator.dart';
import 'diary_screen.dart';
import 'growth_screen.dart';
import 'shop_screen.dart';
import '../widgets/custom_image_icon.dart';
import '../widgets/coin_widget.dart';
import '../widgets/magic_dust_widget.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';

final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key ?? mainScreenKey);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    const ReadingTabNavigator(),
    const ChatScreen(),
    DiaryScreen(),
    const MeaningsScreen(),
    const MyMenuTabNavigator(),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: TopFloatingIcons(
                onShop: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopScreen()),
                  );
                },
                onGrowth: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GrowthScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: switchTab,
      ),
    );
  }
}
