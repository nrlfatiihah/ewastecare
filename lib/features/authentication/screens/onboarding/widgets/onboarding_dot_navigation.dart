// use and checked
import 'package:ewastecare/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = WasteHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: WasteDeviceUtils.getBottomNavigationBarHeight(),
      left: WasteSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? WasteColors.light : WasteColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}
