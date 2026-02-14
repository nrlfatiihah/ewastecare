import 'package:ewastecare/theme/custom_themes/app_bar_theme.dart';
import 'package:ewastecare/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:ewastecare/theme/custom_themes/checkbox_theme.dart';
import 'package:ewastecare/theme/custom_themes/chip_theme.dart';
import 'package:ewastecare/theme/custom_themes/elevated_button_theme.dart';
import 'package:ewastecare/theme/custom_themes/outline_button_theme.dart';
import 'package:ewastecare/theme/custom_themes/text_field_theme.dart';
import 'package:ewastecare/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class WasteAppTheme {
  WasteAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: WasteTextTheme.lightTextTheme,
    chipTheme: WasteChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: WasteAppBarTheme.lightAppBarTheme,
    checkboxTheme: WasteCheckBoxTheme.lightCheckboxTheme,
    bottomSheetTheme: WasteBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: WasteElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: WasteOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: WasteTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: WasteTextTheme.darkTextTheme,
    chipTheme: WasteChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: WasteAppBarTheme.darkAppBarTheme,
    checkboxTheme: WasteCheckBoxTheme.darkCheckboxTheme,
    bottomSheetTheme: WasteBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: WasteElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: WasteOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: WasteTextFormFieldTheme.darkInputDecorationTheme,
  );
}
