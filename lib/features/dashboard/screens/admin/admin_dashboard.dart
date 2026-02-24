import 'package:ewastecare/common/widget/analytic_details_card/admin_analytic_card_verticle.dart';
import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart3.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart2.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/filter_date.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/filter_download.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdminDashboardController.instance;
    final controller2 = AdminDashboardService.instance;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched(); // Reset dataFetched flag
          // await controller.fetchAdminDashboardData();
          // await controller.fetchAdminDashboardDataByFilterDate();
          await controller2.fetchRateMaterials();
          await controller2.fetchMaterialWeights();
          await controller2.calculateMaterialWeights();
          // await controller2.calculateWeights();
          // await controller2._processMaterialData();
          // await controller2.fetchUserStatistics();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Performance Analytics",
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .apply(color: WasteColors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: WasteSizes.inputFieldRadius),
                          IconButton(
                            icon: const Icon(
                              Iconsax.filter,
                              color: WasteColors.white,
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => const BottomSheetContent(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Iconsax.document_download,
                              color: WasteColors.white,
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => const DownloadData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems / 2),
              // Conditionally show either BarGraphPlasticInformation or BarGraphUserInformation
              Obx(() {
                // if (controller.selectedType.value == "Plastic Collection") {
                //   return const BarGraphPlasticInformation();
                // }
                if (controller.selectedType.value == "User Information") {
                  return const BarGraphUserInformation();
                } else if (controller.selectedType.value ==
                    "Materials Distribution") {
                  return const PieChartMaterialInformation();
                } else {
                  return const SizedBox(); // Fallback if none matched
                }
              }),
              const SizedBox(height: WasteSizes.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() {
                          // if (controller.selectedType.value ==
                          //     "Plastic Collection") {
                          //   return AdminAnalyticCardVertical(
                          //     title: 'PP',
                          //     value: "${controller.totalTypePPSum.value} Kg",
                          //   );
                          // }
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: 'Active User',
                              value:
                                  "${controller2.totalActiveUser.value} User",
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Obx(() {
                          // if (controller.selectedType.value ==
                          //     "Plastic Collection") {
                          //   return AdminAnalyticCardVertical(
                          //     title: 'PET',
                          //     value: "${controller.totalTypePETSum.value} Kg",
                          //   );
                          // }
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: 'Top Performer',
                              value: controller2.mostPerformantUsername.value,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() {
                          // if (controller.selectedType.value ==
                          //     "Plastic Collection") {
                          //   return AdminAnalyticCardVertical(
                          //     title: 'HDPE',
                          //     value: "${controller.totalTypeHDPESum.value} Kg",
                          //   );
                          // }
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: 'Total Waste Points',
                              value:
                                  // "${controller.totalGeneratedPoint.value} Points",
                                  "${controller2.displaySumOfWastePoints.value} Points",
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Obx(() {
                          // if (controller.selectedType.value ==
                          //     "Plastic Collection") {
                          //   return AdminAnalyticCardVertical(
                          //     title: 'Total Recycled Plastic',
                          //     value:
                          //         "${controller.totalAllPlasticOverallSum.value} Kg",
                          //   );
                          // }
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: 'Total Recycled Item',
                              value:
                                  "${controller2.displaySumOfAllMaterials.value} Kg",
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
