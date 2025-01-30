import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/utils/appfonts.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';
import 'package:provider/provider.dart';
import '../provider/adsProvider.dart';
import '../provider/homeplant_provider.dart';
import '../screens/home/home_screen.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text; // Required text for the button
  final VoidCallback onPressed; // Required callback for button action
  final double height; // Height of the button
  final double? width; // Width of the button (optional)
  final Color backgroundColor; // Background color of the button
  final Color? borderColor; // Optional border color of the button
  final double borderRadius; // Border radius of the button
  final Color textColor; // Text color of the button
  final double textSize; // Text size
  final FontWeight textWeight; // Text weight

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.height,
    this.width, // Make width optional
    required this.backgroundColor,
    this.borderColor, // Make borderColor optional
    required this.borderRadius,
    required this.textColor,
    required this.textSize, // Add text size parameter
    required this.textWeight, // Add text weight parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity, // Use provided width or default to infinity
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null
            ? Border.all(color: borderColor!) // Use borderColor safely
            : null, // No border if borderColor is null
        borderRadius: BorderRadius.circular(borderRadius), // Border radius
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Set to transparent to show the container background
          elevation: 0, // Remove elevation
          splashFactory: NoSplash.splashFactory, // Disable splash effect
          shadowColor: Colors.transparent, // Remove any shadow color
          overlayColor: Colors.transparent, // Remove any highlight effect
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: poppinsRegular.copyWith(
            color: textColor, // Text color
            fontSize: textSize, // Set text size
            fontWeight: textWeight, // Set text weight
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class BackButtons extends StatelessWidget {
  const BackButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          Provider.of<Adsprovider>(context, listen: false).showHomeInterstitialAd();
          await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          Provider.of<PlantProvider>(context).updateProgressState(false);
        },
        child: Container(
          height: 40,
          width: 40,
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
        ));
  }
}
