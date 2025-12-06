import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SettingsModel extends StateNotifier<Settings> {
  SettingsModel()
      : super(Settings(
      isFirstLaunch: true, isPremium: false, notifications: false));

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('app_settings');
    if (jsonString != null) {
      state = Settings.fromJson(jsonString);
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', state.toJson());
  }

  Future<void> setFirstLaunchDone() async {
    state = state.copyWith(isFirstLaunch: false);
    await _saveSettings();
  }

  Future<void> setNotifications(bool status) async {
    state = state.copyWith(notifications: status);
    await _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsModel, Settings>((ref) {
  return SettingsModel();
});
