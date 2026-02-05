import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/controllers/create_account_controller.dart';

class CheckboxTerms extends StatelessWidget {
  final CreateAccountController controller;
  const CheckboxTerms({super.key, required this.controller});

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Close",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF9CCC65),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF9CCC65);

    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: controller.isChecked.value,
            activeColor: primaryColor,
            onChanged: (value) => controller.isChecked.value = value ?? false,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: "I accept the "),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: const TextStyle(
                      color: Color(0xFF388E3C),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showDialog(
                          context,
                          "Terms & Conditions",
                          "By using eWasteCare, you agree to follow all local e-waste recycling rules and use the app responsibly. You must provide accurate information when creating an account. Your account may be suspended if any misuse or false reporting is detected. eWasteCare reserves the right to update these terms at any time.",
                        );
                      },
                  ),
                  const TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(
                      color: Color(0xFF388E3C),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showDialog(
                          context,
                          "Privacy Policy",
                          "Your privacy is important to us. We collect personal data only to improve your eWasteCare experience. Your data will not be shared with third parties without your consent. You can request to delete your account and data anytime",
                        );
                      },
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
