import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/features/store/screens/admin/store/widget/edit_item_upper.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminEditItemScreen extends StatefulWidget {
  const AdminEditItemScreen({super.key, required this.product});

  final ProductModel product;

  @override
  AdminEditItemScreenState createState() => AdminEditItemScreenState();
}

class AdminEditItemScreenState extends State<AdminEditItemScreen> {
  late ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());

    // Set initial values for the text editing controllers
    controller.productID.text = widget.product.id;
    controller.productName.text = widget.product.productName;
    controller.productDesc.text = widget.product.productDescription;
    controller.productPoint.text = widget.product.point.toString();
    controller.productQuantity.text = widget.product.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.editItem.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EditItemUpper(product: widget.product),
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
                          onChanged: (newValue) {
                            controller.updateProductID(newValue);
                          },
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Item ID",
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
                          onChanged: (newValue) {
                            controller.updateProductName(newValue);
                          },
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Item Name",
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
                          onChanged: (newValue) {
                            controller.updateProductDesc(newValue);
                          },
                          validator: (value) =>
                              WasteValidator.validateEmptyText(
                                "Item Description",
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
                          onChanged: (newValue) {
                            controller.updateProductPoint(newValue);
                          },
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
                          onChanged: (newValue) {
                            controller.updateProductQuantity(newValue);
                          },
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
                            onPressed: () {
                              if (controller.addProductFormKey.currentState!
                                  .validate()) {
                                // Save the form details
                                controller.saveFormDetails();
                                // Proceed with updating the product
                                controller.updateProduct(widget.product);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WasteColors.buttonPrimary,
                              side: const BorderSide(
                                color: WasteColors.buttonPrimary,
                              ),
                            ),
                            child: Text(WasteTexts.updateProduct.tr),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwSections),

                        // Delete Product button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.showDeleteConfirmationDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: Text(WasteTexts.deleteItem.tr),
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
