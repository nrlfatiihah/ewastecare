import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/screens/user/widget/confirm_transaction.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
    required this.productImage,
    required this.productId,
    required this.quantity,
    required this.totalCost,
    required this.userWastePointBalance,
    required this.productName,
    required this.productPrice,
    required this.userId,
  });

  final String productImage;
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
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.confirmationSummary.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          children: [
            // Product Image
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WasteColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  productImage,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
            ),

            const SizedBox(height: WasteSizes.spaceBtwSections),

            // Product Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WasteSectionHeading(
                      title: WasteTexts.productDetails.tr,
                      showActionButton: false,
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwItems),

                    WasteConfirmRedeemMenu(
                      title: WasteTexts.productID.tr,
                      value: productId,
                    ),
                    WasteConfirmRedeemMenu(
                      title: WasteTexts.productName.tr,
                      value: displayProductName,
                    ),
                    WasteConfirmRedeemMenu(
                      title: WasteTexts.quantity.tr,
                      value: displayQuantity.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: WasteSizes.spaceBtwSections),

            // Payment Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WasteSectionHeading(
                      title: WasteTexts.paymentDetails.tr,
                      showActionButton: false,
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwItems),

                    WasteConfirmRedeemMenu(
                      title: WasteTexts.wastePointBalance.tr,
                      value: userBalance.toString(),
                    ),

                    WasteConfirmRedeemMenu(
                      title: WasteTexts.totalPrice.tr,
                      value: totalCost.toString(),
                    ),

                    WasteConfirmRedeemMenu(
                      title: WasteTexts.newBalance.tr,
                      value: newBalance.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: WasteSizes.spaceBtwSections),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => controller.updateDatabaseAfterRedeemProduct(
                  productId: productId,
                  quantity: quantity,
                  totalCost: totalCost,
                  newBalance: newBalance,
                  userid: userId,
                  product: productName,
                ),
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: WasteColors.buttonPrimary,
                      elevation: 4,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                child: Text(
                  WasteTexts.confirmRedeem.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
