import 'package:flutter/material.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_tier_card.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_chart.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserDashboardController.instance;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched(); // Reset dataFetched flag
          // await controller.fetchUserRecord();
          await controller.NewfetchUserRecord();
          // await controller.fetchTransactions(); // Fetch user record again
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      showBackArrow: true,
                      title: Text(
                        "Performance Analytics",
                        style: Theme.of(context).textTheme.headlineMedium!
                            .apply(color: WasteColors.white),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems / 2),
              const TierCard(),
              const SizedBox(height: WasteSizes.spaceBtwItems / 2),
              const SizedBox(height: WasteSizes.spaceBtwItems),
              const PieChartProgressIndicator(),
              const SizedBox(height: WasteSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
