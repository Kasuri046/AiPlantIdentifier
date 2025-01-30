// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/provider/homeplant_provider.dart';
import 'package:plantas_ai_plant_identifier/provider/language_provider.dart';
import 'package:provider/provider.dart';

import '../constants/network_info_service.dart';
import '../provider/onboarding_Provider.dart';
import '../screens/get_Started.dart';
import '../screens/home/home_screen.dart';
import '../utils/images.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      final adsProvider = Provider.of<Adsprovider>(context, listen: false);

      languageProvider.loadSelectedLanguage();
      await plantProvider.initializeRatedPref();
      await plantProvider.initializeInAppReviewDialog();

      await AdHelper.initAds();

      bool isInternetAccess = await NetworkInfoService.isNetworkAvailable();
      await onboardingProvider.loadGetStartedState();
      if (mounted) {
        if (isInternetAccess) {
          adsProvider.showAppOpenAd(context);

          Future.delayed(const Duration(seconds: 12)).then((value) {
            if (adsProvider.appOpenAd == null && !adsProvider.naviagted) {
              if (onboardingProvider.isFirstGetStarted) {
                Navigator.pushReplacementNamed(context, GetStarted.routeName);
              } else {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              }
            }
          });
        } else {
          Future.delayed(const Duration(seconds: 4), () {
            if (onboardingProvider.isFirstGetStarted) {
              Navigator.pushReplacementNamed(context, GetStarted.routeName);
            } else {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.splashImage), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              AppImages.splIcon,
              height: 195,
            ))
          ],
        ),
      ),
    );
  }
}

class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }
}
