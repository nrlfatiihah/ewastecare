// use and checked
import 'package:ewastecare/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:ewastecare/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:ewastecare/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:ewastecare/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: WasteImages.onBoardingImage1,
                title: WasteTexts.onBoardingTitle1,
                subTitle: WasteTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: WasteImages.onBoardingImage2,
                title: WasteTexts.onBoardingTitle2,
                subTitle: WasteTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: WasteImages.onBoardingImage3,
                title: WasteTexts.onBoardingTitle3,
                subTitle: WasteTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          // Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
