import 'package:flutter/material.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/models/new_user_dashboard_model.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_chart.dart';
import 'package:ewastecare/features/dashboard/screens/user/widget/user_tier_card.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:get/get.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserDashboardController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WasteSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  Text(
                    WasteTexts.yourAchievement.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                  const TierCard(),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  Text(
                    WasteTexts.recyclingPerformance.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                  const PieChartProgressIndicator(),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  Text(
                    WasteTexts.materialDistributionTitle.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),
                  Obx(() {
                    final dashboard = controller.newUserDashboardData.value;
                    final materialTotals = dashboard.getMaterialGroupTotals();

                    if (materialTotals.isEmpty) {
                      return _buildEmptyDistributionCard(context);
                    }

                    return _buildMaterialDistributionCard(
                      context: context,
                      dashboard: dashboard,
                      materialTotals: materialTotals,
                    );
                  }),
                  const SizedBox(height: WasteSizes.spaceBtwSections * 1.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialDistributionCard({
    required BuildContext context,
    required NewUserDashboardModel dashboard,
    required Map<String, double> materialTotals,
  }) {
    final totalMaterialWeight = dashboard.totalWeightAllMaterials;
    final topEntry = materialTotals.entries.isNotEmpty
        ? materialTotals.entries.first
        : null;

    return Container(
      padding: const EdgeInsets.all(WasteSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WasteColors.primary.withOpacity(0.14),
            Theme.of(context).cardColor,
            Theme.of(context).cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WasteColors.primary.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: WasteColors.primary.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      WasteColors.primary,
                      WasteColors.primary.withOpacity(0.72),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.recycling_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      WasteTexts.materialDistributionTitle.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      WasteTexts.materialDistributionSubtitle.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: WasteColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: _buildDistributionStatCard(
                  context: context,
                  label: WasteTexts.totalWeight.tr,
                  value: '${totalMaterialWeight.toStringAsFixed(1)} Kg',
                  icon: Icons.monitor_weight_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDistributionStatCard(
                  context: context,
                  label: WasteTexts.materialTypes.tr,
                  value: '${materialTotals.length}',
                  icon: Icons.category_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
          if (topEntry != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.65)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _materialColor(0).withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_fire_department_outlined,
                      color: _materialColor(0),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          WasteTexts.topMaterial.tr,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: WasteColors.darkGrey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          topEntry.key,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${dashboard.getMaterialDistributionPercentage(topEntry.key).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                      color: WasteColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
          ...materialTotals.entries.toList().asMap().entries.map((indexed) {
            final index = indexed.key;
            final entry = indexed.value;
            final total = entry.value;
            final percentage = dashboard.getMaterialDistributionPercentage(
              entry.key,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: WasteSizes.spaceBtwItems),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _materialColor(index),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _materialColor(index).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: _materialColor(index),
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 11,
                      backgroundColor: WasteColors.darkGrey.withOpacity(0.10),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _materialColor(index),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${total.toStringAsFixed(2)} Kg',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: WasteColors.darkGrey,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}% of total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: WasteColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDistributionStatCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WasteColors.white.withOpacity(0.65)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: WasteColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: WasteColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: WasteColors.darkGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _materialColor(int index) {
    const palette = [
      WasteColors.primary,
      WasteColors.success,
      WasteColors.info,
      WasteColors.warning,
      WasteColors.secondary,
      WasteColors.accent,
    ];

    return palette[index % palette.length];
  }

  Widget _buildEmptyDistributionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(WasteSizes.defaultSpace),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WasteColors.primary.withOpacity(0.10),
            Theme.of(context).cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WasteColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: WasteColors.primary.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.incomplete_circle_outlined,
              color: WasteColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WasteTexts.noMaterialDistributionYet.tr,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  WasteTexts.materialDistributionEmptyMessage.tr,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: WasteColors.darkGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
