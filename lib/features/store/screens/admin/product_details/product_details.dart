import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/widget/product_button_action.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/widget/product_details_lower_part.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/widget/product_details_upper_part.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class AdminProductDetail extends StatelessWidget {
  const AdminProductDetail({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //-- 1 - product image
            ProductDeatilsUpperPart(product: product),

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
                  ProductDeatilsLowerPart(product: product),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ProductDetailsActionButton(product: product),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
