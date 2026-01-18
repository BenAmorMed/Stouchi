import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key for saving theme preference
const String _themePrefsKey = 'theme_mode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences prefs;

  ThemeNotifier(this.prefs) : super(_initialTheme(prefs));

  static ThemeMode _initialTheme(SharedPreferences prefs) {
    final savedTheme = prefs.getString(_themePrefsKey);
    if (savedTheme == 'light') return ThemeMode.light;
    if (savedTheme == 'dark') return ThemeMode.dark;
    return ThemeMode.system; // Default to system if not saved
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveTheme();
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _saveTheme();
  }

  void _saveTheme() {
    final value = state == ThemeMode.light ? 'light' : 'dark';
    prefs.setString(_themePrefsKey, value);
  }
}

// Provider for SharedPreferences (helper)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

// The main ThemeProvider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
