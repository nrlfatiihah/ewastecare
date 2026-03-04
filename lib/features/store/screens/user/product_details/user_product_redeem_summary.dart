import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/images/waste_circular_image.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/screens/user/widget/confirm_transaction.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
    required this.productId,
    required this.quantity,
    required this.totalCost,
    required this.userWastePointBalance,
    required this.productName,
    required this.productPrice,
    required this.userId,
  });

  final String productId;
  final int quantity;
  final int totalCost;
  final int userWastePointBalance;
  final String productName;
  final int productPrice;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final displayProductName = productName;
    final displayProductPrice = productPrice;
    final totalCost = displayProductPrice * quantity;
    final userBalance = userWastePointBalance;
    final newBalance = userBalance - totalCost;
    final displayQuantity = quantity;

    return Scaffold(
      appBar: const WasteAppBar(
        showBackArrow: true,
        title: Text("Confirmation Summary"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WasteCircularImage(
              image: WasteImages.productRedeemImage,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            const WasteSectionHeading(
              title: "Product Details",
              showActionButton: false,
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            WasteConfirmRedeemMenu(title: "Product ID", value: productId),
            WasteConfirmRedeemMenu(
              title: "Product Name",
              value: displayProductName,
            ),
            WasteConfirmRedeemMenu(
              title: "Quantity",
              value: displayQuantity.toString(),
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            const WasteSectionHeading(
              title: "Payment Details",
              showActionButton: false,
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            WasteConfirmRedeemMenu(
              title: "WastePoint Balance",
              value: userBalance.toString(),
            ),
            WasteConfirmRedeemMenu(
              title: "Total Price",
              value: totalCost.toString(),
            ),
            WasteConfirmRedeemMenu(
              title: "New Balance",
              value: newBalance.toString(),
            ),
            const SizedBox(height: WasteSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateDatabaseAfterRedeemProduct(
                  productId: productId,
                  quantity: quantity,
                  totalCost: totalCost,
                  newBalance: newBalance,
                  userid: userId,
                  product: productName,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                ),
                child: const Text(WasteTexts.confirmRedeem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
