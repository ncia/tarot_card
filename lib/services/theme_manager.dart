import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static final ThemeManager instance = ThemeManager._internal();
  factory ThemeManager() => instance;
  ThemeManager._internal();

  static const String _themePrefKey = 'selected_theme_path';
  
  // 기본 이미지 경로
  static const String _defaultTheme = 'assets/images/theme/magic_circle.png';
  
  // 사용 가능한 테마 목록 (현재 폴더에 있는 파일들)
  final List<String> availableThemes = [
    'assets/images/theme/magic_circle.png',
    'assets/images/theme/magic_circle1.png',
    'assets/images/theme/magic_circle2.png',
    'assets/images/theme/magic_circle4.png',
    'assets/images/theme/magic_book.png',
    'assets/images/theme/black_cat.png',
  ];

  static const String _unlockedThemesKey = 'unlocked_themes_list';

  final ValueNotifier<String> themeNotifier = ValueNotifier<String>(_defaultTheme);
  final ValueNotifier<List<String>> unlockedThemesNotifier = ValueNotifier<List<String>>([]);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load unlocked themes
    final savedUnlocked = prefs.getStringList(_unlockedThemesKey);
    if (savedUnlocked != null) {
      unlockedThemesNotifier.value = savedUnlocked;
    } else {
      // Default free themes
      unlockedThemesNotifier.value = [
        'assets/images/theme/magic_circle.png',
        'assets/images/theme/magic_circle1.png',
        'assets/images/theme/magic_circle2.png',
        'assets/images/theme/magic_circle4.png',
      ];
      await prefs.setStringList(_unlockedThemesKey, unlockedThemesNotifier.value);
    }

    final savedTheme = prefs.getString(_themePrefKey);
    if (savedTheme != null && availableThemes.contains(savedTheme)) {
      themeNotifier.value = savedTheme;
    } else {
      themeNotifier.value = _defaultTheme;
    }
  }

  Future<void> setTheme(String themePath) async {
    if (availableThemes.contains(themePath) && unlockedThemesNotifier.value.contains(themePath)) {
      themeNotifier.value = themePath;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, themePath);
    }
  }

  Future<bool> unlockTheme(String themePath) async {
    if (!unlockedThemesNotifier.value.contains(themePath)) {
      final updatedList = List<String>.from(unlockedThemesNotifier.value)..add(themePath);
      unlockedThemesNotifier.value = updatedList;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_unlockedThemesKey, updatedList);
      return true;
    }
    return false;
  }
}
