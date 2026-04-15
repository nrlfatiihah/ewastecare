// use and checked
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteLoginHeader extends StatelessWidget {
  const WasteLoginHeader({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 150,
          image: AssetImage(
            dark ? WasteImages.lightAppLogo : WasteImages.darkAppLogo,
          ),
        ),
        Text(
          WasteTexts.loginTitle.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: WasteSizes.sm),
        Text(
          WasteTexts.loginSubTitle.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
