import 'package:flutter/material.dart';
import 'reading_intro_screen.dart';
import 'spread_selection_screen.dart';

class ReadingTabNavigator extends StatelessWidget {
  const ReadingTabNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == '/') {
          page = ReadingIntroScreen(
            onStart: (ctx) {
              Navigator.pushNamed(ctx, '/selection');
            },
          );
        } else if (settings.name == '/selection') {
          page = const SpreadSelectionScreen(showBackButton: true);
        } else {
          page = const SizedBox();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
