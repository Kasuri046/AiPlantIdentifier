import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/model/language_model.dart';
import 'package:plantas_ai_plant_identifier/utils/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/images.dart';

class LanguageProvider with ChangeNotifier {
  String searchQuery = '';

  String? currentLanguageCode;
  String? currentLanguageName;

  LanguageModel? selectedLanguage;

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadSelectedLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      currentLanguageCode = prefs.getString('languageCode') ?? 'en';
      log('Loaded language code: $currentLanguageCode');

      currentLanguageName = prefs.getString('languageName') ?? 'English';
      log('Loaded language name: $currentLanguageName');

      _locale = Locale(currentLanguageCode!);

      notifyListeners();
    } catch (e) {
      log('Error loading language: $e');
    }
  }

  Future<void> updateSelectedLanguage(LanguageModel selectedLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    currentLanguageCode = selectedLanguage.languageCode;
    await prefs.setString('languageCode', currentLanguageCode!);
    log('Updated language code: $currentLanguageCode');

    currentLanguageName = selectedLanguage.languageName;
    await prefs.setString('languageName', currentLanguageName!);
    log('Updated language name: $currentLanguageName');

    _locale = Locale(currentLanguageCode!);
    log('Locale updated to: $_locale');

    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      log('SharedPreferences instance obtained.');

      log('Saving language to SharedPreferences...');
      await prefs.setString('languageCode', currentLanguageCode!);
      log('Language code saved: $currentLanguageCode');

      await prefs.setString('languageName', currentLanguageName!);
      log('Language name saved: $currentLanguageName');

      log('Language saved successfully. Code: $currentLanguageCode, Name: $currentLanguageName');
    } catch (e) {
      log('Error saving language: $e');
    }
  }

  void updateLanguageVariable(LanguageModel language) {
    currentLanguageCode = language.languageCode;
    currentLanguageName = language.languageName;
    selectedLanguage = language;
    _locale = Locale(currentLanguageCode!);

    notifyListeners();
  }

  void revertBack() {
    if (currentLanguageCode != null) {
      _locale = Locale(currentLanguageCode!);
      notifyListeners();
    }
  }

  // Method to update the search query
  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  List<LanguageModel> languageItems = [
    LanguageModel(image: AppImages.english, languageName: AppText.english, languageCode: 'en'),
    LanguageModel(image: AppImages.arabic, languageName: AppText.arabic, languageCode: 'ar'),
    LanguageModel(image: AppImages.catalan, languageName: AppText.catalan, languageCode: 'ca'),
    LanguageModel(image: AppImages.chinese, languageName: AppText.chinese, languageCode: 'zh'),
    LanguageModel(image: AppImages.croatian, languageName: AppText.croatian, languageCode: 'hr'),
    LanguageModel(image: AppImages.czech, languageName: AppText.czech, languageCode: 'cs'),
    LanguageModel(image: AppImages.danish, languageName: AppText.danish, languageCode: 'da'),
    LanguageModel(image: AppImages.dutch, languageName: AppText.dutch, languageCode: 'nl'),
    LanguageModel(image: AppImages.finnish, languageName: AppText.finnish, languageCode: 'fi'),
    LanguageModel(image: AppImages.french, languageName: AppText.french, languageCode: 'fr'),
    LanguageModel(image: AppImages.german, languageName: AppText.german, languageCode: 'de'),
    LanguageModel(image: AppImages.greek, languageName: AppText.greek, languageCode: 'el'),
    LanguageModel(image: AppImages.hebrew, languageName: AppText.hebrew, languageCode: 'he'),
    LanguageModel(image: AppImages.hindi, languageName: AppText.hindi, languageCode: 'hi'),
    LanguageModel(image: AppImages.hungarian, languageName: AppText.hungarian, languageCode: 'hu'),
    LanguageModel(image: AppImages.indonesian, languageName: AppText.indonesian, languageCode: 'id'),
    LanguageModel(image: AppImages.italian, languageName: AppText.italian, languageCode: 'it'),
    LanguageModel(image: AppImages.japanese, languageName: AppText.japanese, languageCode: 'ja'),
    LanguageModel(image: AppImages.korean, languageName: AppText.korean, languageCode: 'ko'),
    LanguageModel(image: AppImages.malay, languageName: AppText.malay, languageCode: 'ms'),
    LanguageModel(image: AppImages.norwegian, languageName: AppText.norwegian, languageCode: 'no'),
    LanguageModel(image: AppImages.polish, languageName: AppText.polish, languageCode: 'pl'),
    LanguageModel(image: AppImages.portuguese, languageName: AppText.portuguese, languageCode: 'pt'),
    LanguageModel(image: AppImages.romanian, languageName: AppText.romanian, languageCode: 'ro'),
    LanguageModel(image: AppImages.russian, languageName: AppText.russian, languageCode: 'ru'),
    LanguageModel(image: AppImages.slovak, languageName: AppText.slovak, languageCode: 'sk'),
    LanguageModel(image: AppImages.spanish, languageName: AppText.spanish, languageCode: 'es'),
    LanguageModel(image: AppImages.swedish, languageName: AppText.swedish, languageCode: 'sv'),
    LanguageModel(image: AppImages.thai, languageName: AppText.thai, languageCode: 'th'),
    LanguageModel(image: AppImages.turkish, languageName: AppText.turkish, languageCode: 'tr'),
    LanguageModel(image: AppImages.ukrainian, languageName: AppText.ukrainian, languageCode: 'uk'),
    LanguageModel(image: AppImages.vietnamese, languageName: AppText.vietnamese, languageCode: 'vi'),
  ];

  List<LanguageModel> get filteredLanguages {
    if (searchQuery.isEmpty) {
      return languageItems;
    }

    final filteredList = languageItems.where((language) {
      return language.languageName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return filteredList.isNotEmpty ? filteredList : [];
  }
}
