// use and checked
import 'package:ewastecare/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteTermsAndConditionCheckbox extends StatelessWidget {
  const WasteTermsAndConditionCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = WasteHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value =
                  !controller.privacyPolicy.value,
            ),
          ),
        ),
        const SizedBox(width: WasteSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${WasteTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${WasteTexts.privacyPolicy} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark ? WasteColors.white : WasteColors.primary,
                  fontWeightDelta: 700,
                  decorationColor: dark
                      ? WasteColors.white
                      : WasteColors.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Privacy Policy"),
                        content: const SingleChildScrollView(
                          child: Text(
                            "Your privacy is important to us. We collect personal data only to improve your eWasteCare experience. Your data will not be shared with third parties without your consent. You can request to delete your account and data anytime",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
              ),
              TextSpan(
                text: '${WasteTexts.and} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${WasteTexts.termsOfUse} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark ? WasteColors.white : WasteColors.primary,
                  fontWeightDelta: 700,
                  decorationColor: dark
                      ? WasteColors.white
                      : WasteColors.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Terms of Use"),
                        content: const SingleChildScrollView(
                          child: Text(
                            "By using eWasteCare, you agree to follow all local e-waste recycling rules and use the app responsibly. You must provide accurate information when creating an account. Your account may be suspended if any misuse or false reporting is detected. eWasteCare reserves the right to update these terms at any time.",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
