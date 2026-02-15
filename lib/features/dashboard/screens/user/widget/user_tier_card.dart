import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/features/dashboard/controllers/user_dashboard_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
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
      width: WasteDeviceUtils.getScreenWidth(context),
      height: 113,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
                child: Container(
                  color: dark
                      ? Colors.grey[800]
                      : Colors.grey[200], // optional background color
                  child: Icon(
                    Iconsax.award, // change this to the desired icon
                    size: 40, // adjust the icon size if needed
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Current Tier',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const WasteShimmerEffect(width: 10, height: 10);
                  } else {
                    return Text(
                      controller.newUserDashboardData.value.tierLevel,
                      style: Theme.of(context).textTheme.headlineMedium!,
                    );
                  }
                }),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Iconsax.info_circle),
            ),
          ),
        ],
      ),
    );
  }
}
