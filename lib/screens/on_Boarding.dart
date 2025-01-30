import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';
import '../provider/onboarding_Provider.dart';
import '../utils/app_localized_text.dart';
import '../utils/appfonts.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../widgets/custom_Button.dart';
import 'home/home_screen.dart';

class OnBoarding extends StatefulWidget {
  static const routeName = '/onBoarding';

  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _pageController.addListener(() {
        Provider.of<OnboardingProvider>(context, listen: false).setPageIndex(_pageController.page!.toInt());
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> onBoardingData = {
      "Take Photo": translate(context).onBoardingOneMain,
      "Identify The PLant": translate(context).onBoardingOneDetail,
      "Get Plants": translate(context).onBoardingTwoMain,
      "Detail Information": translate(context).onBoardingTwoDetail,
      "Water, fertilize": translate(context).onBoardingThreeMain,
      "and prune on time": translate(context).onBoardingThreeDetail,
      "Skip": translate(context).onBoardingButtonOne,
      "Next": translate(context).onBoardingButtonTwo,
    };

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var extraSmall = screenHeight > 630;
    var medDevice = screenHeight > 850;
    var largeDevice = screenHeight > 780;
    var extraLargeDevice = screenHeight > 870;
    var tabSize = screenHeight > 1200;
    var largeTabSize = screenHeight > 1300;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<OnboardingProvider>(builder: (context, onboardingProvider, child) {
        return Column(
          children: [
            SizedBox(
              height: 530,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: largeTabSize
                        ? 700
                        : tabSize
                            ? 600
                            : extraLargeDevice
                                ? 450
                                : largeDevice
                                    ? 350
                                    : extraSmall
                                        ? 300
                                        : 0,
                    child: Image.asset(
                      AppImages.onBoardingBackGround,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    // top: 130,
                    top: largeTabSize
                        ? 250
                        : tabSize
                            ? 200
                            : extraLargeDevice
                                ? 100
                                : medDevice
                                    ? 110
                                    : extraSmall
                                        ? 80
                                        : 0,
                    child: SizedBox(
                      height: screenHeight * 0.50,
                      width: screenWidth,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        itemCount: onboardingProvider.onboardingItems.length,
                        itemBuilder: (_, index) {
                          final item = onboardingProvider.onboardingItems[index];
                          return SizedBox(
                            height: screenHeight * 0.25,
                            width: screenWidth,
                            child: Image.asset('assets/images/${item.image}'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  if (onboardingProvider.pageIndex > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                } else if (details.velocity.pixelsPerSecond.dx < 0) {
                  if (onboardingProvider.pageIndex < onboardingProvider.onboardingItems.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                }
              },
              child: Container(
                height: largeTabSize
                    ? 250
                    : tabSize
                        ? 250
                        : 180,
                width: largeTabSize
                    ? 700
                    : tabSize
                        ? 600
                        : 350,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      onBoardingData[onboardingProvider.onboardingItems[onboardingProvider.pageIndex].text1]!,
                      textAlign: TextAlign.center,
                      style: philosopherBold.copyWith(
                        color: AppColors.textColor,
                        fontSize: Dimensions.fontSizeOverLarge + 12,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      onBoardingData[onboardingProvider.onboardingItems[onboardingProvider.pageIndex].text2]!,
                      textAlign: TextAlign.center,
                      style: poppinsBlack.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: largeTabSize
                            ? Dimensions.fontSizeOverLarge + 16
                            : tabSize
                                ? Dimensions.fontSizeOverLarge + 6
                                : Dimensions.fontSizeExtraLarge + 2,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,

                      ),
                    ),
                    SizedBox(
                      height: largeTabSize
                          ? 20
                          : tabSize
                              ? 30
                              : extraLargeDevice
                                  ? 20
                                  : 20,
                    ),
                    SizedBox(
                      width: screenWidth > 600 ? screenWidth * 0.08 : screenWidth * 0.19,
                      height: screenWidth > 600 ? screenHeight * 0.02 : screenHeight * 0.01,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(onboardingProvider.onboardingItems.length, (indexDots) {
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            width: onboardingProvider.pageIndex == indexDots ? 8 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: onboardingProvider.pageIndex == indexDots ? AppColors.primaryColor : const Color.fromRGBO(217, 217, 217, 1),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: largeTabSize ? 40 : 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  text: translate(context).onBoardingButtonOne,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                  },
                  height: largeTabSize
                      ? 65
                      : tabSize
                          ? 65
                          : 55,
                  width: largeTabSize
                      ? 450
                      : tabSize
                          ? 350
                          : extraLargeDevice
                              ? 175
                              : medDevice
                                  ? 165
                                  : 150,
                  backgroundColor: Colors.white,
                  borderRadius: 12,
                  textColor: AppColors.primaryColor,
                  textSize: Dimensions.fontSizeExtraLarge,
                  textWeight: FontWeight.w600,
                  borderColor: AppColors.primaryColor,
                ),
                const SizedBox(width: 20),
                CustomElevatedButton(
                  text: translate(context).onBoardingButtonTwo,
                  onPressed: () {
                    _pageController.page == 2
                        ? Navigator.pushReplacementNamed(context, HomeScreen.routeName)
                        : _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                  },
                  height: largeTabSize
                      ? 65
                      : tabSize
                          ? 65
                          : 55,
                  width: largeTabSize
                      ? 450
                      : tabSize
                          ? 350
                          : extraLargeDevice
                              ? 175
                              : medDevice
                                  ? 165
                                  : 150,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 12,
                  textColor: Colors.white,
                  textSize: Dimensions.fontSizeExtraLarge,
                  textWeight: FontWeight.w600,
                )
              ],
            ).paddingSymmetric(horizontal: largeTabSize ? 50 : tabSize ? 35 : 20),
          ],
        );
      }),
    );
  }
}
