import 'package:ewastecare/features/module/screens/admin/add_new_module.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';

class AdminModuleActionButton extends StatelessWidget {
  const AdminModuleActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ModuleController.instance.clearFormData();
        Get.to(() => const AdminAddModuleScreen());
      },
      backgroundColor: WasteColors.primary,
      child: const Icon(Iconsax.add, color: WasteColors.white),
    );
  }
}
