import 'package:ewastecare/features/waste_point/widget/test_add_rate.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TestRateActionbutton extends StatelessWidget {
  const TestRateActionbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Clear form data before navigating to the form screen
        // ProductController.instance.clearFormData();
        // Navigate to the form screen
        Get.to(() => const TestAdminAddMaterialScreen());
      },
      // Add your FAB button logic here,
      backgroundColor: WasteColors.primary,
      child: const Icon(Iconsax.add, color: WasteColors.white),
    );

    // return Stack(
    //   children: [
    //     Positioned(
    //       bottom: 80.0, // adjust as needed
    //       right: 16.0,
    //         child: FloatingActionButton(
    //           onPressed: () {
    //             Get.to(() => AdminAddMaterialScreen());
    //           },
    //           backgroundColor: WasteColors.primary,
    //           heroTag: 'floatingActionButton-hero-3',
    //           child: const Icon(
    //             Iconsax.add,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),

    //     Positioned(
    //       bottom: 16.0,
    //       right: 16.0,
    //         child: FloatingActionButton(
    //           onPressed: () {
    //             Get.to(() => EditRate());
    //           },
    //           backgroundColor: WasteColors.primary,
    //           heroTag: 'floatingActionButton-hero-4',
    //           child: const Icon(
    //             Iconsax.edit,
    //             color: WasteColors.white,
    //           ),
    //         ),
    //       ),
    //   ],
    // );
  }
}
