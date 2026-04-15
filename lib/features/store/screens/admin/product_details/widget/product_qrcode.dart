import 'package:get/get.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductQrCode extends StatelessWidget {
  final ProductModel product;
  const ProductQrCode({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Scaffold(
        appBar: WasteAppBar(
          showBackArrow: true,
          title: Text(WasteTexts.itemQrCode.tr),
        ),
        body: Center(
          child: product.productQR.isNotEmpty
              ? Image.network(product.productQR)
              : Text('No QR Code available'),
        ),
      ),
    );
  }
}
