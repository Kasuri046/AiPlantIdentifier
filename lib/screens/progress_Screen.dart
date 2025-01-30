import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/provider/homeplant_provider.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:plantas_ai_plant_identifier/widgets/custom_Button.dart';
import 'package:provider/provider.dart';
import '../loader_package/hexagon_dots.dart';
import '../provider/progress_Controller.dart';
import '../utils/app_localized_text.dart';
import '../utils/appfonts.dart';

class ProgressScreen extends StatefulWidget {
  static const routeName = '/identifyScreen';
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProgressProvider>(context, listen: false);
      if (!provider.isAnimating) {
        provider.startAnimation(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List<String> progressText = [
      translate(context).progressTextOne,
      translate(context).progressTextTwo,
      translate(context).progressTextThree,
      translate(context).progressTextFour,
    ];

    return WillPopScope(
      onWillPop: () async {
        if (context.read<PlantProvider>().iscontained!) {
          await _showExitDialog(context);
          return false; // Prevent the default back action (screen exit)
        } else {
          return true; // Allow exit if no animation is in progress
        }
      },
      child: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(translate(context).progressMainText,
                    style: poppinsBlack.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: width >= 800 ? 34 : 24,
                    )),
              ),
              SizedBox(height: height * .04),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width > 800 ? width * .35 : width * .2,
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(progressText.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 33,
                                width: 33,
                                decoration: BoxDecoration(
                                  color: progressProvider.containerColors[index] == AppColors.primaryColor
                                      ? progressProvider.containerColors[index]
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        progressProvider.containerColors[index] == AppColors.primaryColor ? AppColors.primaryColor : Colors.black26,
                                  ),
                                ),
                                // Handle when to show the "Done" icon or index number
                                child: progressProvider.showDoneIcons[index]
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: progressProvider.containerColors[index] == AppColors.primaryColor ? Colors.white : Colors.black54,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    progressText[index].replaceAll('.', ''),
                                    style: TextStyle(
                                      color:
                                          progressProvider.containerColors[index] == AppColors.primaryColor ? AppColors.primaryColor : Colors.black,
                                      fontSize: width >= 800 ? 20 : 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  index == progressProvider.currentIndex
                                      ? const HexagonDots(
                                          size: 20,
                                          color: AppColors.primaryColor,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          if (index != 3) ColorAnimationContainer(index: index).paddingOnly(right: 15),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _showExitDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer2<ProgressProvider, PlantProvider>(
        builder: (context, progressProvider, plantProvider, child) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              translate(context).sureExit,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      text: translate(context).no,
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      height: 45,
                      backgroundColor: Colors.white,
                      borderRadius: 12,
                      textColor: AppColors.primaryColor,
                      textSize: Dimensions.fontSizeDefault,
                      textWeight: FontWeight.w600,
                      borderColor: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: CustomElevatedButton(
                      text: translate(context).yes,
                      onPressed: () async {
                        progressProvider.resetAnimation();
                        plantProvider.updateProgressState(false);

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
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
              ).paddingSymmetric(horizontal: 10),
            ],
          );
        },
      );
    },
  );
}

class ColorAnimationContainer extends StatelessWidget {
  final int index;

  const ColorAnimationContainer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final containerHeight = height * .06;

    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Padding(
          padding: EdgeInsets.only(left: width > 800 ? width * .02 : width * .04),
          child: Container(
            height: containerHeight,
            width: 2,
            decoration: BoxDecoration(
              color: progressProvider.showDoneIcons[index] == true ? AppColors.primaryColor : const Color(0xffD9D9D9),
            ),
          ),
        );
      },
    );
  }
}
