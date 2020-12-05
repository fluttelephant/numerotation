import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:numerotation/core/App.dart';
import 'package:numerotation/core/Constantes.dart';
///
/// Preferences related
///
const List<String> _supportedLanguages = ['en', 'fr'];

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  ///
  /// Returns the list of supported Locales
  ///
  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  ///
  /// Returns the translation that corresponds to the [key]
  ///
  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues[key] == null)
        ? '** $key not found'
        : _localizedValues[key];
  }

  ///
  /// Returns the current language code
  ///
  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  ///
  /// Returns the current Locale
  ///
  get locale => _locale;

  ///
  /// One-time initialization
  ///
  Future<Null> init([String language]) async {
    var lang = App.prefs.getString("$storageKey$language") ?? null;
    if (lang != null) {
      await setNewLanguage(lang);
    } else {
      if (_locale == null) {
        await setNewLanguage(language);
      }
    }
    /**/
    return null;
  }

  /// ----------------------------------------------------------
  /// Method that saves/restores the preferred language
  /// ----------------------------------------------------------
  getPreferredLanguage() async {
    return _getApplicationSavedInformation();
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation(lang);
  }

  ///
  /// Routine to change the language
  ///
  Future<Null> setNewLanguage(
      [String newLanguage, bool saveInPrefs = true]) async {
    String language = newLanguage;
    if (language == null) {
      language = await getPreferredLanguage();
    }

    // Set the locale
    if (language == "") {
      language = "fr";
    }
    _locale = Locale(language, "");

    // Load the language strings
    String jsonContent =
        await rootBundle.loadString("locale/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs) {
      await setPreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    if (_onLocaleChangedCallback != null) {
      _onLocaleChangedCallback();
    }

    return null;
  }

  ///
  /// Callback to be invoked when the user changes the language
  ///
  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  ///
  /// Application Preferences related
  ///
  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  Future<String> _getApplicationSavedInformation() async {
    return App.prefs.getString("$storageKey$langueSuffix") ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  Future<bool> _setApplicationSavedInformation(String value) async {
    return await App.prefs.setString("$storageKey$langueSuffix", value);
  }

  ///
  /// Singleton Factory
  ///
  static final GlobalTranslations _translations =
      new GlobalTranslations._internal();

  factory GlobalTranslations() {
    return _translations;
  }

  GlobalTranslations._internal();
}

GlobalTranslations allTranslations = new GlobalTranslations();
