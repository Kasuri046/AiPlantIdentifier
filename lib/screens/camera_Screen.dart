import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/screens/identify_Screen.dart';
import 'package:plantas_ai_plant_identifier/utils/appfonts.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';
import '../provider/homeplant_provider.dart';
import '../utils/app_localized_text.dart';
import '../utils/colors.dart';
import '../widgets/custom_Button.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/cameraScreen';
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      await plantProvider.checkCameraPermission();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<Adsprovider>(context, listen: false).showHomeInterstitialAd();
        return true;
      },
      child: Scaffold(body: Consumer2<PlantProvider, Adsprovider>(builder: (context, plantProvider, adsprovider, child) {
        if (plantProvider.cameraPermissionGranted) {
          if (plantProvider.cameraController == null || !plantProvider.cameraController!.value.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }
        }

        return Stack(
          children: [
            SizedBox(
              height: screenHeight,
              child: plantProvider.cameraPermissionGranted
                  ? CameraPreview(plantProvider.cameraController!)
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              translate(context).noCameraTextOne,
                              style:
                                  poppinsSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeOverLarge, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              translate(context).noCameraTextTwo,
                              textAlign: TextAlign.center,
                              style: poppinsSemiBold.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeLarge),
                            ).paddingSymmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomElevatedButton(
                                text: translate(context).noCameraButton,
                                onPressed: () async {
                                  await plantProvider.checkCameraPermission();
                                },
                                height: 50,
                                width: 100,
                                backgroundColor: AppColors.primaryColor,
                                borderRadius: 12,
                                textColor: Colors.white,
                                textSize: Dimensions.fontSizeLarge,
                                textWeight: FontWeight.w400),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtons(),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),
            // Navigation Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.photo_library,
                      label: translate(context).cameraLabelOne,
                      onTap: () async {
                        adsprovider.precacheHomeInterstitialAd();
                        await plantProvider.pickImage(context).then((onValue) async {
                          if (plantProvider.image != null) {
                            adsprovider.showHomeInterstitialAd();
                            await Navigator.pushNamed(context, IdentifyScreen.routeName);
                          } else {
                            adsprovider.showHomeInterstitialAd();
                          }
                        });
                      },
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.rotate_right,
                      label: translate(context).cameraLabelTwo,
                      onTap: () {
                        plantProvider.toggleCamera();
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 40),
              ),
            ),
            // Floating Action Button
            Positioned(
              bottom: 40,
              left: MediaQuery.of(context).size.width / 2 - 35,
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  splashColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                  onPressed: () {
                    plantProvider.captureImage(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 6,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        );
      })),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final color = onTap != null ? Colors.white : Colors.white.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap == null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
