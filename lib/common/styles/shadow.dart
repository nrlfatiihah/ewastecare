import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class WasteShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: WasteColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadow = BoxShadow(
    color: WasteColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}
