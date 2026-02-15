import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class WasteSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: WasteSizes.appBarHeight,
    left: WasteSizes.defaultSpace,
    bottom: WasteSizes.defaultSpace,
    right: WasteSizes.defaultSpace,
  );
}
