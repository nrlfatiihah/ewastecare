import 'package:ewastecare/common/styles/shadow.dart';
import 'package:ewastecare/common/widget/images/waste_roundimage.dart';
import 'package:ewastecare/common/widget/rounded_container/rounded_container.dart';
import 'package:ewastecare/common/widget/texts/module_item_title_text.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/product_details.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WasteItemCardVertical extends StatelessWidget {
  const WasteItemCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    // final controller = ProductController.instance;
    final dark = WasteHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => AdminProductDetail(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [WasteShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(WasteSizes.productImageRadius),
          color: dark ? WasteColors.darkerGrey : WasteColors.white,
        ),
        child: Column(
          children: [
            // Thumbnail
            const SizedBox(height: WasteSizes.spaceBtwItems / 2),
            WasteRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(WasteSizes.sm),
              backgroundColor: dark ? WasteColors.dark : WasteColors.light,
              child: WasteRoundImage(
                imageUrl: product.productImage,
                applyImageRadius: true,
                isNetworkImage: true,
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems / 2),

            // Title
            Padding(
              padding: const EdgeInsets.only(left: WasteSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main title
                  WasteModuleItemTitleText(
                    title: product.productName,
                    smallSize: false,
                    maxLines: 1,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems / 2),
                  Row(
                    // Sub title
                    children: [
                      Text(
                        "${(product.point).toString()} Points",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: WasteSizes.xs),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: WasteSizes.sm),
                  child: Text(
                    "Stock: ${(product.stock).toString()}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: WasteColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(WasteSizes.cardRadiusMd),
                      bottomRight: Radius.circular(
                        WasteSizes.productImageRadius,
                      ),
                    ),
                  ),
                  child: const SizedBox(
                    width: WasteSizes.iconLg * 1.2,
                    height: WasteSizes.iconLg * 1.2,
                    child: Center(
                      child: Icon(Iconsax.eye, color: WasteColors.white),
                    ),
                  ),
                ),
              ],
            ),

            // Details
          ],
        ),
      ),
    );
  }
}
