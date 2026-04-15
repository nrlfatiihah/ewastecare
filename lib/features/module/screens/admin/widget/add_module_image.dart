import 'dart:io';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';

class AddModuleImage extends StatelessWidget {
  const AddModuleImage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ModuleController>();

    return Obx(() {
      final imagePath = controller.imagePath.value;

      Widget imageWidget;

      if (imagePath.isEmpty) {
        // No image selected yet
        imageWidget = SizedBox(
          height: 150,
          child: Center(child: Text(WasteTexts.noImageSelected.tr)),
        );
      } else if (imagePath.startsWith("http")) {
        // Network image (existing module image)
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Center(child: Text(WasteTexts.failedToLoadImage.tr)),
          ),
        );
      } else {
        // Local file selected
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Module Image", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          imageWidget,
          TextButton.icon(
            onPressed: () async {
              final path = await controller.selectModuleImage();
              if (path != null) controller.setImagePath(path);
            },
            icon: const Icon(Icons.image),
            label: Text(WasteTexts.selectImage.tr),
          ),
        ],
      );
    });
  }
}
