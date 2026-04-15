// use and checked
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLoginHeader extends StatelessWidget {
  const AdminLoginHeader({super.key, required this.dark});

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
          WasteTexts.adminLoginTitle.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: WasteSizes.sm),
        Text(
          WasteTexts.adminLoginSubTitle.tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
