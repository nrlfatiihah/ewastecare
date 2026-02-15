// use and checked
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
  });

  final bool showBackground;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = WasteHelperFunctions.isDarkMode(context);
    final controller = Get.find<AdminDashboardController>();

    return GestureDetector(
      child: Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.all(1),
        decoration: ShapeDecoration(
          color: showBackground
              ? isDarkMode
                    ? WasteColors.dark
                    : WasteColors.light
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.25)
                  : Colors.black.withOpacity(0.25),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          shadows: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.25)
                  : Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const WasteShimmerEffect(width: 10, height: 10);
              } else {
                return Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!,
                  textAlign: TextAlign.center,
                );
              }
            }),
            const SizedBox(height: WasteSizes.spaceBtwItems / 2),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ), // Adjust the top padding as needed
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const WasteShimmerEffect(width: 10, height: 10);
                } else {
                  return Text(
                    value,
                    style: Theme.of(context).textTheme.titleSmall!,
                    textAlign: TextAlign.center,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
