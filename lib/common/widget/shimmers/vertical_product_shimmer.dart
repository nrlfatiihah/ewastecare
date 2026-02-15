import 'package:ewastecare/common/widget/layouts/grid_layout.dart';
import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class WasteVerticalProductShimmer extends StatelessWidget {
  const WasteVerticalProductShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return WasteGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WasteShimmerEffect(width: 100, height: 180),
            SizedBox(height: WasteSizes.spaceBtwItems),
            WasteShimmerEffect(width: 160, height: 15),
            SizedBox(height: WasteSizes.spaceBtwItems / 2),
            WasteShimmerEffect(width: 110, height: 15),
          ],
        ),
      ),
    );
  }
}
