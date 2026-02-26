import 'dart:io';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddModuleImage extends StatelessWidget {
  const AddModuleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<ModuleController>().selectModuleImage().then((value) {
          if (value != null) {
            Get.find<ModuleController>().setImagePath(value);
          }
        });
      },
      child: Obx(() {
        final imagePath = Get.find<ModuleController>().imagePath.value;
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: Center(
            child: imagePath.isEmpty
                ? Icon(
                    Icons.add_photo_alternate,
                    size: 30,
                    color: Colors.grey[400],
                  )
                : Image.file(File(imagePath), fit: BoxFit.cover),
          ),
        );
      }),
    );
  }
}
