import 'package:ewastecare/common/widget/texts/module_item_title_text.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';

class ProductDeatilsLowerPart extends StatelessWidget {
  const ProductDeatilsLowerPart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Details header
        const WasteSectionHeading(
          title: "Item Detail",
          showActionButton: false,
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems),

        Row(
          children: [
            const WasteModuleItemTitleText(title: "Item ID:"),
            const SizedBox(width: WasteSizes.spaceBtwItems),
            WasteModuleItemTitleText(title: product.id),
          ],
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems),

        // Product Name
        Row(
          children: [
            const WasteModuleItemTitleText(title: "Item Name:"),
            const SizedBox(width: WasteSizes.spaceBtwItems),
            WasteModuleItemTitleText(title: product.productName),
          ],
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems),

        // Product Points
        Row(
          children: [
            const WasteModuleItemTitleText(title: "Points:"),
            const SizedBox(width: WasteSizes.spaceBtwItems),
            WasteModuleItemTitleText(title: (product.point).toString()),
          ],
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems),

        // Product Stock
        Row(
          children: [
            const WasteModuleItemTitleText(title: "Stock:"),
            const SizedBox(width: WasteSizes.spaceBtwItems),
            WasteModuleItemTitleText(title: (product.stock).toString()),
          ],
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems * 2.5),

        // Product Description
        const WasteSectionHeading(
          title: "Item Description",
          showActionButton: false,
        ),
        const SizedBox(height: WasteSizes.spaceBtwItems),

        ReadMoreText(
          product.productDescription,
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimCollapsedText: "Show more",
          trimExpandedText: " Show less",
          textAlign: TextAlign.justify,
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
