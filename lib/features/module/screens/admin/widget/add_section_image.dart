import 'dart:io';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';

class AddSectionImage extends StatelessWidget {
  final int index;
  const AddSectionImage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ModuleController>();
    return Obx(() {
      final section = controller.sections[index];

      Widget imageWidget;

      // Show picked file if available
      if (section.sectionImageFile != null) {
        imageWidget = Image.file(
          section.sectionImageFile!,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        );
      }
      // Show existing URL if available
      else if (section.sectionImageUrl != null &&
          section.sectionImageUrl!.isNotEmpty) {
        imageWidget = Image.network(
          section.sectionImageUrl!,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        );
      }
      // Placeholder if no image
      else {
        imageWidget = Container(
          width: double.infinity,
          height: 180,
          color: WasteColors.white,
          child: const Icon(
            Icons.add_photo_alternate,
            size: 50,
            color: Colors.grey,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text("Section Image", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          imageWidget,
          TextButton.icon(
            onPressed: () async {
              await controller.pickSectionImage(index);
            },
            icon: const Icon(Icons.image),
            label: Text(WasteTexts.selectImage.tr),
          ),
        ],
      );
    });
  }
}
