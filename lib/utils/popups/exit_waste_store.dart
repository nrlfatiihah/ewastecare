import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/texts.dart';

class DialogUtils {
  static Future<bool> showExitStoreConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(WasteTexts.exitWasteStore.tr),
              content: Text(WasteTexts.exitStorePrompt.tr),
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
