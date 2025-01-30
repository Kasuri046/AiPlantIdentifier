import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:plantas_ai_plant_identifier/model/homeplant_model.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/utils/Custom_iconContainer.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:plantas_ai_plant_identifier/utils/dimensions.dart';
import 'package:plantas_ai_plant_identifier/utils/images.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/plantas_detail_data_model.dart';
import '../../provider/homeplant_provider.dart';
import '../../utils/app_localized_text.dart';
import '../../utils/appfonts.dart';
import '../result_Screen.dart';
import 'widgets/category_container_widget.dart';
import 'widgets/category_images_list.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/DetailScreen';

  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final adsProvider = Provider.of<Adsprovider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      adsProvider.loadNativeAdDetailPage();
      Timer(const Duration(seconds: 10), () {
        if (mounted) {
          showCustomDialog(context, plantProvider);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          translate(context).appBarTitle,
          style: poppinsSemiBold.copyWith(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10, end: 0, bottom: 1, top: 5),
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Directionality.of(context) == TextDirection.rtl ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
                  child: const Icon(
                    CupertinoIcons.arrow_uturn_left,
                    color: Colors.white,
                  ),
                ),
              ).paddingOnly(top: 3, bottom: 3)),
        ),
      ),
      body: Consumer2<PlantProvider, Adsprovider>(builder: (context, plantProvider, adsProvider, child) {
        return plantProvider.isDetailLoading
            ? Center(
                child: Lottie.asset(
                  AppImages.plantScannerAnimation, // Replace with your file path
                  width: 200, // Adjust the size as needed
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : plantProvider.plantasDetailData == null
                ? Center(
                    child: Text(
                    translate(context).noDataFound,
                  ))
                : SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Image Section with Stack
                      Container(
                        height: height * 0.4,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          // image: DecorationImage(
                          //     image: NetworkImage(getImageUrl(plantProvider))),
                          color: AppColors.gray5,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
                            bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
                            bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_LARGE),
                          ),
                          child: CachedNetworkImageWidget(imageUrl: getImageUrl(plantProvider)),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            plantProvider.plantasDetailData?.commonNames?.isEmpty ?? true
                                ? "${plantProvider.plantasDetailData?.species?.name ?? ''} ${plantProvider.plantasDetailData?.species?.author ?? ''}"
                                : plantProvider.plantasDetailData!.commonNames!.first,
                            style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge + 2, color: Colors.black),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              text: plantProvider.plantasDetailData?.family?.name ?? '',
                              style: poppinsSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault, color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' > ',
                                    style: poppinsSemiBold.copyWith(
                                        color: Colors.black, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: plantProvider.plantasDetailData?.genus?.name ?? '',
                                    style: poppinsSemiBold.copyWith(
                                        color: AppColors.primaryColor, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: ' > ',
                                    style: poppinsSemiBold.copyWith(
                                        color: Colors.black, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: "${plantProvider.plantasDetailData?.species?.name ?? ''} ",
                                    style: poppinsSemiBold.copyWith(
                                        color: Colors.black, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: plantProvider.plantasDetailData?.species?.author ?? '',
                                    style: poppinsSemiBold.copyWith(
                                        color: Colors.black, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconContainer(
                                onTap: () async {
                                  final url = 'https://en.wikipedia.org/wiki/${plantProvider.plantasDetailData!.species!.name}';
                                  if (!await launchUrl(Uri.parse(url))) {
                                    throw Exception('Could not launch Wikipedia for $url');
                                  }
                                },
                                child: Image.asset(
                                  AppImages.WIcon,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              IconContainer(
                                onTap: () async {
                                  final url = 'https://www.google.com/search?q=${plantProvider.plantasDetailData!.species!.name}';
                                  if (!await launchUrl(Uri.parse(url))) {
                                    throw Exception('Could not launch Wikipedia for $url');
                                  }
                                },
                                child: Image.asset(
                                  AppImages.searchIcon,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              IconContainer(
                                onTap: () async {
                                  await plantProvider.sharePlantDetailsOnWikipedia();
                                },
                                child: Image.asset(
                                  AppImages.ShareIcon,
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                translate(context).detailTextPhoto,
                                style: poppinsBlack.copyWith(fontSize: Dimensions.fontSizeOverLarge - 4, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                ' (${plantProvider.plantasDetailData!.imagesCount})',
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              text: '${plantProvider.plantasDetailData!.observationsCount} Observation',
                              style: poppinsSemiBold.copyWith(
                                  color: AppColors.primaryColor, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      adsProvider.detailPageNativeAd != null
                          ? Container(
                              width: double.infinity,
                              height: 105,
                              color: Colors.grey[200],
                              child: adsProvider.isDetailPageNativeAdLoaded
                                  ? AdWidget(key: const Key("DetailPage"), ad: adsProvider.detailPageNativeAd!)
                                  : Container(
                                      width: double.infinity,
                                      height: 105,
                                      color: Colors.grey[300],
                                    ),
                            ).paddingSymmetric(horizontal: Dimensions.PADDING_SIZE_SMALL)
                          : const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.87,
                          ),
                          itemCount: _getSortedImageCategoryContainers(
                            plantProvider,
                            context,
                            plantProvider.seletedplantType ?? 'auto',
                          ).length,
                          itemBuilder: (context, index) {
                            final container = _getSortedImageCategoryContainers(
                              plantProvider,
                              context,
                              plantProvider.seletedplantType ?? 'auto',
                            )[index];

                            return container;
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translate(context).detailTextCommon,
                              style: poppinsBlack.copyWith(fontSize: Dimensions.fontSizeOverLarge - 4, fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              children: [
                                Text(
                                  plantProvider.plantasDetailData!.commonNames!.isEmpty
                                      ? "${plantProvider.plantasDetailData!.species!.name} ${plantProvider.plantasDetailData!.species!.author}"
                                      : plantProvider.plantasDetailData!.commonNames!.first,
                                  style: poppinsSemiBold.copyWith(
                                      color: AppColors.primaryColor, fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w500),
                                  softWrap: true,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            Text(
                              translate(context).detailTextExternal,
                              style: poppinsBlack.copyWith(fontSize: Dimensions.fontSizeOverLarge - 4, fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: plantProvider.plantasDetailData!.links!
                                  .where((link) => !unwantedUrls.any((substring) => link.contains(substring)))
                                  .length,
                              itemBuilder: (context, index) {
                                String link = plantProvider.plantasDetailData!.links!
                                    .where((link) => !unwantedUrls.any((substring) => link.contains(substring)))
                                    .elementAt(index);
                                final uri = Uri.parse(link);
                                final domain = uri.host;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (!await launchUrl(Uri.parse(link))) {
                                          throw Exception('Could not launch Wikipedia for $link');
                                        }
                                      },
                                      child: Text(
                                        domain,
                                        style: poppinsSemiBold.copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: Dimensions.fontSizeDefault + 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ).paddingOnly(bottom: Dimensions.PADDING_SIZE_LARGE));
      }),
    );
  }

  List<Widget> _getSortedImageCategoryContainers(PlantProvider plantProvider, BuildContext context, String priorityType) {
    final List<Map<String, dynamic>> imageCategories = [
      {
        'type': 'leaf',
        'widget': plantProvider.plantasDetailData!.images!.leaf!.isNotEmpty
            ? CategoryContainerWidget(
                imageUrl: plantProvider.plantasDetailData!.images!.leaf!.first.m!,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Leaf',
                      'imagesList': plantProvider.plantasDetailData!.images!.leaf!,
                    },
                  );
                },
                iconUrl: plantTypes[1].icon,
                categoryName: translate(context).plantTypeTwo
                // plantTypes[1].text,
                )
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.leaf!.isEmpty,
      },
      {
        'type': 'flower',
        'widget': plantProvider.plantasDetailData!.images!.flower!.isNotEmpty
            ? CategoryContainerWidget(
                imageUrl: plantProvider.plantasDetailData!.images!.flower!.first.m!,
                iconUrl: plantTypes[0].icon,
                categoryName: translate(context).plantTypeOne,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Flower',
                      'imagesList': plantProvider.plantasDetailData!.images!.flower!,
                    },
                  );
                },
              )
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.flower!.isEmpty,
      },
      {
        'type': 'fruit',
        'widget': plantProvider.plantasDetailData!.images!.fruit!.isNotEmpty
            ? CategoryContainerWidget(
                iconUrl: plantTypes[2].icon,
                imageUrl: plantProvider.plantasDetailData!.images!.fruit!.first.m!,
                categoryName: translate(context).plantTypeThree,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Fruit',
                      'imagesList': plantProvider.plantasDetailData!.images!.fruit!,
                    },
                  );
                })
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.fruit!.isEmpty,
      },
      {
        'type': 'bark',
        'widget': plantProvider.plantasDetailData!.images!.bark!.isNotEmpty
            ? CategoryContainerWidget(
                imageUrl: plantProvider.plantasDetailData!.images!.bark!.first.m!,
                categoryName: translate(context).plantTypeFour,
                iconUrl: plantTypes[3].icon,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Bark',
                      'imagesList': plantProvider.plantasDetailData!.images!.bark!,
                    },
                  );
                },
              )
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.bark!.isEmpty,
      },
      {
        'type': 'habit',
        'widget': plantProvider.plantasDetailData!.images!.habit!.isNotEmpty
            ? CategoryContainerWidget(
                imageUrl: plantProvider.plantasDetailData!.images!.habit!.first.m!,
                categoryName: translate(context).plantTypeFive,
                iconUrl: plantTypes[4].icon,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Habit',
                      'imagesList': plantProvider.plantasDetailData!.images!.habit!,
                    },
                  );
                },
              )
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.habit!.isEmpty,
      },
      {
        'type': 'other',
        'widget': plantProvider.plantasDetailData!.images!.other!.isNotEmpty
            ? CategoryContainerWidget(
                imageUrl: plantProvider.plantasDetailData!.images!.other!.first.m!,
                categoryName: translate(context).plantTypeSix,
                iconUrl: plantTypes[5].icon,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    CategoryImagesListScreen.routeName,
                    arguments: {
                      'categoryName': 'Other',
                      'imagesList': plantProvider.plantasDetailData!.images!.other!,
                    },
                  );
                },
              )
            : null,
        'isEmpty': plantProvider.plantasDetailData!.images!.other!.isEmpty,
      },
    ];

    // Handle "auto" priorityType by setting a default type, e.g., 'leaf'
    if (priorityType == "auto") {
      priorityType = 'flower'; // Set default priority type here
    }

    // Sort the list so that the priorityType comes first
    imageCategories.sort((a, b) {
      if (a['type'] == priorityType) return -1;
      if (b['type'] == priorityType) return 1;
      return 0;
    });

    // Filter out the empty categories and return the sorted list of widgets
    final List<Widget> sortedWidgets =
        imageCategories.where((category) => !category['isEmpty']).map<Widget>((category) => category['widget'] as Widget).toList();

    // If sortedWidgets is empty, show the first available non-empty category widget
    if (sortedWidgets.isEmpty) {
      return imageCategories.where((category) => !category['isEmpty']).map<Widget>((category) => category['widget'] as Widget).toList();
    }

    return sortedWidgets;
  }

  final List<String> unwantedUrls = [
    "http://uses.plantnet-project.org/en/",
    "https://uses.plantnet-project.org/en/",
    "https://identify.plantnet.org/en/",
  ];
  // Dailog Box.

  void showCustomDialog(BuildContext context, PlantProvider plantProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green Upper Container
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                alignment: Alignment.center,
                child: Text(
                  translate(context).scanSuccessfull,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // White Lower Container
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          plantProvider.updateReviewDialogVisibility(false);
                          if (plantProvider.isInAppReviewDialogVisible) {
                            await plantProvider.rateApp();
                            plantProvider.updateInAppReviewDialogStatus(false);
                          } else {
                            plantProvider.openAppInPlayStore();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 100, // Fixed width
                          height: 100, // Fixed height
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(0, 180, 50, 1), // Green color
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.thumb_up,
                                size: 30,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 70,
                                child: Center(
                                  child: Text(
                                    translate(context).greatJob,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          width: 100, // Fixed width
                          height: 100, // Fixed height
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red, // Red color
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.thumb_down,
                                size: 30,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 70,
                                child: Center(
                                  child: Text(
                                    translate(context).ohNo,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  String getImageUrl(PlantProvider plantProvider) {
    if (plantProvider.plantasDetailData != null) {
      final images = plantProvider.plantasDetailData!.images;
      final selectedType = plantProvider.seletedplantType?.toLowerCase();

      final imageCategories = {
        'flower': images?.flower,
        'leaf': images?.leaf,
        'bark': images?.bark,
        'fruit': images?.fruit,
        'habit': images?.habit,
        'other': images?.other,
      };
      final defaultImage = PlantImage(o: '');

      final selectedImages = selectedType != null ? imageCategories[selectedType] : null;
      final urlFromSelectedType = selectedImages
          ?.firstWhere(
            (img) => img.o?.isNotEmpty ?? false,
            orElse: () => defaultImage,
          )
          .o;

      if (urlFromSelectedType != null && urlFromSelectedType.isNotEmpty) {
        return urlFromSelectedType;
      }

      for (var category in imageCategories.values) {
        final fallbackUrl = category
            ?.firstWhere(
              (img) => img.o?.isNotEmpty ?? false,
              orElse: () => defaultImage,
            )
            .o;

        if (fallbackUrl != null && fallbackUrl.isNotEmpty) {
          return fallbackUrl;
        }
      }
    }
    return '';
  }
}
