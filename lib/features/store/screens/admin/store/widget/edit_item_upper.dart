import 'dart:io';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditItemUpper extends StatelessWidget {
  const EditItemUpper({super.key, required this.product});

  final ProductModel product;

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
        final controller = Get.find<ProductController>();
        final imagePath = controller.imagePath.value;
        final imageUrl = product.productImage;

        return Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: Stack(
            children: [
              // Show product image if it exists
              if (imageUrl.isNotEmpty)
                Center(child: Image.network(imageUrl, fit: BoxFit.cover)),
              // Show add photo icon if no image exists
              if (imageUrl.isEmpty)
                Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              // Show selected image if it exists
              if (imagePath.isNotEmpty)
                Center(child: Image.file(File(imagePath), fit: BoxFit.cover)),
            ],
          ),
        );
      }),
    );
  }
}
