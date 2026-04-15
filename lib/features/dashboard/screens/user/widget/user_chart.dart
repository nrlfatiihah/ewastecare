import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChartProgressIndicator extends StatelessWidget {
  const PieChartProgressIndicator({super.key, this.showBackground = true});

  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final controller = UserDashboardController.instance;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24),
      width: WasteDeviceUtils.getScreenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: showBackground
            ? LinearGradient(
                colors: dark
                    ? [WasteColors.dark, WasteColors.dark.withOpacity(0.9)]
                    : [Colors.white, WasteColors.light.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.4)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 🔹 Title
          Text(
            WasteTexts.progressOverview.tr,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 220,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const WasteShimmerEffect(width: 150, height: 150);
              } else {
                final userDashboard = controller.newUserDashboardData.value;
                final progress = userDashboard.getProgress();
                final nextTier = userDashboard.getNextTier();

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 70,
                        startDegreeOffset: 270,
                        borderData: FlBorderData(show: false),
                        sections: [
                          PieChartSectionData(
                            value: progress * 100,
                            color: WasteColors.primary,
                            radius: 18, // thinner = modern ring look
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 100 - (progress * 100),
                            color: WasteColors.darkGrey.withOpacity(0.2),
                            radius: 18,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),

                    // Center Content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        if (nextTier != 'none')
                          Text(
                            "Next: $nextTier",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                      ],
                    ),
                  ],
                );
              }
            }),
          ),

          const SizedBox(height: 20),

          // Bottom Progress Text
          Obx(() {
            if (controller.isLoading.value) {
              return const WasteShimmerEffect(width: 120, height: 20);
            } else {
              final userDashboard = controller.newUserDashboardData.value;
              final nextTierThreshold = userDashboard.getNextTierThreshold();

              return Text(
                "${userDashboard.totalWeightAllMaterials} Kg  /  ${nextTierThreshold.toInt()} Kg",
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }
          }),
        ],
      ),
    );
  }
}
