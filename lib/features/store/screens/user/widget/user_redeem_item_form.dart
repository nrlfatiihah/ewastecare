import 'package:ewastecare/features/store/controllers/redeem_item_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RedeemItemForm extends StatelessWidget {
  const RedeemItemForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RedeemItemController());

    // Create a new form key
    controller.redeemItemFormKey = GlobalKey<FormState>();

    // Safely set scanned code after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scannedCode = Get.arguments as String?; // safe cast
      if (scannedCode != null && scannedCode.isNotEmpty) {
        controller.productIdController.text = scannedCode;
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Redeem Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.redeemItemFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.productIdController,
                decoration: const InputDecoration(
                  labelText: "Item ID",
                  prefixIcon: Icon(Iconsax.box_search),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter Item ID"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.quantityController,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  prefixIcon: Icon(Iconsax.shopping_cart),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter quantity"
                    : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (controller.redeemItemFormKey.currentState?.validate() ??
                      false) {
                    await controller.validateAndProceed();
                    controller.clearFields();
                  }
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
    );
  }
}
