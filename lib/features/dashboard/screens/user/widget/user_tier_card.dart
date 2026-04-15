import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TierCard extends StatelessWidget {
  const TierCard({super.key, this.showBackground = true});

  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final controller = Get.find<UserDashboardController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      width: WasteDeviceUtils.getScreenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // Soft Gradient Background
        gradient: showBackground
            ? LinearGradient(
                colors: dark
                    ? [WasteColors.dark, WasteColors.dark.withOpacity(0.85)]
                    : [
                        WasteColors.primary.withOpacity(0.08),
                        WasteColors.primary.withOpacity(0.03),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,

        border: Border.all(
          color: dark
              ? Colors.white.withOpacity(0.15)
              : WasteColors.primary.withOpacity(0.15),
        ),

        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withOpacity(0.4)
                : WasteColors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tier Icon Container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  WasteColors.primary,
                  WasteColors.primary.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: WasteColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Iconsax.award, color: Colors.white, size: 32),
          ),

          const SizedBox(width: 18),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  WasteTexts.yourCurrentTier.tr,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: dark
                        ? Colors.white70
                        : Colors.black.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const WasteShimmerEffect(width: 80, height: 20);
                  } else {
                    return Text(
                      controller.newUserDashboardData.value.tierLevel,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: WasteColors.primary,
                          ),
                    );
                  }
                }),
              ],
            ),
          ),

          // Info Icon with subtle container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dark
                  ? Colors.white.withOpacity(0.05)
                  : WasteColors.primary.withOpacity(0.08),
            ),
            child: Icon(
              Iconsax.info_circle,
              size: 20,
              color: dark ? Colors.white70 : WasteColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
