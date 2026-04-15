import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/screens/admin/store/widget/add_item_upper.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminAddItemScreen extends StatelessWidget {
  const AdminAddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.addNewItem.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddItemUpper(),
            Padding(
              padding: const EdgeInsets.all(WasteSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: controller.addProductFormKey,
                    child: Column(
                      children: [
                        // Product ID
                        TextFormField(
                          controller: controller.productID,
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Product ID",
                                value,
                              ),
                          expands: false,
                          decoration: InputDecoration(
                            labelText: WasteTexts.productID.tr,
                            prefixIcon: Icon(Iconsax.user_edit),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwInputFields),
                        // Product Name
                        TextFormField(
                          controller: controller.productName,
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Product Name",
                                value,
                              ),
                          expands: false,
                          decoration: InputDecoration(
                            labelText: WasteTexts.productName.tr,
                            prefixIcon: Icon(Iconsax.user_edit),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwInputFields),

                        // Product Description
                        TextFormField(
                          controller: controller.productDesc,
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Product Description",
                                value,
                              ),
                          expands: false,
                          decoration: InputDecoration(
                            labelText: WasteTexts.productDesc.tr,
                            prefixIcon: Icon(Iconsax.user_edit),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwInputFields),

                        // Product Point
                        TextFormField(
                          controller: controller.productPoint,
                          validator: (value) =>
                              WasteValidator.validateInteger(value),
                          expands: false,
                          decoration: InputDecoration(
                            labelText: WasteTexts.productPoint.tr,
                            prefixIcon: Icon(Iconsax.user_edit),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwInputFields),

                        // Product Quantity
                        TextFormField(
                          controller: controller.productQuantity,
                          validator: (value) =>
                              WasteValidator.validateInteger(value),
                          expands: false,
                          decoration: InputDecoration(
                            labelText: WasteTexts.productQuantity.tr,
                            prefixIcon: Icon(Iconsax.user_edit),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwSections),

                        // Generate Voucher button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.addNewProduct(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WasteColors.buttonPrimary,
                              side: const BorderSide(
                                color: WasteColors.buttonPrimary,
                              ),
                            ),
                            child: Text(WasteTexts.addProduct.tr),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
