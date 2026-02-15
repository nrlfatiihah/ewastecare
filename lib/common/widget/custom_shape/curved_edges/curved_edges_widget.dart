import 'package:ewastecare/common/widget/custom_shape/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

class WasteCurvedEdgeWidget extends StatelessWidget {
  const WasteCurvedEdgeWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: WasteCustomCurvedEdges(), child: child);
  }
}
