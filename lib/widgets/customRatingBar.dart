import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantas_ai_plant_identifier/provider/homeplant_provider.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:plantas_ai_plant_identifier/widgets/rating_bar.dart';
import 'package:provider/provider.dart';
import '../provider/nav_Provider.dart';
import '../utils/app_localized_text.dart';
import '../utils/appfonts.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/images.dart';
import 'custom_Button.dart';

class CustomRatingBar {
  static Future<bool?> showExitConfirmationDialog(
    BuildContext context,
    double screenWidth,
    AnimationController animationController,
  ) {
    animationController.reset();
    animationController.forward();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        var navProvider = Provider.of<NavController>(context, listen: false);
        var plantProvider = Provider.of<PlantProvider>(context, listen: false);
        return AlertDialog(
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 200,
            height: 280,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(28),
                      topLeft: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        translate(context).alertTextOne,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge + 2,
                          color: Colors.white,
                        ),
                      ).paddingSymmetric(horizontal: 10),
                      const SizedBox(height: 5),
                      Text(
                        translate(context).alertTextTwo,
                        overflow: TextOverflow.ellipsis,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall + 2,
                          color: Colors.white,
                        ),
                      ).paddingSymmetric(horizontal: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: _buildRatingBar(animationController, plantProvider),
                ).paddingSymmetric(horizontal: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          translate(context).alertTextThree,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Directionality.of(context) == TextDirection.rtl ? Matrix4
                            .rotationY(3.14) : Matrix4.identity(), child: Image.asset(AppImages.popImage, height: 30, width: 30) ,),
                    ],
                  ).paddingSymmetric(horizontal: 35),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        text: navProvider.comeFromHome! ? translate(context).alertButtonOne : translate(context).alertButtonSetting,
                        onPressed: () {
                          navProvider.comeFromHome! ? SystemNavigator.pop() : Navigator.pop(context, false);
                          // Navigator.pop(context, false);
                        },
                        // onPressed: onBackPressed,
                        height: 45,
                        backgroundColor: Colors.white,
                        borderRadius: 12,
                        textColor: AppColors.primaryColor,
                        textSize: Dimensions.fontSizeDefault,
                        textWeight: FontWeight.w600,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomElevatedButton(
                        text: translate(context).alertButtonTwo,
                        onPressed: () async {
                          if (plantProvider.isInAppReviewDialogVisible) {
                            await plantProvider.rateApp();
                            plantProvider.updateInAppReviewDialogStatus(false);
                          } else {
                            plantProvider.openAppInPlayStore();
                          }
                          Navigator.pop(context, true);
                        },
                        // onPressed: onRatePressed,
                        height: 45,
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: 12,
                        textColor: Colors.white,
                        textSize: Dimensions.fontSizeDefault,
                        textWeight: FontWeight.w600,
                        borderColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildRatingBar(AnimationController controller, PlantProvider plantProvider) {
    return Center(
        child: RatingBar.builder(
      glowRadius: 1.0,
      glow: false,
      initialRating: plantProvider.rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: 50,
      itemBuilder: (context, index) => index == 4
          ? RotationTransition(
              turns: controller,
              child: const Icon(
                Icons.star,
                color: AppColors.primaryColor,
              ),
            )
          : const Icon(
              Icons.star,
              color: AppColors.primaryColor,
            ),
      onRatingUpdate: (rating) {
        plantProvider.updateRating(rating);
      },
    ));
  }
}
