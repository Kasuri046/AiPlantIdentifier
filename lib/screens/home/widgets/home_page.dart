// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/screens/get_Started.dart';
import 'package:plantas_ai_plant_identifier/screens/identify_Screen.dart';
import 'package:plantas_ai_plant_identifier/screens/on_Boarding.dart';
import 'package:plantas_ai_plant_identifier/utils/appfonts.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/utils/images.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../../provider/homeplant_provider.dart';
import '../../../provider/progress_Controller.dart';
import '../../../utils/app_localized_text.dart';
import '../../../utils/colors.dart';
import '../../camera_Screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _getGreeting() {
    final hour = DateTime.now().hour;

    Map<String, String> greetings = {
      "Good Morning, Plant Lover!": translate(context).morningText,
      "Good Afternoon, Plant Lover!": translate(context).afternoonText,
      "Good Evening, Plant Lover!": translate(context).eveningText,
    };

    if (hour < 12) {
      return greetings["Good Morning, Plant Lover!"] ?? "Good Morning, Plant Lover!";
    } else if (hour < 17) {
      return greetings["Good Afternoon, Plant Lover!"] ?? "Good Afternoon, Plant Lover!";
    } else {
      return greetings["Good Evening, Plant Lover!"] ?? "Good Evening, Plant Lover!";
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var tabSize = screenHeight > 1200;

    return Consumer2<PlantProvider, Adsprovider>(builder: (context, plantProvider, adsprovider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: tabSize ? screenHeight * 0.40 : screenHeight * 0.27,
                width: screenWidth * 0.8,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Directionality.of(context) == TextDirection.rtl
                      ? (Matrix4.identity()..rotateY(3.14159)) // Flip for RTL
                      : Matrix4.identity(), // No flip for LTR
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.homeImage),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: Directionality.of(context) == TextDirection.rtl
                            ? const EdgeInsetsDirectional.only(end: 10)
                            : const EdgeInsetsDirectional.only(start: 10),
                        child: Row(
                          mainAxisAlignment: Directionality.of(context) == TextDirection.rtl ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Transform(
                              alignment: Alignment.center,
                              transform: Directionality.of(context) == TextDirection.rtl
                                  ? (Matrix4.identity()..rotateY(3.14159)) // Flip text only for RTL
                                  : Matrix4.identity(),
                              child: Container(
                                width: 230,
                                child: Text(
                                  _getGreeting(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: poppinsBold.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Dimensions.fontSizeDefault + 2,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: tabSize ? 0 : 0,
                left: Directionality.of(context) == TextDirection.ltr ? (tabSize ? screenWidth * 0.60 : screenWidth * 0.53) : null,
                right: Directionality.of(context) == TextDirection.rtl ? (tabSize ? screenWidth * 0.60 : screenWidth * 0.53) : null,
                child: Image.asset(
                  AppImages.homeFlowerOne,
                  height: tabSize ? 320 : 180,
                  width: tabSize ? 320 : 180,
                ),
              )
            ],
          ),
          SizedBox(height: tabSize ? 20 : 25),
          Text(
            translate(context).tapIdentify,
            style: poppinsBold.copyWith(
              fontSize: tabSize ? Dimensions.fontSizeExtraLarge + 15 : Dimensions.fontSizeExtraLarge,
              color: AppColors.textColor,
            ),
          ),
          Text(
            translate(context).chooseGallery,
            style: poppinsMedium.copyWith(
              fontSize: tabSize ? Dimensions.fontSizeExtraLarge + 8 : Dimensions.fontSizeDefault,
            ),
          ),
          SizedBox(height: tabSize ? 30 : 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
                  adsprovider.precacheHomeInterstitialAd();
                  progressProvider.resetAnimation();
                  await Navigator.pushNamed(context, CameraScreen.routeName);
                },
                child: SizedBox(
                  height: 0.18 * screenHeight,
                  width: 0.42 * screenWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0.03 * screenHeight,
                        child: Container(
                          height: 0.15 * screenHeight,
                          width: 0.38 * screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: const DecorationImage(
                              image: AssetImage(AppImages.cameraImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 0.04 * screenWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.cameraIcon,
                                  height: 0.05 * screenHeight,
                                  width: 0.08 * screenWidth,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                Text(
                                  translate(context).cameraIdentify,
                                  style: philosopherBold.copyWith(
                                    fontSize: 0.02 * screenHeight,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  translate(context).recognizePlant,
                                  style: poppinsSemiBold.copyWith(
                                    fontSize: 0.014 * screenHeight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -0.015 * screenHeight,
                        left: Directionality.of(context) == TextDirection.ltr ? 0.22 * screenWidth : null,
                        right: Directionality.of(context) == TextDirection.rtl ? 0.22 * screenWidth : null,
                        child: Image.asset(
                          AppImages.homeFlowerTwo,
                          height: 0.13 * screenHeight,
                          width: 0.3 * screenWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  adsprovider.precacheHomeInterstitialAd();
                  plantProvider.pickImage(context).then((onValue) async {
                    if (plantProvider.image != null) {
                      adsprovider.showHomeInterstitialAd();
                      await Navigator.pushNamed(context, IdentifyScreen.routeName);
                    } else {
                      adsprovider.showHomeInterstitialAd();
                    }
                  });
                },
                child: SizedBox(
                  height: 0.18 * screenHeight,
                  width: 0.42 * screenWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0.03 * screenHeight,
                        child: Container(
                          height: 0.15 * screenHeight,
                          width: 0.38 * screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: const DecorationImage(
                              image: AssetImage(AppImages.galleryImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 0.04 * screenWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.galleryIcon,
                                  height: 0.05 * screenHeight,
                                  width: 0.08 * screenWidth,
                                ),
                                const SizedBox(
                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                ),
                                Text(
                                  translate(context).galleryIdentify,
                                  style: philosopherBold.copyWith(
                                    fontSize: 0.02 * screenHeight,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  translate(context).recognizePlant,
                                  style: poppinsSemiBold.copyWith(
                                    fontSize: 0.014 * screenHeight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -0.015 * screenHeight,
                        left: Directionality.of(context) == TextDirection.ltr ? 0.22 * screenWidth : null,
                        right: Directionality.of(context) == TextDirection.rtl ? 0.22 * screenWidth : null,
                        child: Image.asset(
                          AppImages.homeFlowerThree,
                          height: 0.13 * screenHeight,
                          width: 0.3 * screenWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          adsprovider.nativeAd != null
              ? Container(
                  width: double.infinity,
                  height: 105,
                  color: Colors.grey[100],
                  child: adsprovider.isNativeAdLoaded
                      ? AdWidget(key: UniqueKey(), ad: adsprovider.nativeAd!)
                      : Container(width: double.infinity, height: 105, color: Colors.yellow),
                )
              : Container(width: double.infinity, height: 105, color: Colors.yellow),
        ],
      ).paddingSymmetric(horizontal: 20);
    });
  }
}

class CustomClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomTrapezoidRoundedClipper extends CustomClipper<Path> {
  final double leftHeight;
  final double rightHeight;
  final double borderRadius;

  CustomTrapezoidRoundedClipper({
    required this.leftHeight,
    required this.rightHeight,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, leftHeight + borderRadius);
    path.lineTo(0, size.height - borderRadius);
    path.quadraticBezierTo(0, size.height, borderRadius, size.height);

    path.lineTo(size.width - borderRadius, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - borderRadius);

    path.lineTo(size.width, rightHeight + borderRadius);
    path.quadraticBezierTo(size.width, rightHeight, size.width - borderRadius, rightHeight);

    path.lineTo(borderRadius, leftHeight);
    path.quadraticBezierTo(0, leftHeight, 0, leftHeight + borderRadius);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
