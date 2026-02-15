import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/widget/product_edit_details.dart';
import 'package:ewastecare/features/store/screens/admin/product_details/widget/product_qrcode.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/features/store/models/product_model.dart';

class ProductDetailsActionButton extends StatelessWidget {
  ProductDetailsActionButton({super.key, required this.product});

  final ProductModel product;
  final controller = ProductController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 80.0, // adjust as needed
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => ProductQrCode(product: product));
            },
            backgroundColor: WasteColors.primary,
            heroTag: 'floatingActionButton-hero-1-${product.id}',
            child: const Icon(Iconsax.scan_barcode, color: Colors.white),
          ),
        ),

        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(
                () => AdminEditItemScreen(product: product),
                arguments: product,
              );
            },
            backgroundColor: WasteColors.primary,
            heroTag: 'floatingActionButton-hero-2-${product.id}',
            child: const Icon(Iconsax.edit, color: WasteColors.white),
          ),
        ),
      ],
    );
  }
}
