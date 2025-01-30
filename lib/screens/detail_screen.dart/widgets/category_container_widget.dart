import 'package:flutter/material.dart';

import '../../../utils/appfonts.dart';
import '../../../utils/dimensions.dart';

class CategoryContainerWidget extends StatelessWidget {
  final String imageUrl;
  final String iconUrl;
  final String categoryName;
  final VoidCallback onTap;

  const CategoryContainerWidget({
    super.key,
    required this.imageUrl,
    required this.iconUrl,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: screenHeight * 0.195,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Apply radius here
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconUrl,
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      categoryName,
                      style: poppinsRegular.copyWith(
                        fontSize: screenWidth < 800 ? Dimensions.fontSizeLarge : Dimensions.fontSizeOverLarge,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            )));
  }
}
