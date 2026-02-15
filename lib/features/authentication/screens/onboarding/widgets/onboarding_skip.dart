// use and checked
import 'package:ewastecare/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: WasteDeviceUtils.getAppBarHeight(),
      right: WasteSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text("Skip", style: TextStyle(color: WasteColors.black)),
      ),
    );
  }
}
