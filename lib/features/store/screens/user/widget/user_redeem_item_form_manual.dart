import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/store/controllers/redeem_item_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/popups/cancel_redeem_popup.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RedeemItemFormManual extends StatelessWidget {
  const RedeemItemFormManual({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RedeemItemController());
    // Create a new instance of GlobalKey<FormState> each time the widget is built
    controller.redeemItemFormKey = GlobalKey<FormState>();

    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) async {
        if (didPop) {
          // If the user tries to navigate back from the Redeem Item screen
          return;
        }
        bool shouldCancel = await DialogUtils.showCancelConfirmationDialog(
          context,
        );
        if (shouldCancel) {
          // You can perform any additional actions if needed
          Get.back();
        }
      }),
      child: Scaffold(
        appBar: const WasteAppBar(
          showBackArrow: true,
          title: Text("Redeem Item"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(WasteSizes.defaultSpace),
            child: Form(
              key: controller.redeemItemFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.productIdController,
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Item ID",
                                value,
                              ),
                          decoration: const InputDecoration(
                            labelText: WasteTexts.redeemProductID,
                            prefixIcon: Icon(Iconsax.box_search),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                  TextFormField(
                    controller: controller.quantityController,
                    validator: (value) => WasteValidator.validateEmptyText(
                      "Item Quantity",
                      value,
                    ),
                    decoration: const InputDecoration(
                      labelText: WasteTexts.redeemProductQuantity,
                      prefixIcon: Icon(Iconsax.shopping_cart),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.validateAndProceed();
                      controller.clearFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WasteColors.buttonPrimary,
                      side: const BorderSide(color: WasteColors.buttonPrimary),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
