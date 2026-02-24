import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WasteAppBar(showBackArrow: true, title: Text("App Information")),
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
                  Text(
                    "eWasteCare is a mobile application designed to encourage sustainable waste management and the 3R (Reduce, Reuse, Recycle) principles. The app allows users to monitor their waste contributions, learn proper recycling practices, and earn reward points for participating in recycling activities. By promoting responsible waste disposal and reducing landfill waste, eWasteCare aims to raise community awareness, encourage recycling, and support environmental sustainability.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: WasteSizes.spaceBtwSections),
                  Text("App Version: 2.0.0.0", textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
