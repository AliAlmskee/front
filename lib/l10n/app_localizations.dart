import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Add the 'of' method
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Variable to store localized strings
  late final Map<String, dynamic> _localizedStrings;

  // Helper method to load JSON files
  static Future<AppLocalizations> load(Locale locale) async {
    final appLocalizations = AppLocalizations(locale);
    final jsonString =
        await rootBundle.loadString('lib/l10n/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    appLocalizations._localizedStrings = jsonMap;
    return appLocalizations;
  }

  // Method to fetch a translated string
  // Updated translate method to handle optional arguments
  String translate(String key, {Map<String, String>? args}) {
    String translation = _localizedStrings[key] ?? key;

    // Replace placeholders with arguments if provided
    if (args != null) {
      args.forEach((placeholder, value) {
        translation = translation.replaceAll('{$placeholder}', value);
      });
    }

    return translation;
  }

  // LocalizationsDelegate to load app localizations
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
