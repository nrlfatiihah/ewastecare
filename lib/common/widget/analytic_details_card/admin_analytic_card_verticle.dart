import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class AdminAnalyticCardVertical extends StatelessWidget {
  const AdminAnalyticCardVertical({
    super.key,
    this.showBackground = true,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.gradientStart,
    this.gradientEnd,
  });

  final bool showBackground;
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? gradientStart;
  final Color? gradientEnd;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = WasteHelperFunctions.isDarkMode(context);
    final controller = Get.find<AdminDashboardController>();

    return GestureDetector(
      child: Container(
        constraints: const BoxConstraints(minHeight: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: showBackground
              ? LinearGradient(
                  colors: [
                    gradientStart ?? WasteColors.primary.withOpacity(0.9),
                    gradientEnd ?? WasteColors.primary.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: showBackground
              ? null
              : isDarkMode
              ? WasteColors.dark
              : WasteColors.light,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown, // Shrinks content if slightly overflowing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.white).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor ?? Colors.white, size: 32),
                ),
              if (icon != null) const SizedBox(height: 12),
              Obx(() {
                if (controller.isLoading.value) {
                  return const WasteShimmerEffect(width: 80, height: 20);
                } else {
                  return Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              }),
              const SizedBox(height: 6),
              Obx(() {
                if (controller.isLoading.value) {
                  return const WasteShimmerEffect(width: 80, height: 24);
                } else {
                  return Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
