import 'dart:developer';
import 'package:flutter/material.dart';
import '../screens/home/widgets/home_page.dart';
import '../screens/home/widgets/setting_page.dart';

class NavController with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool? _comeFromHome = true;
  bool? get comeFromHome => _comeFromHome;

  final List<Widget> pages = [
    const HomePage(),
    const SettingPage(),
  ];

  Widget get currentPage => pages[_currentIndex];

  void onTap(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  updateReview(bool value) {
    _comeFromHome = value;
    log(comeFromHome.toString());
    notifyListeners();
  }
}