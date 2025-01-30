import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/screens/language_screen/language_screen.dart';
import 'package:plantas_ai_plant_identifier/utils/app_text.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:plantas_ai_plant_identifier/utils/images.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../../model/setting_Model.dart';
import '../../../provider/homeplant_provider.dart';
import '../../../utils/app_localized_text.dart';
import '../../../utils/appfonts.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/customRatingBar.dart';

class SettingPage extends StatefulWidget {
  static const routeName = '/SettingPage';

  const SettingPage({super.key});
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<SettingOption> options = [
    SettingOption(
      title: AppText.shareAppText,
      image: AppImages.shareIcon,
    ),
    SettingOption(
      title: AppText.rateUsText,
      image: AppImages.rateUs,
    ),
    SettingOption(
      title: AppText.privacyPolicyText,
      image: AppImages.privacyPolicy,
    ),
    SettingOption(
      title: AppText.contactText,
      image: AppImages.contactUs,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> settingOptions = {
      "Share App": translate(context).shareAppText,
      "Rate Us": translate(context).rateUsText,
      "Privacy Policy": translate(context).privacyPolicyText,
      "Contact Us": translate(context).contactText,
    };

    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<PlantProvider>(builder: (context, plantProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(context).languageText,
            style: poppinsBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LanguageScreen.routeName);
            },
            child: Container(
              height: 60,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 0.8,
                ),
              ),
              child: ListTile(
                leading: Image.asset(
                  AppImages.setting,
                  height: 30,
                  width: 30,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  translate(context).appLanguage,
                  style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: AppColors.textColor,
                  ),
                ),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min, // Ensures minimal width for the trailing row
                  children: [
                    SizedBox(width: 8), // Space between text and icon
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColors.lightColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            translate(context).otherText,
            style: poppinsBold.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
              height: 250,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 0.8,
                ),
              ),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (options[index].title == AppText.rateUsText) {
                        CustomRatingBar.showExitConfirmationDialog(
                          context,
                          screenWidth,
                          _animationController,
                        );
                      } else if (options[index].title == AppText.contactText) {
                        plantProvider.sendEmail();
                      } else if (options[index].title == AppText.privacyPolicyText) {
                        plantProvider.openPrivacyPolicy();
                      } else {
                        // Navigator.pushNamed(context, options[index].route);
                      }
                    },
                    leading: Image.asset(
                      options[index].image,
                      height: 30,
                      width: 30,
                      color: AppColors.primaryColor,
                    ),
                    title: Text(
                      // options[index].title,
                      settingOptions[options[index].title]!,
                      style: poppinsSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.lightColor,
                      size: 18,
                    ),
                  );
                },
              ).paddingOnly(top: 10)),
        ],
      ).paddingOnly(left: 15, right: 15, top: 20);
    });
  }
}
