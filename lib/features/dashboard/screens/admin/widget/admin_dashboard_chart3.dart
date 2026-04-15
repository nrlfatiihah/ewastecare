import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/utils/constants/colors.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Obx(() {
              // Prepare legend items
              final List<Map<String, dynamic>> legendItems = [
                {
                  'color': WasteColors.primary,
                  'text': 'Plastic',
                  'percentage':
                      adminDashboardService
                          .materialGroupPercentages['Plastic'] ??
                      0.0,
                  'weight':
                      adminDashboardService.materialGroupWeights['Plastic'] ??
                      0.0,
                },
                {
                  'color': Colors.cyan,
                  'text': 'Paper',
                  'percentage':
                      adminDashboardService.materialGroupPercentages['Paper'] ??
                      0.0,
                  'weight':
                      adminDashboardService.materialGroupWeights['Paper'] ??
                      0.0,
                },
                {
                  'color': Colors.orange,
                  'text': 'Can',
                  'percentage':
                      adminDashboardService.materialGroupPercentages['Can'] ??
                      0.0,
                  'weight':
                      adminDashboardService.materialGroupWeights['Can'] ?? 0.0,
                },
                {
                  'color': Colors.purple,
                  'text': 'Used Oil',
                  'percentage':
                      adminDashboardService
                          .materialGroupPercentages['Used Oil'] ??
                      0.0,
                  'weight':
                      adminDashboardService.materialGroupWeights['Used Oil'] ??
                      0.0,
                },
                {
                  'color': WasteColors.error,
                  'text': 'Others',
                  'percentage':
                      adminDashboardService
                          .materialGroupPercentages['Others'] ??
                      0.0,
                  'weight':
                      adminDashboardService.materialGroupWeights['Others'] ??
                      0.0,
                },
              ];

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                padding: const EdgeInsets.all(16),
                width: WasteDeviceUtils.getScreenWidth(context),
                decoration: BoxDecoration(
                  color: showBackground
                      ? dark
                            ? WasteColors.dark
                            : WasteColors.light
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: dark
                        ? Colors.white.withOpacity(0.25)
                        : Colors.black.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'materialDistribution'.tr,
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pie chart
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double size =
                            constraints.maxWidth < constraints.maxHeight
                            ? constraints.maxWidth
                            : constraints.maxHeight;
                        return SizedBox(
                          width: size,
                          height: size,
                          child: PieChart(
                            PieChartData(
                              sections: legendItems.map((item) {
                                return PieChartSectionData(
                                  color: item['color'] as Color,
                                  value: item['percentage'] as double,
                                  title:
                                      '${(item['percentage'] as double).toStringAsFixed(1)}%',
                                  radius: 60,
                                  titleStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: WasteColors.primaryBackground,
                                  ),
                                );
                              }).toList(),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 4,
                              centerSpaceRadius: size / 4,
                              startDegreeOffset: 270,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Legend
                    Column(
                      children: legendItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${item['text']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: dark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                '${(item['weight'] as double).toStringAsFixed(2)} Kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: dark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            });
          }
        },
      );
    });
  }
}
