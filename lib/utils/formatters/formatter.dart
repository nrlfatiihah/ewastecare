import 'package:intl/intl.dart';

class WasteFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat("dd-MM-yyyy").format(date);
  }

  static String formattedPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return "(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}";
    } else if (phoneNumber.length == 11) {
      return "(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}";
    }
    return phoneNumber;
  }
}
