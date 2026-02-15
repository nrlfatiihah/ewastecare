import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class WasteGridLayout extends StatelessWidget {
  const WasteGridLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 288,
    required this.itemBuilder,
    this.crossAxisCount = 2,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final int crossAxisCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent,
        mainAxisSpacing: WasteSizes.gridViewSpacing,
        crossAxisSpacing: WasteSizes.gridViewSpacing,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
