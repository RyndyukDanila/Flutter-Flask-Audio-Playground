import 'package:flutter/material.dart';

import '../model/settings_preferences.dart';

class SettingsNotifier extends ChangeNotifier {
  late SettingsPreferences preferences;
  late bool isDark;
  static bool isLocalHost = false;

  SettingsNotifier() {
    isDark = false;
    preferences = SettingsPreferences();
    getPreferences();
  }

  setDarkTheme(bool value) {
    isDark = value;
    preferences.setTheme(value);
    notifyListeners();
  }

  setLocalHost(bool value) {
    isLocalHost = value;
    preferences.setLocalHost(value);
    notifyListeners();
  }

  getPreferences() async {
    isDark = await preferences.getTheme();
    isLocalHost = await preferences.getLocalHost();
    notifyListeners();
  }
}
