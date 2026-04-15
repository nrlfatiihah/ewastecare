import 'package:flutter/material.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_tier_card.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_chart.dart';
import 'package:get/get.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserDashboardController.instance;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched();
          await controller.NewfetchUserRecord();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      showBackArrow: true,
                      title: Transform.translate(
                        offset: const Offset(-12, 0),
                        child: Text(
                          WasteTexts.performanceAnalytics.tr,
                          style: Theme.of(context).textTheme.headlineMedium!
                              .apply(color: WasteColors.white),
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WasteSizes.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: WasteSizes.spaceBtwSections),

                    // Section Title
                    Text(
                      WasteTexts.yourAchievement.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: WasteSizes.spaceBtwItems),

                    // Tier Card
                    const TierCard(),

                    const SizedBox(height: WasteSizes.spaceBtwSections),

                    // Chart Section Title
                    Text(
                      WasteTexts.recyclingPerformance.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: WasteSizes.spaceBtwItems),

                    // Chart Card Wrapper
                    Container(child: const PieChartProgressIndicator()),

                    const SizedBox(height: WasteSizes.spaceBtwSections * 1.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
