

// class FireBRemoteConfig {
//   static final FirebaseRemoteConfig _config = FirebaseRemoteConfig.instance;

//   // Default Remote Config values for Android and Test modes
//   static const Map<String, dynamic> _defaultValuesAndroid = {
//     "All_Ads_Ids_Key_Plante_Android_Live": "",
//   };

//   static final Map<String, dynamic> _defaultValuesTest = {
//     "All_Ads_Ids_Key_Test_plante": "",
//   };

//   // Map to store ad IDs and their enabled status
//   static Map<String, Map<String, dynamic>> adIds = {};

//   // Initialize Firebase Remote Config
//   static Future<void> initConfig() async {
//     try {
//       // Set configuration settings for Remote Config
//       await _config.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 5),
//           minimumFetchInterval: const Duration(seconds: 5),
//         ),
//       );

//       // Set default values based on environment
//       final defaults = kDebugMode ? _defaultValuesTest : _defaultValuesAndroid;
//       await _config.setDefaults(defaults);

//       // Fetch and activate the Remote Config values
//       await _config.fetchAndActivate();

//       // Parse and log the ad IDs
//       await _parseAndLogAllIds();
//     } on PlatformException catch (exception) {
//       log('PlatformException: $exception');
//     } catch (exception) {
//       log('Exception: $exception');
//     }
//   }

//   // Parse the Remote Config ad IDs string and store them in the adIds map
//   static Future<void> _parseAndLogAllIds() async {
//     final allIdsString = kDebugMode
//         ? _config.getString('All_Ads_Ids_Key_Test_plante')
//         : Platform.isAndroid
//             ? _config.getString('All_Ads_Ids_Key_Plante_Android_Live')
//             : Platform.isIOS
//                 ? _config.getString('All_Ids_Key_Value_Ios')
//                 : "";

//     debugPrint("------allIdsString: $allIdsString-------");

//     // Parse the ad IDs string into the adIds map
//     adIds = {};
//     final allIdsList = allIdsString.split(RegExp(r',\s*')).where((s) => s.isNotEmpty).toList();

//     for (var i = 0; i < allIdsList.length; i += 3) {
//       if (i + 2 < allIdsList.length) {
//         final key = allIdsList[i].trim().replaceAll("'", '');
//         final value = allIdsList[i + 1].trim().replaceAll('"', '');
//         final isEnabled = allIdsList[i + 2].trim().toLowerCase() == 'true';

//         adIds[key] = {
//           'value': value,
//           'enabled': isEnabled,
//         };
//         debugPrint('Key: $key, Value: $value, Enabled: $isEnabled');
//       }
//     }

//     debugPrint('Ad IDs Map: $adIds');
//   }

//   // Generic getter for ad IDs based on a key
//   static String getAdId(String key) {
//     final ad = adIds[key];
//     return ad != null && ad['enabled'] ? ad['value'] : '';
//   }

//   // Specific ad getters for easier access
//   static String get openAppAdID => getAdId('plantas_appOpenAd');
//   static String get homeNativeAdID => getAdId('plante_home_screen_nativeAd');
//   static String get interstitialAd => getAdId('plantescan_image_interstitialAd');

//   static String get nativeAdPlantTypeScr => getAdId('PlantType_Screen_nativeAd');
//   static String get nativeAdSearchAd => getAdId('PlantSearch_Screen_nativeAd');
//   static String get collapsibleBannerAds => getAdId('plante_detail_collapsible_ad');
//   static String get nativeMediumAd => getAdId('plante_result_mediumNative_ad');
//   static String get homeInterstitialAd => getAdId('plantescan_home_interstitialAd');
// }
