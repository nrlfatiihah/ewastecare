import 'package:flutter/material.dart';

class WasteCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstLeftCurve = Offset(0, size.height - 20);
    final lastLeftCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstLeftCurve.dx,
      firstLeftCurve.dy,
      lastLeftCurve.dx,
      lastLeftCurve.dy,
    );

    final leftStraight = Offset(0, size.height - 20);
    final rightStraiht = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      leftStraight.dx,
      leftStraight.dy,
      rightStraiht.dx,
      rightStraiht.dy,
    );

    final firstRightCurve = Offset(size.width, size.height - 20);
    final lastRightCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(
      firstRightCurve.dx,
      firstRightCurve.dy,
      lastRightCurve.dx,
      lastRightCurve.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
