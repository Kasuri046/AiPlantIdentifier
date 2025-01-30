import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/provider/language_provider.dart';
import 'package:plantas_ai_plant_identifier/provider/nav_Provider.dart';
import 'package:plantas_ai_plant_identifier/provider/onboarding_Provider.dart';
import 'package:plantas_ai_plant_identifier/provider/progress_Controller.dart';
import 'package:plantas_ai_plant_identifier/splashScreen/splash_Screen.dart';
import 'package:plantas_ai_plant_identifier/utils/route.dart';
import 'package:provider/provider.dart';

import 'provider/homeplant_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error fetching cameras: ${e.code}, ${e.description}');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(create: (context) => NavController()),
        ChangeNotifierProvider(create: (context) => PlantProvider()),
        ChangeNotifierProvider(create: (context) => ProgressProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => Adsprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
        locale: languageProvider.locale,
        supportedLocales: languageProvider.languageItems.map((lang) {
          final code = lang.languageCode;
          return Locale(code.toString());
        }).toList(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
      );
    });
  }
}
