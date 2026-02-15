class WasteValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return "Invalid email address";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    //Check for minimum password length
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number.";
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character.";
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }

    final phoneRegExp = RegExp(r'^\d{10,}$');

    if (!phoneRegExp.hasMatch(value)) {
      return "Invalid phone number format (10 digits or more required)";
    }

    return null;
  }

  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return "Value is required";
    }

    final intRegExp = RegExp(r'^[0-9]+$');

    if (!intRegExp.hasMatch(value)) {
      return "Invalid integer format";
    }

    return null;
  }

  static String? validateStringAlphabetic(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    }

    final nameRegExp = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegExp.hasMatch(value)) {
      return "$fieldName must contain only alphabetic characters.";
    }

    return null;
  }

  static String? validateAddress(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    }

    final alphanumericSpecialCharRegExp = RegExp(
      r'^[a-zA-Z0-9!@#$%^&*(),.?"/:{}|<> -]+$',
    );

    if (!alphanumericSpecialCharRegExp.hasMatch(value)) {
      return "$fieldName must contain only alphanumeric and special characters.";
    }

    return null;
  }

  static String? validateAlphanumeric(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required.";
    }

    final alphanumericRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (!alphanumericRegExp.hasMatch(value)) {
      return "$fieldName must contain only alphanumeric characters.";
    }

    return null;
  }

  static String? validateAge(String? fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return "Age is required.";
    }

    final ageRegExp = RegExp(r'^[0-9]+$');

    if (!ageRegExp.hasMatch(value)) {
      return "Age must be a numeric value.";
    }

    int age = int.parse(value);

    if (age < 7 || age > 100) {
      return "Age must be between 7 years old and 100 years old.";
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
      return 'Please enter a valid $fieldName (e.g. 12.34)';
    }
    return null;
  }

  static String? validateGender(String fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender is required';
    }
    // Additional validation logic can be added if needed
    return null;
  }

  static String? validateDropdown(String fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return 'Material type is required';
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
      return 'Please enter a valid number'; // Not a valid number
    }

    if (doubleValue < 0) {
      return 'The number cannot be a negative number'; // Negative number detected
    }

    // Check if the number has more than 2 decimal places
    final formattedValue = doubleValue.toStringAsFixed(2);
    if (value != formattedValue) {
      return 'Number must be in two decimal places'; // Not in the correct format
    }

    return null; // Valid value
  }
}
