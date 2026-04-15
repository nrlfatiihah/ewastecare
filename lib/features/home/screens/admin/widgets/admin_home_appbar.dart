import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/personalization/controllers/admin_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteAdminHomeAppBar extends StatelessWidget {
  const WasteAdminHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<AdminController>();
    final controller = Get.put(AdminController());
    return WasteAppBar(
      // Adjust the spacing between title and leading widget
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                WasteTexts.userHomeAppbarTitle.tr,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.apply(color: WasteColors.grey),
              ),
              Obx(() {
                if (controller.profileLoading.value) {
                  return const WasteShimmerEffect(width: 80, height: 15);
                } else {
                  return Text(
                    controller.user.value.username,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.apply(color: WasteColors.white),
                  );
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
