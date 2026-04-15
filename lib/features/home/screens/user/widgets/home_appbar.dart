import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/images/waste_circular_image.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteHomeAppBar extends StatelessWidget {
  const WasteHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
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
          Obx(() {
            final networkImage = controller.user.value.profilePicture;
            final image = networkImage.isNotEmpty
                ? networkImage
                : WasteImages.userImage;
            return controller.imageUploading.value
                ? const WasteShimmerEffect(width: 80, height: 80, radius: 80)
                : WasteCircularImage(
                    image: image,
                    width: 50,
                    height: 50,
                    isNetworkImage: networkImage.isNotEmpty,
                  );
          }),
          // const WasteCircularImage(
          //   image: WasteImages.userImage,
          //   width: 50,
          //   height: 50,
          //   padding: 0,
          // ),
        ],
      ),
    );
  }
}
