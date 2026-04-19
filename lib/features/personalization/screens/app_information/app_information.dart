import 'package:get/get.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.appInformation.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-- details
            Padding(
              padding: EdgeInsets.only(
                right: WasteSizes.defaultSpace,
                left: WasteSizes.defaultSpace,
                bottom: WasteSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // Title, price, stock
                  SizedBox(height: WasteSizes.spaceBtwItems / 2),
                  Text(WasteTexts.appContent.tr, textAlign: TextAlign.justify),
                  SizedBox(height: WasteSizes.spaceBtwSections),
                  Text(WasteTexts.appVersion.tr, textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
