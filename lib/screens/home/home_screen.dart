import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../provider/adsProvider.dart';
import '../../provider/nav_Provider.dart';
import '../../utils/app_localized_text.dart';
import '../../utils/appfonts.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/customRatingBar.dart';
import '../camera_Screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    final adsProvider = Provider.of<Adsprovider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      adsProvider.loadNativeAd();
    });
  }

  @override
  void dispose() {
    log("---------------------dispose");
    final adsProvider = Provider.of<Adsprovider>(context, listen: false);
    adsProvider.resetNativeAd();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        _animationController.forward();
        final bool shouldPop = await CustomRatingBar.showExitConfirmationDialog(
              context,
              screenWidth,
              _animationController,
            ) ??
            false;
        if (shouldPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate(context).homeScreenMainText,
                style: philosopherBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge + 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<NavController>(builder: (context, navController, child) {
          return navController.currentPage;
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            splashColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            focusElevation: 0,
            onPressed: () => Navigator.pushReplacementNamed(context, CameraScreen.routeName),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
              side: const BorderSide(
                color: AppColors.primaryColor,
                width: 6,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: AppColors.primaryColor,
              size: 32,
            ),
          ),
        ),
        bottomNavigationBar: Consumer<NavController>(builder: (context, navController, child) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  icon: Icons.home_filled,
                  label: translate(context).navBarOne,
                  isSelected: navController.currentIndex == 0,
                  onTap: () {
                    navController.onTap(0);
                    navController.updateReview(true);
                  },
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: translate(context).navBarTwo,
                  isSelected: navController.currentIndex == 1,
                  onTap: () {
                    navController.onTap(1);
                    navController.updateReview(false);
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 40),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.5);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 25,
          ),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
