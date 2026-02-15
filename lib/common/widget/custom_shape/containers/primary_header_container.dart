// use and checked
import 'package:ewastecare/common/widget/custom_shape/containers/circular_container.dart';
import 'package:ewastecare/common/widget/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class WastePrimaryHeaderContainer extends StatelessWidget {
  const WastePrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WasteCurvedEdgeWidget(
      child: Container(
        color: WasteColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          // Background Custom Shape
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: WasteCircularContainer(
                backgroundColor: WasteColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: WasteCircularContainer(
                backgroundColor: WasteColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
