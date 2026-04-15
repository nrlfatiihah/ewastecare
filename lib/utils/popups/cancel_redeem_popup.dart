import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/texts.dart';

class DialogUtils {
  static Future<bool> showCancelConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(WasteTexts.cancelTransaction.tr),
              content: Text(WasteTexts.confirmCancelTransaction.tr),
              actions: <Widget>[
                TextButton(
                  child: Text(WasteTexts.no.tr),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(WasteTexts.yes.tr),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
