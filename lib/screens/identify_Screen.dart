import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantas_ai_plant_identifier/provider/progress_Controller.dart';
import 'package:plantas_ai_plant_identifier/screens/progress_Screen.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';
import '../model/homeplant_model.dart';
import '../provider/adsProvider.dart';
import '../provider/homeplant_provider.dart';
import '../utils/app_localized_text.dart';
import '../utils/appfonts.dart';
import '../utils/dimensions.dart';
import '../widgets/custom_Button.dart';
import 'home/home_screen.dart';

class IdentifyScreen extends StatefulWidget {
  static const routeName = '/identifyScreen';
  const IdentifyScreen({
    super.key,
  });

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  @override
  void initState() {
    final adsProvider = Provider.of<Adsprovider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await adsProvider.precacheInterstitialAd();
      progressProvider.resetAnimation();
    });
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<PlantProvider>(
          builder: (context, plantProvider, child) => Column(
            children: [
              _buildHeader(context, height, width, plantProvider),
              _buildContent(context, plantProvider, height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double height, double width, PlantProvider plantProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(plantProvider.image!.path))),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
          bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
        ),
      ),
      height: height * 0.4,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                      plantProvider.updateProgressState(false);
                    },
                    child: plantProvider.iscontained == false
                        ? Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Directionality.of(context) == TextDirection.rtl
                                  ? Matrix4.rotationY(3.14159) // Flip the icon horizontally for RTL
                                  : Matrix4.identity(),
                              child: const Icon(
                                CupertinoIcons.arrow_uturn_left,
                                color: Colors.white,
                              ),
                            ),
                          ).paddingOnly(top: 3, bottom: 3)
                        : const SizedBox(
                            height: 47,
                            width: 47,
                          )),
                const Spacer(),
                Text(
                  translate(context).appBarText,
                  style: poppinsBlack.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  height: 47,
                  width: 47,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PlantProvider plantProvider, double height, double width) {
    return Expanded(
      child: plantProvider.iscontained == false
          ? Column(
              children: [
                _buildChooseTypeHeader(width),
                _buildPlantTypeGrid(context, plantProvider, width),
                _buildSearchButton(context, plantProvider, width),
              ],
            )
          : const ProgressScreen(),
    );
  }

  Widget _buildChooseTypeHeader(double width) {
    return Text(
      translate(context).identifyMainText,
      style: philosopherBold.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: width < 800 ? Dimensions.fontSizeOverLarge + 4 : Dimensions.fontSizeOverLarge + 10,
      ),
    ).paddingOnly(top: Dimensions.PADDING_SIZE_EXTRA_LARGE, bottom: Dimensions.PADDING_SIZE_DEFAULT);
  }

  Widget _buildPlantTypeGrid(BuildContext context, PlantProvider plantProvider, double width) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 14,
            childAspectRatio: 0.97,
          ),
          itemCount: plantTypes.length,
          itemBuilder: (context, index) {
            final plantType = plantTypes[index];
            return GestureDetector(
              onTap: () => plantProvider.selectPlant(index, plantType.text.toString().toLowerCase()),
              child: _buildPlantTypeCard(plantType, plantProvider, index, width),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlantTypeCard(PlantType plantType, PlantProvider plantProvider, int index, double width) {
    Map<String, String> plantTypes = {
      "Flower": translate(context).plantTypeOne,
      "Leaf": translate(context).plantTypeTwo,
      "Bark": translate(context).plantTypeThree,
      "Fruit": translate(context).plantTypeFour,
      "Habit": translate(context).plantTypeFive,
      "Other": translate(context).plantTypeSix,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Apply radius here
            border: Border.all(
              width: 2,
              color: plantProvider.selectedIndex == index ? AppColors.primaryColor : Colors.transparent,
            ),
            image: DecorationImage(
              image: AssetImage(plantType.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              plantType.icon,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 5),
            Container(
              width: 70,
              child: Text(
                // getLocalizedText(context, plantType.text),
                plantTypes[plantType.text]!,
                overflow: TextOverflow.ellipsis,
                style: poppinsMedium.copyWith(
                  color: plantProvider.selectedIndex == index ? AppColors.primaryColor : Colors.black,
                  fontSize: width < 800 ? Dimensions.fontSizeLarge : Dimensions.fontSizeOverLarge,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context, PlantProvider plantProvider, double width) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: CustomElevatedButton(
          text: translate(context).identifyButton,
          onPressed: () {
            plantProvider.updateProgressState(true);
          },
          height: 60,
          width: 330,
          backgroundColor: const Color(0xff0D986A),
          borderRadius: 10,
          textColor: Colors.white,
          textSize: Dimensions.fontSizeDefault,
          textWeight: FontWeight.bold,
        ));
  }
}
