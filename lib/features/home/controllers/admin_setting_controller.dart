import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_setting_repository.dart';
import 'package:flutter/material.dart';

class AdminSettingsController {
  final AdminSettingsRepository _repository = AdminSettingsRepository();

  Future<bool> verifyRecycleRatePassword(BuildContext context) async {
    String storedPassword = await _repository.getRecycleRatePassword();
    TextEditingController passwordController = TextEditingController();

    bool isVerified = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Admin Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (passwordController.text.trim() == storedPassword) {
                  isVerified = true;
                  Navigator.of(context).pop();
                } else {
                  WasteLoaders.errorSnackBar(
                    title: "Wrong Password",
                    message: "Please insert a correct password",
                  );
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    return isVerified;
  }
}
