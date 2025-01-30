import 'package:flutter/material.dart';
import 'package:plantas_ai_plant_identifier/loader_package/animation_controller_utils.dart';
import 'package:plantas_ai_plant_identifier/loader_package/draw_dot.dart';

class BuildDot extends StatelessWidget {
  final Color color;
  final double angle;
  final double size;
  final Interval interval;
  final AnimationController controller;
  final bool first;
  const BuildDot.first({
    super.key,
    required this.color,
    required this.angle,
    required this.size,
    required this.interval,
    required this.controller,
  }) : first = true;

  const BuildDot.second({
    super.key,
    required this.color,
    required this.angle,
    required this.size,
    required this.interval,
    required this.controller,
  }) : first = false;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Transform.translate(
        offset: Offset(0, -size / 2.4),
        child: UnconstrainedBox(
          child: DrawDot.circular(
              color: color,
              dotSize: controller.eval(
                Tween<double>(
                  begin: first ? 0.0 : size / 6,
                  end: first ? size / 6 : 0.0,
                ),
                curve: interval,
              )),
        ),
      ),
    );
  }
}
