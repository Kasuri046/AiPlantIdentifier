import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/splashScreen/splash_Screen.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:plantas_ai_plant_identifier/widgets/custom_Button.dart';

import '../../constants/network_info_service.dart';
import '../../utils/app_localized_text.dart';
import '../../utils/appfonts.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';

class NoInternet extends StatelessWidget {
  static const routeName = '/noInternet';
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate(context).noInternetTextOne,
                style: poppinsBlack.copyWith(
                    color: const Color.fromRGBO(79, 79, 79, 1), fontSize: Dimensions.fontSizeOverLarge + 20, fontWeight: FontWeight.bold),
              ),
              Text(
                translate(context).noInternetTextTwo,
                style: poppinsBlack.copyWith(color: AppColors.primaryColor, fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: 50),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                AppImages.noInternetImage,
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  text: translate(context).noInternetTextThree,
                  onPressed: () async {
                    bool isInternetAccess = await NetworkInfoService.isNetworkAvailable();
                    if (isInternetAccess) {
                      Navigator.pushReplacementNamed(context, SplashScreen.routeName);
                    }
                  },
                  height: 55,
                  width: screenWidth,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 12,
                  textColor: Colors.white,
                  textSize: Dimensions.fontSizeExtraLarge,
                  textWeight: FontWeight.w600)
            ],
          ).paddingSymmetric(horizontal: 20)),
    );
  }
}
