import 'package:flutter/material.dart';
import 'reading_tab_navigator.dart';
import 'chat_screen.dart';
import 'meanings_screen.dart';
import 'my_menu_screen.dart';
import 'diary_screen.dart';
import '../widgets/custom_image_icon.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../widgets/animated_volume_control.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

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
    AudioService().init().then((_) {
      if (_currentIndex == 0) {
        AudioService().playMysteriousBgm();
      }
    });
  }

  @override
  void dispose() {
    AudioService().stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              AudioService().resumeBgm(); // or play if stopped
            } else {
              AudioService().pauseBgm();
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_reading.png'),
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
            icon: const CustomImageIcon('assets/images/ic_meanings.png'),
            label: AppLocalizations.of(context)!.navMeanings,
          ),
          BottomNavigationBarItem(
            icon: const CustomImageIcon('assets/images/ic_account.png'),
            label: AppLocalizations.of(context)!.navMyMenu,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? const AnimatedVolumeControl()
          : null,
    );
  }
}
