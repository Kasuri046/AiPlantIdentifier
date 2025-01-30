import 'package:plantas_ai_plant_identifier/utils/app_text.dart';
import 'package:plantas_ai_plant_identifier/utils/images.dart';

class PlantType {
  final String text;
  final String image;
  String icon;

  PlantType({
    required this.text,
    required this.image,
    required this.icon,
  });
}

List<PlantType> plantTypes = [
  PlantType(text: AppText.plantTypeOne, image: AppImages.flowerImage, icon: AppImages.flowerIcon),
  PlantType(text: AppText.plantTypeTwo, image: AppImages.leafImage, icon: AppImages.leafIcon),
  PlantType(text: AppText.plantTypeThree, image: AppImages.fruitImage, icon: AppImages.fruitIcon,),
  PlantType(text: AppText.plantTypeFour, image: AppImages.barkImage, icon: AppImages.barkIcon,),
  PlantType(text: AppText.plantTypeFive, image: AppImages.habitImage, icon: AppImages.habitIcon,),
  PlantType(text: AppText.plantTypeSix, image: AppImages.otherImage, icon: AppImages.otherIcon,),
];