import 'dart:io';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemUpper extends StatelessWidget {
  const AddItemUpper({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<ProductController>().selectProductImage().then((value) {
          if (value != null) {
            Get.find<ProductController>().setImagePath(value);
          }
        });
      },
      child: Obx(() {
        final imagePath = Get.find<ProductController>().imagePath.value;
        return Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: Center(
            child: imagePath.isEmpty
                ? Icon(
                    Icons.add_photo_alternate,
                    size: 50,
                    color: Colors.grey[400],
                  )
                : Image.file(File(imagePath), fit: BoxFit.cover),
          ),
        );
      }),
    );
  }
}
