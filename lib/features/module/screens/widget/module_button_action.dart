import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/screens/admin/module_edit_details.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';

class ModuleDetailsActionButton extends StatelessWidget {
  ModuleDetailsActionButton({super.key, required this.module});

  final ModuleModel module;
  final controller = ModuleController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.to(
                () => AdminEditModuleScreen(module: module),
                arguments: module,
              );
            },
            backgroundColor: WasteColors.primary,
            heroTag: 'floatingActionButton-hero-2-${module.id}',
            child: const Icon(Iconsax.edit, color: WasteColors.white),
          ),
        ),
      ],
    );
  }
}
