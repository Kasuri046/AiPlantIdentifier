import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../screens/get_Started.dart';
import '../screens/home/home_screen.dart';
import 'onboarding_Provider.dart';

class Adsprovider with ChangeNotifier {
// ------------- App Open Ad Section -------------
// *********** Handling AppOpenAd ***************
// *********** AppOpenAd Configuration **********
// *********** Access AppOpenAd Details **********
// ----------------------------------------------

  AppOpenAd? _appOpenAd;
  AppOpenAd? get appOpenAd => _appOpenAd;
  bool _isAppOpenAdLoaded = false;
  bool naviagted = false;

  bool get isAppOpenAdLoaded => _isAppOpenAdLoaded;

  Future<void> loadAppOpenAd(BuildContext context) async {
    // final appOpenAdId = FireBRemoteConfig.openAppAdID;
    // notifyListeners();
    // final isAdEnabled = FireBRemoteConfig.adIds['planteSplash_appOpenAd_id']?['enabled'] ?? true;
    // notifyListeners();

    // if (appOpenAdId.isEmpty || !isAdEnabled) {
    //   log('AppOpenAd is not enabled or ad unit ID is empty.');
    //   return; // Exit if ad is not enabled or ad unit ID is empty
    // }

    await AppOpenAd.load(
      adUnitId: "ca-app-pub-3940256099942544/9257395921",
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('AppOpenAd loaded.');
          _appOpenAd = ad;
          _isAppOpenAdLoaded = true;
          showAppOpenAd(context);
          notifyListeners();
        },
        onAdFailedToLoad: (error) {
          log('AppOpenAd failed to load: $error');
          _appOpenAd = null;
          _isAppOpenAdLoaded = false;
          notifyListeners();
        },
      ),
    );
  }

  Future<void> showAppOpenAd(BuildContext context) async {
    if (_appOpenAd == null) {
      await loadAppOpenAd(context);
      return;
    } else {
      _appOpenAd!.show();
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          log('AppOpenAd dismissed.');
          ad.dispose();
          _appOpenAd = null;
          naviagted = true;
          _isAppOpenAdLoaded = false;
          notifyListeners();

          // Handle navigation based on the showStartedOnBoarding flag
          if (Provider.of<OnboardingProvider>(context, listen: false).isFirstGetStarted) {
            Navigator.pushReplacementNamed(context, GetStarted.routeName);
          } else {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          log('AppOpenAd failed to show: $error');
          ad.dispose();
          _appOpenAd = null;
          _isAppOpenAdLoaded = false;
          notifyListeners();

          if (Provider.of<OnboardingProvider>(context, listen: false).isFirstGetStarted) {
            Navigator.pushReplacementNamed(context, GetStarted.routeName);
          } else {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        },
      );
    }
  }

// ------------- Native Home Ad Section -------------
// *********** Handling Native Home Ad **************
// *********** Native Home Ad Configuration *********
// *********** Access Native Home Ad Details ********
// --------------------------------------------------

  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  NativeAd? get nativeAd => _nativeAd;
  bool get isNativeAdLoaded => _isNativeAdLoaded;

  void loadNativeAd() {
    const nativeAdId = "ca-app-pub-3940256099942544/2247696110";
    const isAdEnabled = true;

    if (nativeAdId.isEmpty || !isAdEnabled) {
      log('Native Ad is not enabled or ad unit ID is empty.');
      return;
    }

    _nativeAd = NativeAd(
      adUnitId: nativeAdId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          _isNativeAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          resetNativeAd();
          log('$NativeAd failed to load: $error');
          notifyListeners();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    )..load();
  }

  void resetNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isNativeAdLoaded = false;
    notifyListeners();
  }

// ------------- InterstitialAd Ad Section -------------
// *********** Handling InterstitialAd Home Ad **************
// *********** InterstitialAd  Ad Configuration *********
// *********** Access InterstitialAd Ad Details ********
// --------------------------------------------------

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  InterstitialAd? get interstitialAd => _interstitialAd;
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;

  Future<void> loadInterstitialAd() async {
    // final interstitialAdId = FireBRemoteConfig.interstitialAd;
    // final isAdEnabled = FireBRemoteConfig.adIds['plantescan_image_interstitialAd']?['enabled'] ?? false;

    // if (interstitialAdId.isEmpty || !isAdEnabled) {
    //   log('Interstitial Ad is not enabled or ad unit ID is empty.');
    //   return; // Exit if ad is not enabled or ad unit ID is empty
    // }

    await InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('InterstitialAd loaded.');
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (err) {
          _resetInterstitialAd();
          log('InterstitialAd failed to load: ${err.message}');
          notifyListeners();
        },
      ),
    );
  }

  void showInterstitialAd({required VoidCallback onComplete}) {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _resetInterstitialAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _resetInterstitialAd();
          log('InterstitialAd failed to show: $error');
          onComplete();
        },
      );
      return;
    }

    // If the ad is not loaded, complete the action immediately
    onComplete();
  }

  void _resetInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
    notifyListeners();
  }

  Future<void> precacheInterstitialAd() async {
    await loadInterstitialAd();
  }

  // ------------- InterstitialAd Ad Section -------------
