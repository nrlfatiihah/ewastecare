// use and checked
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/device/device_utility.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WastePointContainer extends StatelessWidget {
  const WastePointContainer({
    super.key,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.textColor,
  });

  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final controller = Get.find<UserController>();
    //final controller = Get.find();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WasteSizes.defaultSpace,
        ),
        child: Container(
          width: WasteDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(WasteSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                      ? WasteColors.dark
                      : WasteColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(WasteSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: WasteColors.grey) : null,
          ),
          child: Column(
            children: [
              Text(
                "Waste Points",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),
              // Text(point,style: Theme.of(context).textTheme.headlineLarge),
              Obx(() {
                if (controller.profileLoading.value) {
                  return const WasteShimmerEffect(width: 100, height: 100);
                } else {
                  return Text(
                    controller.user.value.ecoPoint.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge!.apply(color: textColor),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
