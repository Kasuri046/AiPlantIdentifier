import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plantas_ai_plant_identifier/utils/appfonts.dart';
import 'package:plantas_ai_plant_identifier/widget_extension.dart';

import '../../../model/plantas_detail_data_model.dart';
import '../../../utils/app_localized_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class CategoryImagesListScreen extends StatefulWidget {
  static const routeName = '/categoryImagesListScreen';
  const CategoryImagesListScreen({super.key});

  @override
  State<CategoryImagesListScreen> createState() => _CategoryImagesListScreenState();
}

class _CategoryImagesListScreenState extends State<CategoryImagesListScreen> {
  late String categoryName;
  late List<PlantImage> imagesList;
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    categoryName = args['categoryName'];
    imagesList = args['imagesList'];
  }

  // String getTranslatedString(BuildContext context, String inputString) {
  //   Map<String, String> translationMap = {
  //     'Flower': AppLocalizations.of(context)!.flower,
  //     'Leaf': AppLocalizations.of(context)!.leaf,
  //     'Fruit': AppLocalizations.of(context)!.fruit,
  //     'Bark': AppLocalizations.of(context)!.bark,
  //     'Habit': AppLocalizations.of(context)!.habit,
  //     'Other': AppLocalizations.of(context)!.other,
  //   };

  //   return translationMap[inputString] ?? inputString;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ).paddingOnly(top: 3, bottom: 3),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: imagesList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    log("image path :: ${imagesList[index].o.toString()}");
                  },
                  child: CachedNetworkImage(
                    imageUrl: imagesList[index].o.toString(),
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
                              strokeWidth: 3,
                              color: AppColors.primaryColor,
                              value: percentage / 100,
                            ),
                            Text(
                              "${percentage.toStringAsFixed(0)}%",
                              style: const TextStyle(fontSize: Dimensions.PADDING_SIZE_SMALL, color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      );
                    },
                    // errorWidget: (context, url, error) => Image.asset(
                    //   AppImages.placeHolderSmallImage,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                );
              },
            ).paddingSymmetric(vertical: 10, horizontal: 10)
          ],
        ),
      ),
    );
  }
}
