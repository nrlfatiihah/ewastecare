import 'package:ewastecare/utils/constants/texts.dart';
import 'package:get/get.dart';

class WasteValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName ${WasteTexts.isRequired.tr}";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.emailRequired.tr;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return WasteTexts.invalidEmail.tr;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.passwordRequired.tr;
    }

    //Check for minimum password length
    if (value.length < 6) {
      return WasteTexts.passwordMinLength.tr;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return WasteTexts.passwordUppercase.tr;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return WasteTexts.passwordNumber.tr;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return WasteTexts.passwordSpecialChar.tr;
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.phoneRequired.tr;
    }

    final phoneRegExp = RegExp(r'^\d{10,}$');

    if (!phoneRegExp.hasMatch(value)) {
      return WasteTexts.invalidPhoneFormat.tr;
    }

    return null;
  }

  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.valueRequired.tr;
    }

    final intRegExp = RegExp(r'^[0-9]+$');

    if (!intRegExp.hasMatch(value)) {
      return WasteTexts.invalidIntegerFormat.tr;
    }

    return null;
  }

  static String? validateStringAlphabetic(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName ${WasteTexts.isRequired.tr}";
    }

    final nameRegExp = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegExp.hasMatch(value)) {
      return "$fieldName ${WasteTexts.onlyAlphabetic.tr}";
    }

    return null;
  }

  static String? validateAddress(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName ${WasteTexts.isRequired.tr}";
    }

    final alphanumericSpecialCharRegExp = RegExp(
      r'^[a-zA-Z0-9!@#$%^&*(),.?"/:{}|<> -]+$',
    );

    if (!alphanumericSpecialCharRegExp.hasMatch(value)) {
      return "$fieldName ${WasteTexts.alphanumericSpecialChars.tr}";
    }

    return null;
  }

  static String? validateAlphanumeric(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName ${WasteTexts.isRequired.tr}";
    }

    final alphanumericRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!alphanumericRegExp.hasMatch(value)) {
      return "$fieldName ${WasteTexts.onlyAlphanumeric.tr}";
    }

    return null;
  }

  static String? validateAge(String? fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.ageRequired.tr;
    }

    final ageRegExp = RegExp(r'^[0-9]+$');

    if (!ageRegExp.hasMatch(value)) {
      return WasteTexts.ageMustBeNumeric.tr;
    }

    int age = int.parse(value);

    if (age < 7 || age > 100) {
      return WasteTexts.ageRangeError.tr;
    }

    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.dateOfBirthRequired.tr;
    }
    return null;
  }

  static String? validateDecimalPlaces(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    // Regular expression to match values with exactly two decimal places
    RegExp regex = RegExp(r'^\d+\.\d{2}$');
    if (!regex.hasMatch(value)) {
      return '$fieldName ${WasteTexts.invalidDecimalFormat.tr}';
    }
    return null;
  }

  static String? validateGender(String fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.genderRequired.tr;
    }
    // Additional validation logic can be added if needed
    return null;
  }

  static String? validateDropdown(String fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return WasteTexts.materialTypeRequired.tr;
    }
    // Additional validation logic can be added if needed
    return null;
  }

  static String? validateDoubleWithTwoDecimalPlaces(
    String? fieldname,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return null; // Allow null or empty values
    }

    // Try to parse the value as a double
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return WasteTexts.validNumberRequired.tr; // Not a valid number
    }

    if (doubleValue < 0) {
      return WasteTexts.noNegativeNumber.tr; // Negative number detected
    }

    // Check if the number has more than 2 decimal places
    final formattedValue = doubleValue.toStringAsFixed(2);
    if (value != formattedValue) {
      return '$fieldname ${WasteTexts.twoDecimalPlacesMax.tr}'; // Not in the correct format
    }

    return null; // Valid value
  }
}
