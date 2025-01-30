import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/utils/colors.dart';

class IconContainer extends StatelessWidget {
  final Widget child;
  final double size;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const IconContainer({
    super.key,
    required this.child,
    this.size = 60.0,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Center(child: child),
      ),
    );
  }
}
