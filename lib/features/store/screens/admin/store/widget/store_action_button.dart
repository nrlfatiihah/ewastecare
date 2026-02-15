import 'package:ewastecare/features/store/screens/admin/store/widget/add_new_item.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';

class AdminStoreActionButton extends StatelessWidget {
  const AdminStoreActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Clear form data before navigating to the form screen
        ProductController.instance.clearFormData();
        // Navigate to the form screen
        Get.to(() => const AdminAddItemScreen());
      },
      // Add your FAB button logic here,
      backgroundColor: WasteColors.primary,
      child: const Icon(Iconsax.add, color: WasteColors.white),
    );
  }
}
