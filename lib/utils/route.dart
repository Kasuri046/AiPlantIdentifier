import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/screens/camera_Screen.dart';
import 'package:plantas_ai_plant_identifier/screens/detail_screen.dart/detail_screen.dart';
import 'package:plantas_ai_plant_identifier/screens/identify_Screen.dart';

import '../screens/detail_screen.dart/widgets/category_images_list.dart';
import '../screens/get_Started.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/widgets/home_page.dart';
import '../screens/home/widgets/setting_page.dart';
import '../screens/language_screen/language_screen.dart';
import '../screens/noInternet/no_Internet.dart';
import '../screens/on_Boarding.dart';
import '../screens/result_Screen.dart';
import '../splashScreen/splash_Screen.dart';

class Routes {
  Routes._();
  String? imagePath;
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return _buildRoute(const SplashScreen(), settings);
      case GetStarted.routeName:
        return _buildRoute(const GetStarted(), settings);
      case OnBoarding.routeName:
        return _buildRoute(const OnBoarding(), settings);
      case HomePage.routeName:
        return _buildRoute(const HomePage(), settings);
      case HomeScreen.routeName:
        return _buildRoute(const HomeScreen(), settings);
      case IdentifyScreen.routeName:
        return _buildRoute(const IdentifyScreen(), settings);
      case CameraScreen.routeName:
        return _buildRoute(const CameraScreen(), settings);
      case SettingPage.routeName:
        return _buildRoute(const SettingPage(), settings);
      case ResultScreen.routeName:
        return _buildRoute(const ResultScreen(), settings);
      case DetailScreen.routeName:
        return _buildRoute(const DetailScreen(), settings);
      case LanguageScreen.routeName:
        return _buildRoute(const LanguageScreen(), settings);
      case NoInternet.routeName:
        return _buildRoute(const NoInternet(), settings);
      case CategoryImagesListScreen.routeName:
        return _buildRoute(const CategoryImagesListScreen(), settings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.1, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      settings: settings,
    );
  }
}
