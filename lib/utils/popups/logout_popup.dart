import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/texts.dart';

class DialogUtils {
  static Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(WasteTexts.confirmLogout.tr),
            content: Text(WasteTexts.confirmLogoutMessage.tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(WasteTexts.no.tr),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(WasteTexts.yes.tr),
              ),
            ],
          ),
        ) ??
        false;
  }
}
