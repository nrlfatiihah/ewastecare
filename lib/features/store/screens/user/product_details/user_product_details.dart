import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/features/store/screens/user/widget/user_button_action.dart';
import 'package:ewastecare/features/store/screens/user/widget/user_product_details_lower_part.dart';
import 'package:ewastecare/features/store/screens/user/widget/user_product_details_upper_part.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class UserProductDetail extends StatelessWidget {
  const UserProductDetail({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    // final heroTag =
    //     Get.arguments['heroTag']; // Retrieve the hero tag from arguments
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-- 1 - product image
            // UserProductDeatilsUpperPart(product: product),
            UserProductDeatilsUpperPart(product: product),

            //-- 2 product details
            Padding(
              padding: const EdgeInsets.only(
                right: WasteSizes.defaultSpace,
                left: WasteSizes.defaultSpace,
                bottom: WasteSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // Title, price, stock
                  UserProductDeatilsLowerPart(product: product),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                ],
              ),
            ),

            const SizedBox(height: WasteSizes.spaceBtwItems * 2),
          ],
        ),
      ),
      floatingActionButton: UserProductDetailsActionButton(product: product),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
