// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/provider/homeplant_provider.dart';
import 'package:plantas_ai_plant_identifier/screens/result_Screen.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:provider/provider.dart';

import '../constants/network_info_service.dart';
import '../screens/noInternet/no_Internet.dart';

class ProgressProvider with ChangeNotifier {
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  List<Color> containerColors = [
    AppColors.primaryColor,
    const Color(0xffD9D9D9),
    const Color(0xffD9D9D9),
    const Color(0xffD9D9D9),
  ];

  List<bool> showDoneIcons = [
    false,
    false,
    false,
    false,
  ];

  // Start the animation process
  void startAnimation(BuildContext context) async {
    if (_isAnimating) return;

    _isAnimating = true;
    notifyListeners();

    try {
      await Provider.of<PlantProvider>(context, listen: false)
          .getPlantasMatchData(Provider.of<PlantProvider>(context, listen: false).seletedplantType);
    } catch (e) {
      log("Error fetching data: $e");
      _isAnimating = false;
      notifyListeners();
      return;
    }

    bool isInternetAccess = await NetworkInfoService.isNetworkAvailable();
    if (isInternetAccess) {
      _animateContainer(0, context);
    } else {
      Navigator.pushReplacementNamed(context, NoInternet.routeName);
    }
  }

  Future<void> _animateContainer(int index, BuildContext context) async {
    if (index >= containerColors.length) {
      _isAnimating = false;
      notifyListeners();
      return;
    }
    if (context.read<PlantProvider>().iscontained == true) {
      log("========if========${context.read<PlantProvider>().iscontained}");
      _currentIndex = index;
      notifyListeners();
      log("Animating index: $index");

      try {
        await Future.delayed(const Duration(seconds: 3));

        showDoneIcons[index] = true;
        notifyListeners();

        // Move to the next index if possible
        if (index + 1 < containerColors.length) {
          containerColors[index + 1] = AppColors.primaryColor;
          notifyListeners();

          // Call the function again for the next index
          _animateContainer(index + 1, context);
        } else {
          // After finishing the animation, handle the ad and navigate
          final adsProvider = Provider.of<Adsprovider>(context, listen: false);
          adsProvider.showInterstitialAd(onComplete: () {
            log("showInterstitialAd complete");
          });

          // Delay before navigating to the result screen
          await Future.delayed(const Duration(seconds: 1));
          _currentIndex = 0;
          notifyListeners();
          Provider.of<PlantProvider>(context, listen: false).updateProgressState(false);

          await Navigator.of(context).pushReplacementNamed(ResultScreen.routeName);
        }
      } catch (e) {
        log("Error during animation: $e");
        _isAnimating = false;
        notifyListeners();
      } finally {
        _isAnimating = false;
        notifyListeners();
      }
    } else {
      log("========else========${context.read<PlantProvider>().iscontained}");
      resetAnimation();
    }
  }

  // Reset animation state
  void resetAnimation() {
    _isAnimating = false;
    _currentIndex = 0;

    containerColors = [
      AppColors.primaryColor,
      const Color(0xffD9D9D9),
      const Color(0xffD9D9D9),
      const Color(0xffD9D9D9),
    ];
    showDoneIcons = [
      false,
      false,
      false,
      false,
    ];

    notifyListeners(); // **Comment By Abdul Wahab**: Notifies the UI to reset immediately
  }
}
