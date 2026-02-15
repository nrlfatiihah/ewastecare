import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/features/store/screens/user/widget/user_product_qr_scanner.dart';
import 'package:ewastecare/features/store/screens/user/widget/user_redeem_item_form_manual.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserProductDetailsActionButton extends StatelessWidget {
  UserProductDetailsActionButton({super.key, required this.product});

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
              Get.to(() => const UserProductQRScanner());
            },
            backgroundColor: WasteColors.primary,
            heroTag: 'floatingActionButton-hero-3-${product.id}',
            child: const Icon(Iconsax.scan_barcode, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const RedeemItemFormManual());
            },
            heroTag: 'floatingActionButton-hero-4-${product.id}',
            backgroundColor: WasteColors.primary,
            child: const Icon(Iconsax.card_coin, color: WasteColors.white),
          ),
        ),
      ],
    );
  }
}
