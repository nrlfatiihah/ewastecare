// use and checked
import 'package:ewastecare/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ewastecare/features/personalization/screens/policy_n_privacy/policy_n_privacy.dart';
import 'package:ewastecare/features/personalization/screens/terms_n_condition/terms_n_condition.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Text.rich(
            softWrap: true,
            TextSpan(
              children: [
                TextSpan(
                  text: '${WasteTexts.iAgreeTo.tr} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: '${WasteTexts.privacyPolicy.tr} ',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? WasteColors.white : WasteColors.primary,
                    fontWeightDelta: 700,
                    decorationColor: dark
                        ? WasteColors.white
                        : WasteColors.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const PolicyNPrivacyScreen()),
                ),
                TextSpan(
                  text: '${WasteTexts.and.tr} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: '${WasteTexts.termsOfUse.tr} ',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? WasteColors.white : WasteColors.primary,
                    fontWeightDelta: 700,
                    decorationColor: dark
                        ? WasteColors.white
                        : WasteColors.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const TermsNConditionScreen()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
