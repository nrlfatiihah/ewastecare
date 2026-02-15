import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarGraphUserInformation extends StatelessWidget {
  const BarGraphUserInformation({super.key, this.showBackground = true});

  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final controller = AdminDashboardController.instance;
    final controller2 = AdminDashboardService.instance;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
                'User Infromation',
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
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const WasteShimmerEffect(width: 10, height: 10);
                      } else {
                        // final adminDashboard =
                        //     controller.adminDashboardData.value;
                        // final adminDashboardData = controller.adminDashboardData2.value;
                        // final male =
                        //     controller.maleUsers.value;
                        // final female = controller.femaleUsers.value;
                        final male = controller2.maleUsers.value;
                        final female = controller2.femaleUsers.value;

                        // Calculate the maximum value
                        final maxY = [
                          male,
                          female,
                        ].reduce((a, b) => a > b ? a : b);

                        return BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                        const style = TextStyle(
                                          color: WasteColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        );
                                        String text;
                                        switch (value.toInt()) {
                                          case 0:
                                            text = 'Male';
                                            break;
                                          case 1:
                                            text = 'Female';
                                            break;
                                          default:
                                            text = '';
                                            break;
                                        }
                                        return SideTitleWidget(
                                          meta: meta,
                                          space: 4,
                                          child: Text(text, style: style),
                                        );
                                      },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: male.toDouble(),
                                    // toY: adminDashboard.pp,
                                    gradient: const LinearGradient(
                                      colors: [
                                        WasteColors.secondary,
                                        WasteColors.primary,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: female.toDouble(),
                                    // toY: adminDashboard.pet,
                                    gradient: const LinearGradient(
                                      colors: [
                                        WasteColors.secondary,
                                        WasteColors.primary,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              ),
                            ],
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY * 2,
                          ),
                        );
                      }
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: WasteSizes.defaultSpace),
          ],
        ),
      ),
    );
  }
}
