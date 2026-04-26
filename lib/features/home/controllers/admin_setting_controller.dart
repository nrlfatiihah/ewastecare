import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_setting_repository.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSettingsController {
  final AdminSettingsRepository _repository = AdminSettingsRepository();

  Future<bool> verifyRecycleRatePassword(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    bool isVerified = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(WasteTexts.reAuthenticateAdmin.tr),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: WasteTexts.password.tr),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _repository.reauthenticateAdmin(
                    passwordController.text.trim(),
                  );

                  isVerified = true;
                  Navigator.of(context).pop();
                } catch (e) {
                  WasteLoaders.errorSnackBar(
                    title: WasteTexts.oops.tr,
                    message: e.toString(),
                  );
                }
              },
              child: Text(WasteTexts.submit.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(WasteTexts.cancel.tr),
            ),
          ],
        );
      },
    );

    return isVerified;
  }
}
