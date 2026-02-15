import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PieChartMaterialInformation extends StatelessWidget {
  const PieChartMaterialInformation({super.key, this.showBackground = true});

  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final adminDashboardService = AdminDashboardService.instance;
    return Obx(() {
      return FutureBuilder<void>(
        future:
            (adminDashboardService.selectedStartDate.value != null &&
                adminDashboardService.selectedEndDate.value != null)
            ? adminDashboardService.calculateMaterialWeightsByFilterDate()
            : adminDashboardService.calculateMaterialWeights(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loader while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Handle error
          } else {
            return Obx(() {
              // Access percentages from AdminDashboardService
              final plasticPercentage =
                  adminDashboardService.materialGroupPercentages['Plastic'] ??
                  0.0;
              final paperPercentage =
                  adminDashboardService.materialGroupPercentages['Paper'] ??
                  0.0;
              final canPercentage =
                  adminDashboardService.materialGroupPercentages['Can'] ?? 0.0;
              final oilPercentage =
                  adminDashboardService.materialGroupPercentages['Used Oil'] ??
                  0.0;
              final otherPercentage =
                  adminDashboardService.materialGroupPercentages['Others'] ??
                  0.0;

              final plasticWeight =
                  adminDashboardService.materialGroupWeights['Plastic'] ?? 0.0;
              final paperWeight =
                  adminDashboardService.materialGroupWeights['Paper'] ?? 0.0;
              final canWeight =
                  adminDashboardService.materialGroupWeights['Can'] ?? 0.0;
              final oilWeight =
                  adminDashboardService.materialGroupWeights['Used Oil'] ?? 0.0;
              final otherWeight =
                  adminDashboardService.materialGroupWeights['Others'] ?? 0.0;

              // Legend items
              final List<Map<String, dynamic>> legendItems = [
                {
                  'color': WasteColors.primary,
                  'text': 'Plastic Material',
                  'percentage': plasticPercentage,
                  'weight': plasticWeight,
                },
                {
                  'color': Colors.cyan,
                  'text': 'Paper Material',
                  'percentage': paperPercentage,
                  'weight': paperWeight,
                },
                {
                  'color': Colors.orange,
                  'text': 'Can Material',
                  'percentage': canPercentage,
                  'weight': canWeight,
                },
                {
                  'color': Colors.purple,
                  'text': 'Used Oil Material',
                  'percentage': oilPercentage,
                  'weight': oilWeight,
                },
                {
                  'color': WasteColors.error,
                  'text': 'Others Material',
                  'percentage': otherPercentage,
                  'weight': otherWeight,
                },
              ];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                width: WasteDeviceUtils.getScreenWidth(context),
                decoration: ShapeDecoration(
                  color: showBackground
                      ? dark
                            ? WasteColors.dark
                            : WasteColors.light
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: dark
                          ? Colors.white.withOpacity(0.25)
                          : Colors.black.withOpacity(0.25),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadows: [
                    BoxShadow(
                      color: dark
                          ? Colors.white.withOpacity(0.25)
                          : Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Material Distribution',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double size =
                                constraints.maxWidth < constraints.maxHeight
                                ? constraints.maxWidth
                                : constraints.maxHeight;
                            return SizedBox(
                              width: size,
                              height: size,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sections: legendItems.map((item) {
                                        return PieChartSectionData(
                                          color: item['color'] as Color,
                                          value: item['percentage'] as double,
                                          title:
                                              '${(item['percentage'] as double).toStringAsFixed(2)}%',
                                          radius: 50,
                                          titleStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                WasteColors.primaryBackground,
                                          ),
                                        );
                                      }).toList(),
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 3,
                                      centerSpaceRadius: size / 4,
                                      startDegreeOffset: 270,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: WasteSizes.defaultSpace),
                      // Legend Column
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: legendItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: item['color'] as Color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${item['text']}', // Text aligned to the left
                                      style: TextStyle(
                                        color: dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(item['weight'] as double).toStringAsFixed(2)} Kg', // Percentage aligned to the right
                                    style: TextStyle(
                                      color: dark ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: WasteSizes.defaultSpace),
                    ],
                  ),
                ),
              );
            });
          }
        },
      );
    });
  }
}
