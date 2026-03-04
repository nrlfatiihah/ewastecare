import 'package:ewastecare/common/widget/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class WastePrimaryHeaderContainer extends StatelessWidget {
  const WastePrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WasteCurvedEdgeWidget(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              WasteColors.primary,
              WasteColors.primary.withOpacity(0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Top-left abstract polygon
            Positioned(
              top: -screenHeight * 0.05,
              left: -screenWidth * 0.2,
              child: Transform.rotate(
                angle: -0.4,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: WasteColors.textWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
              ),
            ),

            // Top-right soft blob
            Positioned(
              top: screenHeight * 0.05,
              right: -screenWidth * 0.25,
              child: ClipPath(
                clipper: BlobClipper1(),
                child: Container(
                  width: 200,
                  height: 200,
                  color: WasteColors.textWhite.withOpacity(0.08),
                ),
              ),
            ),

            // Bottom-left soft blob
            Positioned(
              bottom: -screenHeight * 0.05,
              left: -screenWidth * 0.2,
              child: ClipPath(
                clipper: BlobClipper2(),
                child: Container(
                  width: 250,
                  height: 250,
                  color: WasteColors.textWhite.withOpacity(0.06),
                ),
              ),
            ),

            // Foreground child content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

// First blob shape
class BlobClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height,
      size.width * 0.2,
      size.height * 0.8,
    );
    path.quadraticBezierTo(0, size.height * 0.6, 0, size.height * 0.3);
    path.quadraticBezierTo(0, 0, size.width * 0.3, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Second blob shape
class BlobClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.quadraticBezierTo(
      size.width * 0.8,
      0,
      size.width * 0.7,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width,
      size.height * 0.8,
      size.width * 0.3,
      size.height,
    );
    path.quadraticBezierTo(0, size.height * 0.7, 0, size.height * 0.3);
    path.quadraticBezierTo(0, 0, size.width * 0.2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
