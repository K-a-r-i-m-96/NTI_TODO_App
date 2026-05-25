import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _currentLocale = Locale(localeCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;
    _currentLocale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }
}

final languageProvider = LanguageProvider();
