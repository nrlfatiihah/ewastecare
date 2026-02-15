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
                    """She got stressed out whenever she saw a notification on her email. The game looked fun, but all the pieces were missing. A big tree in the field was struck by lightning. Sales have dropped off at every department store. I caught a catfish yesterday with my bare hands. I can tell you're angry about the time change. That's the biggest grasshopper I've ever seen. She created an app to match zombies with willing victims. My mom drove me to school fifteen minutes late on Tuesday. Let's all just take a moment to breathe, please!""",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: WasteSizes.spaceBtwSections),
                  Text("App Version: 1.0.0.0", textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
