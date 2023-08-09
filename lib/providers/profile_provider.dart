import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../entities/task/task.dart';
import '../managers/storage_manager.dart';
import '../services/settings_service.dart';

class ProfileProvider extends ChangeNotifier {
  final _settingsService = SettingsService();

  int _totalTaskCount = 0;
  int get totalTaskCount => _totalTaskCount;

  int _completedTaskCount = 0;
  int get completedTaskCount => _completedTaskCount;

  ThemeMode get theme => _settingsService.themeMode;
  Locale get locale => _settingsService.locale;

  Future<void> loadStats() async {
    _totalTaskCount = 0;
    _completedTaskCount = 0;
    var allTasks = await StorageManager.readFromStorage(
      StorageBoxNames.tasks,
      adapter: TaskAdapter(),
    ) as List<Task>;
    _totalTaskCount = allTasks.length;
    for (var task in allTasks) {
      if (task.isDone) {
        _completedTaskCount++;
      }
    }
    notifyListeners();
  }

  void changeTheme(ThemeMode themeMode) {
    _settingsService.changeTheme(themeMode);
    _settingsService.updateSNBTheme();
    notifyListeners();
  }

  void changeLocale(Locale locale) {
    _settingsService.changeLocale(locale);
    notifyListeners();
  }

  String themeName(
    BuildContext context, {
    ThemeMode? themeMode,
  }) {
    var index = themeMode != null
        ? themeMode.index
        : context.select((ProfileProvider provider) {
            return provider.theme.index;
          });
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.systemTheme;
      case 1:
        return AppLocalizations.of(context)!.lightTheme;
      case 2:
        return AppLocalizations.of(context)!.darkTheme;
      default:
        return "";
    }
  }

  String localeName(
    BuildContext context, {
    Locale? locale,
  }) {
    var languageCode = locale != null
        ? locale.languageCode
        : context.select((ProfileProvider provider) {
            return provider.locale.languageCode;
          });
    switch (languageCode) {
      case 'ru':
        return AppLocalizations.of(context)!.russianLanguage;
      case 'en':
        return AppLocalizations.of(context)!.englishLanguage;
      case 'ko':
        return AppLocalizations.of(context)!.koreanLanguage;
      default:
        return "";
    }
  }
}
