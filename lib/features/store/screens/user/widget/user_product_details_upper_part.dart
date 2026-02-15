import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:ewastecare/common/widget/images/bako_roundimage.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class UserProductDeatilsUpperPart extends StatelessWidget {
  const UserProductDeatilsUpperPart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);

    return WasteCurvedEdgeWidget(
      child: Container(
        color: dark ? WasteColors.darkerGrey : WasteColors.light,
        child: Stack(
          children: [
            // main large image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(
                  WasteSizes.productImageRadius * 2,
                ),
                child: Center(
                  child: WasteRoundImage(
                    imageUrl: product.productImage,
                    isNetworkImage: true,
                    applyImageRadius: true,
                  ),
                ),
              ),
            ),

            const WasteAppBar(showBackArrow: true),
          ],
        ),
      ),
    );
  }
}
