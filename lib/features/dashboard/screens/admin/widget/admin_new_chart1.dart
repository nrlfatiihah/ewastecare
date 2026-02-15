import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart3.dart';
import 'package:flutter/material.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';

class TestPeiScreen extends StatelessWidget {
  const TestPeiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserDashboardController.instance;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched(); // Reset dataFetched flag
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
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
              // const TierCard(),
              const SizedBox(height: WasteSizes.spaceBtwItems / 2),
              Padding(padding: const EdgeInsets.all(WasteSizes.defaultSpace)),
              const SizedBox(height: WasteSizes.spaceBtwItems),
              const PieChartMaterialInformation(),
              const SizedBox(height: WasteSizes.spaceBtwSections),
              // const AdminSegmentInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
