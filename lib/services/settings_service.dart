import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../managers/storage_manager.dart';

class SettingsService {
  SettingsService._singleton();
  static final _instance = SettingsService._singleton();
  factory SettingsService() => _instance;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode {
    updateSNBTheme();
    return _themeMode;
  }

  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  Future<void> init() async {
    var themeIndex = await StorageManager.readFromStorage(
          StorageBoxNames.settings,
          key: 'thememode',
        ) ??
        0;
    _themeMode = ThemeMode.values[themeIndex];
    var languageCode = await StorageManager.readFromStorage(
          StorageBoxNames.settings,
          key: 'locale',
        ) ??
        'ru';
    _locale = Locale(languageCode);
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    await StorageManager.writeToStorage(
      StorageBoxNames.settings,
      key: 'thememode',
      value: themeMode.index,
    );
  }

  void updateSNBTheme() {
    switch (_themeMode.index) {
      case 0:
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xFFF5F5F5),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      case 1:
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xFFF5F5F5),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
        break;
      case 2:
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xFF141414),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
        break;
    }
  }

  Future<void> changeLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    _locale = locale;
    await StorageManager.writeToStorage(
      StorageBoxNames.settings,
      key: 'locale',
      value: locale.languageCode,
    );
  }
}
