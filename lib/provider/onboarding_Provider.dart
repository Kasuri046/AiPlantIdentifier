import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/utils/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/on_boarding_model.dart';
import '../utils/images.dart';

class OnboardingProvider extends ChangeNotifier {
  int _pageIndex = 0;
  bool _isFirstGetStarted = true;

  List<ImageListModel> get onboardingItems => onboardingList;

  int get pageIndex => _pageIndex;
  bool get isFirstGetStarted => _isFirstGetStarted;

  final List<ImageListModel> onboardingList = [
    ImageListModel(
      image: AppImages.onBoardingImageOne,
      text1: AppText.onBoardingOneMain,
      text2: AppText.onBoardingOneDetail,
    ),
    ImageListModel(
      image: AppImages.onBoardingImageTwo,
      text1: AppText.onBoardingTwoMain,
      text2: AppText.onBoardingTwoDetail,
    ),
    ImageListModel(
      image: AppImages.onBoardingImageThree,
      text1: AppText.onBoardingThreeMain,
      text2: AppText.onBoardingThreeDetail,
    ),
  ];

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  Future<void> loadGetStartedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirstGetStarted = prefs.getBool('isFirstGetStarted') ?? true;
    notifyListeners();
  }

  Future<void> setGetStartedCompleted(bool value) async {
    _isFirstGetStarted = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstGetStarted', value);
    notifyListeners();
  }

}
