import 'package:ewastecare/common/widget/analytic_details_card/admin_analytic_card_verticle.dart';
import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart2.dart';
import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart3.dart';
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
    final service = AdminDashboardService.instance;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched();
          await service.fetchRateMaterials();
          await service.fetchMaterialWeights();
          await service.calculateMaterialWeights();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // ================= HEADER =================
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      title: Row(
                        children: [
                          // Text section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "performanceAnalytics".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: WasteColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  softWrap: true, // Allows wrapping
                                  maxLines:
                                      2, // Prevents it from overflowing too much
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ), // spacing between text and icons
                          // Filter icon
                          IconButton(
                            icon: const Icon(
                              Iconsax.filter,
                              color: WasteColors.white,
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const BottomSheetContent(),
                            ),
                          ),

                          // Download icon
                          IconButton(
                            icon: const Icon(
                              Iconsax.document_download,
                              color: WasteColors.white,
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const DownloadData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),

              const SizedBox(height: WasteSizes.spaceBtwItems),

              // ================= CHART =================
              Obx(() {
                switch (controller.selectedType.value) {
                  case 'userInformation':
                    return const BarGraphUserInformation();
                  case 'materialDistribution':
                    return const PieChartMaterialInformation();
                  default:
                    return const SizedBox();
                }
              }),

              const SizedBox(height: WasteSizes.spaceBtwSections),

              // ================= ANALYTIC CARDS =================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WasteSizes.defaultSpace,
                ),
                child: Obx(() {
                  if (controller.selectedType.value != 'userInformation') {
                    return const SizedBox();
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: WasteSizes.spaceBtwItems,
                    crossAxisSpacing: WasteSizes.spaceBtwItems,
                    childAspectRatio: 1.4,
                    children: [
                      AdminAnalyticCardVertical(
                        title: 'activeUsers'.tr,
                        value: "${service.totalActiveUser.value} Users",
                        icon: Iconsax.people,
                        iconColor: Colors.black,
                        gradientStart: Colors.blueAccent,
                        gradientEnd: Colors.lightBlue,
                      ),
                      AdminAnalyticCardVertical(
                        title: 'topPerformer'.tr,
                        value: service.mostPerformantUsername.value,
                        icon: Iconsax.crown,
                        iconColor: Colors.black,
                        gradientStart: Colors.deepOrange,
                        gradientEnd: Colors.orangeAccent,
                      ),
                      AdminAnalyticCardVertical(
                        title: 'totalWastePoints'.tr,
                        value:
                            "${service.displaySumOfWastePoints.value} Points",
                        icon: Iconsax.star,
                        iconColor: Colors.black,
                        gradientStart: Colors.green,
                        gradientEnd: Colors.lightGreen,
                      ),
                      AdminAnalyticCardVertical(
                        title: 'totalRecycledItems'.tr,
                        value: "${service.displaySumOfAllMaterials.value} Kg",
                        icon: Icons.recycling,
                        iconColor: Colors.black,
                        gradientStart: Colors.purple,
                        gradientEnd: Colors.purpleAccent,
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: WasteSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
