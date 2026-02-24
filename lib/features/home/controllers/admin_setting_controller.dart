import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_setting_repository.dart';
import 'package:flutter/material.dart';

class AdminSettingsController {
  final AdminSettingsRepository _repository = AdminSettingsRepository();

  Future<bool> verifyRecycleRatePassword(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();
    bool isVerified = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Admin Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
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
                    title: "Authentication Failed",
                    message: e.toString(),
                  );
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    return isVerified;
  }
}
