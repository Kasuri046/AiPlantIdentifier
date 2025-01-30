import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantas_ai_plant_identifier/provider/adsProvider.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';
import 'package:plantas_ai_plant_identifier/widgets/custom_Button.dart';
import 'package:provider/provider.dart';
import '../provider/homeplant_provider.dart';
import '../utils/app_localized_text.dart';
import '../utils/appfonts.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'detail_screen.dart/detail_screen.dart';
import 'home/home_screen.dart';

class ResultScreen extends StatefulWidget {
  static const routeName = '/resultScreen';

  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    final adsProvider = Provider.of<Adsprovider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      adsProvider.loadNativeAdMedium();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = Provider.of<PlantProvider>(context, listen: false);
        provider.updateProgressState(false);
        await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            translate(context).appBarTextTwo,
            style: poppinsSemiBold.copyWith(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10, end: 0, bottom: 1, top: 5),
            child: GestureDetector(
                onTap: () async {
                  final provider = Provider.of<PlantProvider>(context, listen: false);
                  provider.updateProgressState(false);
                  await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
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
        backgroundColor: Colors.white,
        body: Consumer2<PlantProvider, Adsprovider>(builder: (context, plantProvider, adsProvider, child) {
          return plantProvider.plantasMatchModel == null
              ? Center(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate(context).noPlant,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.fontSizeExtraLarge),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          translate(context).checkAgain,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomElevatedButton(
                          text: translate(context).buttonText,
                          textColor: Colors.white,
                          textSize: 18,
                          textWeight: FontWeight.w600,
                          onPressed: () async {
                            final provider = Provider.of<PlantProvider>(context, listen: false);
                            provider.updateProgressState(false);
                            await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                          },
                          height: 55,
                          width: 330,
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 12,
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(plantProvider.plantasMatchModel!.results!.length, (index) {
                      final result = plantProvider.plantasMatchModel!.results![index];
                      return Column(
                        children: [
                          if (index == 1)
                            adsProvider.nativeAdmedium != null
                                ? Container(
                                    key: const Key("mediumAdPlant"),
                                    width: double.infinity,
                                    height: 350,
                                    color: Colors.black,
                                    child: adsProvider.isNativeAdLoadedmedium
                                        ? AdWidget(key: const Key("mediumAdPlant"), ad: adsProvider.nativeAdmedium!)
                                        : Container(
                                            width: double.infinity,
                                            height: 105,
                                            color: Colors.grey[300],
                                          ),
                                  )
                                : const SizedBox.shrink(),
                          GestureDetector(
                            onTap: () async {
                              plantProvider.fetchPlantasDetail(
                                  preferredReferential: plantProvider.plantasMatchModel!.preferedReferential,
                                  bestMatch: '${result.species.scientificNameWithoutAuthor} ${result.species.scientificNameAuthorship}');
                              await Navigator.pushNamed(context, DetailScreen.routeName);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 220,
                                          child: Text(
                                            // translate(context).identifyMainText,
                                            // result.species.commonNames.isNotEmpty ? translate(context).speciescommonNames(result.species.commonNames.first) : translate(context).speciesScientificName(result.species.scientificName),
                                            result.species.commonNames.isNotEmpty ? result.species.commonNames.first : result.species.scientificName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    backgroundColor: const Color.fromRGBO(79, 79, 79, 1),
                                                    value: result.score,
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 16,
                                                left: 17,
                                                child: Container(
                                                  width: 30,
                                                  child: Text(
                                                    translate(context).resultScreenMatch,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8, // Adjusted font size
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 26,
                                                child: Text(
                                                  '${(result.score * 100).toStringAsFixed(0)}%',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 20),
                                  ),
                                  if (index == 0)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                  child: CachedNetworkImageWidget(
                                                    imageUrl: result.images.first.url.o,
                                                  ),
                                                )),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                ),
                                                child: result.images.length > 1
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                                        child: CachedNetworkImageWidget(
                                                          imageUrl: result.images[1].url.o,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (index != 0)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: SizedBox(
                                      height: 90,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: result.images.length,
                                        itemBuilder: (context, index) {
                                          final imageUrl = result.images[index].url.o;
                                          return Container(
                                            height: 50,
                                            width: 90,
                                            margin: const EdgeInsets.only(right: 07),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              child: CachedNetworkImageWidget(imageUrl: imageUrl),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (result.species.commonNames.isNotEmpty)
                                              SizedBox(
                                                width: 170,
                                                child: Text(
                                                  result.species.scientificName,
                                                  maxLines: 2,
                                                  style: poppinsRegular.copyWith(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            result.species.commonNames.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 10),
                                            Text(
                                              result.species.family.scientificName,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            plantProvider.fetchPlantasDetail(
                                                preferredReferential: plantProvider.plantasMatchModel!.preferedReferential,
                                                bestMatch:
                                                    '${result.species.scientificNameWithoutAuthor} ${result.species.scientificNameAuthorship}');
                                            await Navigator.pushNamed(context, DetailScreen.routeName);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryColor,
                                            minimumSize: const Size(100, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Container(
                                            width: 80,
                                            child: Text(
                                              translate(context).resultScreenButton,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ).paddingSymmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                );
        }),
      ),
    );
  }
}

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          double percentage = 0.0;
          if (downloadProgress.progress != null) {
            percentage = downloadProgress.progress! * 100;
          }
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 3,
                  value: percentage / 100,
                ),
                Text(
                  "${percentage.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: Dimensions.PADDING_SIZE_SMALL,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          );
        },
        errorWidget: (context, url, error) => const Icon(Icons.error)
        // Image.asset(
        // ,
        //   fit: BoxFit.cover,
        // ),
        );
  }
}
