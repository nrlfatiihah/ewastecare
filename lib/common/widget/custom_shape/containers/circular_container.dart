import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class WasteCircularContainer extends StatelessWidget {
  const WasteCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.backgroundColor = WasteColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1), // subtle background
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // subtle shadow
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: backgroundColor.withOpacity(0.2), // soft border
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
