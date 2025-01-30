import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/provider/onboarding_Provider.dart';
import 'package:plantas_ai_plant_identifier/utils/appfonts.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:provider/provider.dart';

import '../utils/app_localized_text.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../widgets/custom_Button.dart';
import 'on_Boarding.dart';

class GetStarted extends StatefulWidget {
  static const routeName = '/getStarted';
  const GetStarted({super.key});
  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var tabSize = screenHeight > 1200;
    var largeTabSize = screenHeight > 1300;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<OnboardingProvider>(builder: (context, onboardingProvider, child) {
        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.50,
                    child: Image.asset(
                      AppImages.gtStarted,
                      fit: BoxFit.fill,
                    )),
                Positioned(
                  top: screenHeight * 0.18,
                  left: screenWidth * 0.21,
                  child: SizedBox(
                      height: tabSize ? screenHeight * 0.39 : screenHeight * 0.35,
                      width: screenWidth * 0.60,
                      child: Image.asset(
                        AppImages.gtStartedFlower,
                        fit: largeTabSize ? BoxFit.fill : BoxFit.cover,
                      )),
                )
              ],
            ),
            const Spacer(),
            Text(
              translate(context).getStartedWelcome,
              style: poppinsSemiBold.copyWith(
                color: AppColors.primaryColor,
                fontSize: tabSize ? Dimensions.fontSizeOverLarge + 16 : Dimensions.fontSizeOverLarge,
              ),
            ),
            Text(
              translate(context).getStartedFlora,
              style: philosopherBold.copyWith(
                  color: AppColors.textColor, fontSize: tabSize ? Dimensions.fontSizeOverLarge + 56 : Dimensions.fontSizeOverLarge + 26),
            ),
            Text(
              translate(context).getStartedDetail,
              textAlign: TextAlign.center,
              style: poppinsBlack.copyWith(
                  color: AppColors.textColor,
                  fontSize: tabSize ? Dimensions.fontSizeOverLarge + 1 : Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CustomElevatedButton(
              text: translate(context).getStartedButton,
              textColor: Colors.white,
              textSize: 18,
              textWeight: FontWeight.w600,
              onPressed: () async {
                await onboardingProvider.setGetStartedCompleted(false);
                await Navigator.pushReplacementNamed(context, OnBoarding.routeName);
              },
              height: tabSize ? 70 : 55,
              width: tabSize ? 700 : 330,
              backgroundColor: AppColors.primaryColor,
              borderRadius: 12,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              translate(context).getStartedTermCon,
              style:
                  poppinsRegular.copyWith(fontWeight: FontWeight.bold, fontSize: tabSize ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeSmall),
            ),
            RichText(
              text: TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Provider.of<HomeProvider>(context, listen: false).launchURL(
                    //     "https://sites.google.com/view/planteaiplantidentifier/privacy-policy");
                    // log("message");
                  },
                children: [
                  TextSpan(
                    text: translate(context).getStartedTerm,
                    style: poppinsRegular.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: tabSize ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeDefault,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ' & ',
                    style: TextStyle(
                      fontSize: tabSize ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: translate(context).getStartedPrivacy,
                    style: poppinsRegular.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: tabSize ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeDefault,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            )
          ],
        );
      }),
    );
  }
}
