import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String userKey = "userProfile";
  static const String actionsKey = "userActions";

  static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(profile));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(userKey);
    return profileString != null ? jsonDecode(profileString) : null;
  }

  static Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  static Future<void> saveUserAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> actions = prefs.getStringList(actionsKey) ?? [];
    actions.add(action);
    await prefs.setStringList(actionsKey, actions);
  }

  static Future<List<String>> getUserActions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(actionsKey) ?? [];
  }

  static Future<void> clearUserActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(actionsKey);
  }
}