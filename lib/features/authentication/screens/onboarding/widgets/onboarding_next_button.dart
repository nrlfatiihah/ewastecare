// use and checked
import 'package:ewastecare/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: WasteSizes.defaultSpace,
      bottom: WasteDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: WasteColors.primary,
          side: const BorderSide(color: WasteColors.buttonPrimary),
        ),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