// *********** Handling InterstitialAd Home Ad **************
// *********** InterstitialAd Ad Configuration *********
// *********** Access InterstitialAd Ad Details *********
// --------------------------------------------------

  InterstitialAd? _interstitialAdHome;
  bool _isInterstitialAdLoadedHome = false;

  InterstitialAd? get interstitialAdHome => _interstitialAdHome;
  bool get isInterstitialAdLoadedHome => _isInterstitialAdLoadedHome;

  // Load the Interstitial Ad
  Future<void> loadHomeInterstitialAd() async {
    // final interstitialAdId = FireBRemoteConfig.interstitialAd;
    // final isAdEnabled = FireBRemoteConfig.adIds['plantescan_image_interstitialAd']?['enabled'] ?? false;

    // if (interstitialAdId.isEmpty || !isAdEnabled) {
    //   log('Interstitial Ad is not enabled or ad unit ID is empty.');
    //   return; // Exit if ad is not enabled or ad unit ID is empty
    // }

    await InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('Home InterstitialAd loaded.');
          _interstitialAdHome = ad;
          _isInterstitialAdLoadedHome = true;
          notifyListeners();
        },
        onAdFailedToLoad: (err) {
          _resetHomeInterstitialAd();
          log('Home InterstitialAd failed to load: ${err.message}');
          notifyListeners();
        },
      ),
    );
  }

  void showHomeInterstitialAd({VoidCallback? onComplete}) {
    if (_isInterstitialAdLoadedHome && _interstitialAdHome != null) {
      _interstitialAdHome?.show();
      _interstitialAdHome?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _resetHomeInterstitialAd();
          onComplete!();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _resetHomeInterstitialAd();
          log('Home InterstitialAd failed to show: $error');
          onComplete!();
        },
      );
      return;
    }
  }

  void _resetHomeInterstitialAd() {
    _interstitialAdHome?.dispose();
    _interstitialAdHome = null;
    _isInterstitialAdLoadedHome = false;
    notifyListeners();
  }

  Future<void> precacheHomeInterstitialAd() async {
    await loadHomeInterstitialAd();
  }

// ------------- Native Detail Ad Section -------------
// *********** Handling Native Detail Ad **************
// *********** Native Detail Ad Configuration *********
// *********** Access Native Detail Ad Details ********
// --------------------------------------------------

  NativeAd? _detailPageNativeAd;
  bool _isDetailPageNativeAdLoaded = false;

  NativeAd? get detailPageNativeAd => _detailPageNativeAd;
  bool get isDetailPageNativeAdLoaded => _isDetailPageNativeAdLoaded;

  /// Loads a native ad for the detail page if enabled in remote configuration.
  void loadNativeAdDetailPage() {
    // final nativeAdId = FireBRemoteConfig.nativeAdDetailPage;
    // final isAdEnabled = FireBRemoteConfig.adIds['HiPlant_PlantDetail_data_nativeAd']?['enabled'] ?? false;

    // if (nativeAdId.isEmpty || !isAdEnabled) {
    //   log('Detail Page Native Ad is not enabled or ad unit ID is empty.');
    //   return;
    // }

    _detailPageNativeAd = NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('Detail Page Native Ad loaded.');
          _isDetailPageNativeAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          _resetDetailPageNativeAd();
          log('Detail Page Native Ad failed to load: $error');
          notifyListeners();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    )..load();
  }

  /// Resets the detail page native ad when it fails to load or needs to be disposed.
  void _resetDetailPageNativeAd() {
    _detailPageNativeAd?.dispose();
    _detailPageNativeAd = null;
    _isDetailPageNativeAdLoaded = false;
    notifyListeners();
  }

// ------------- Native ResultScreen Ad Section -------------
// *********** Handling Native ResultScreen Ad **************
// *********** Native ResultScreen Ad Configuration *********
// *********** Access Native ResultScreen Ad ResultScreen ********
// --------------------------------------------------

  NativeAd? _nativeAdmedium;
  bool _isNativeAdLoadedmedium = false;

  NativeAd? get nativeAdmedium => _nativeAdmedium;
  bool get isNativeAdLoadedmedium => _isNativeAdLoadedmedium;

  void loadNativeAdMedium() {
    // final nativeAdMedium = FireBRemoteConfig.nativeAdMedium;
    // final isAdEnabled = FireBRemoteConfig.adIds['HiPlant_PlantResult_Medium_nativeAd']?['enabled'] ?? false;

    // if (nativeAdMedium.isEmpty || !isAdEnabled) {
    //   log('Native Ad Medium is not enabled or ad unit ID is empty.');
    //   return;
    // }

    _nativeAdmedium = NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          _isNativeAdLoadedmedium = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          _resetNativeAdMedium();
          log('$NativeAd failed to load: $error');
          notifyListeners();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    )..load();
  }

  void _resetNativeAdMedium() {
    _nativeAdmedium?.dispose();
    _nativeAdmedium = null;
    _isNativeAdLoadedmedium = false;
    notifyListeners();
  }
}
