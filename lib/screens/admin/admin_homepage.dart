import 'package:ewastecare/widgets/analytics_details_card/admin_analytic_card_vertical.dart';
import 'package:ewastecare/controllers/admin_dashboard_controller.dart';
import 'package:ewastecare/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/screens/admin/widget/admin_dashboard_chart2.dart';
import 'package:ewastecare/screens/admin/widget/admin_dashboard_chart3.dart';
import 'package:ewastecare/screens/admin/widget/filter_date.dart';
import 'package:ewastecare/screens/admin/widget/filter_download.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/widgets/appbar/appbar.dart';
import 'package:ewastecare/widgets/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/constants/colors.dart';
import 'package:ewastecare/constants/sizes.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdminHomePageController.instance;
    final controller2 = AdminHomePageService.instance;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched();
          await controller2.fetchRateMaterials();
          await controller2.fetchMaterialWeights();
          await controller2.calculateMaterialWeights();
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
                          Text(
                            "Performance Analytics",
                            style: Theme.of(context).textTheme.headlineMedium!
                                .apply(color: WasteColors.white),
                          ),
                          const SizedBox(width: WasteSizes.inputFieldRadius),
                          IconButton(
                            icon: const Icon(
                              Iconsax.filter,
                              color: WasteColors.white,
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) => const BotoomSheetContent(),
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
              const SizedBox(height: WasteSizes.SpaceBtwItems / 2),
              Obx(() {
                if (collecter.selectedType.value == "User Information") {
                  return const BarGraphUserInformation();
                } else if (controller.selectedType.value ==
                    "Materials Distribution") {
                  return const PieChartMaterialsDistribution();
                } else {
                  return const SizedBox();
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
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: "Total Users",
                              value: "${controller2.totalUsers.value} Users",
                              icon: Iconsax.user,
                              color: WasteColors.primaryGreen,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Obx(() {
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: "Top Performer",
                              value: controller2.mostPerformanceUsername.value,
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
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: "Total Points",
                              value:
                                  "${controller2.displaySumOfTotalPoints.value} Points",
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        Obx(() {
                          if (controller.selectedType.value ==
                              "User Information") {
                            return AdminAnalyticCardVertical(
                              title: "Total Recycled Item",
                              value:
                                  "${controller2.displaySumOfAllMaterial.value} kg",
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
