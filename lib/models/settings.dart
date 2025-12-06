import 'dart:convert';

class Settings {
  final bool isFirstLaunch;
  final bool isPremium;
  final bool notifications;

  Settings({
    required this.isFirstLaunch,
    required this.isPremium,
    required this.notifications,
  });

  factory Settings.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Settings(
      isFirstLaunch: jsonMap['isFirstLaunch'] ?? true,
      isPremium: jsonMap['isPremium'] ?? false,
      notifications: jsonMap['notifications'] ?? false,
    );
  }

  String toJson() {
    return jsonEncode({
      'isFirstLaunch': isFirstLaunch,
      'isPremium': isPremium,
      'notifications': notifications,
    });
  }

  Settings copyWith({
    bool? isFirstLaunch,
    bool? isPremium,
    bool? notifications,
  }) {
    return Settings(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isPremium: isPremium ?? this.isPremium,
      notifications: notifications ?? this.notifications,
    );
  }
}