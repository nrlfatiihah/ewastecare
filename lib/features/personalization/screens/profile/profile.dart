import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/common/widget/images/waste_circular_image.dart';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/features/personalization/screens/profile/widget/change_homeaddress.dart';
import 'package:ewastecare/features/personalization/screens/profile/widget/change_name.dart';
import 'package:ewastecare/features/personalization/screens/profile/widget/change_username.dart';
import 'package:ewastecare/features/personalization/screens/profile/widget/profile_menu.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/common/widget/shimmers/shimmer.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.profile.tr),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched();
          await controller.fetchUserRecord();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? networkImage
                          : WasteImages.userImage;

                      return controller.imageUploading.value
                          ? const WasteShimmerEffect(
                              width: 90,
                              height: 90,
                              radius: 90,
                            )
                          : WasteCircularImage(
                              image: image,
                              width: 90,
                              height: 90,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                    }),

                    const SizedBox(height: 12),

                    Obx(
                      () => Text(
                        controller.user.value.fullName,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Obx(
                      () => Text(
                        controller.user.value.email,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: Text(WasteTexts.changeProfilePicture.tr),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Profile Info Section
              WasteSectionHeading(
                title: WasteTexts.profileInformation.tr,
                showActionButton: false,
              ),
              const SizedBox(height: 16),

              Obx(
                () => WasteProfileMenu(
                  title: WasteTexts.profileName.tr,
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeName()),
                  icon: Iconsax.edit,
                ),
              ),
              Obx(
                () => WasteProfileMenu(
                  title: WasteTexts.profileUsername.tr,
                  value: controller.user.value.username,
                  onPressed: () => Get.to(() => const ChangeUserName()),
                  icon: Iconsax.edit,
                ),
              ),
              WasteProfileMenu(
                title: WasteTexts.userID.tr,
                value: controller.user.value.id,
                icon: Iconsax.lock,
                onPressed: () {},
              ),

              const SizedBox(height: 32),

              // Personal Info Section
              WasteSectionHeading(
                title: WasteTexts.personalInformation.tr,
                showActionButton: false,
              ),
              const SizedBox(height: 16),

              Obx(
                () => WasteProfileMenu(
                  title: WasteTexts.address.tr,
                  value: controller.user.value.homeAddress,
                  onPressed: () => Get.to(() => const ChangeHomeAddress()),
                  icon: Iconsax.edit,
                ),
              ),
              WasteProfileMenu(
                title: WasteTexts.gender.tr,
                value: controller.user.value.gender,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: WasteTexts.oops.tr,
                    message: WasteTexts.cannotEditDetail.tr,
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: WasteTexts.dateOfBirth.tr,
                value: controller.user.value.dateOfBirth,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: WasteTexts.oops.tr,
                    message: WasteTexts.cannotEditDetail.tr,
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: WasteTexts.email.tr,
                value: controller.user.value.email,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: WasteTexts.oops.tr,
                    message: WasteTexts.cannotEditDetail.tr,
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: WasteTexts.phoneNo.tr,
                value: controller.user.value.phoneNo,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: WasteTexts.oops.tr,
                    message: WasteTexts.cannotEditDetail.tr,
                  );
                },
                icon: Iconsax.lock,
              ),

              const SizedBox(height: 40),

              // Delete Button (More Premium)
              Center(
                child: TextButton.icon(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  icon: const Icon(Iconsax.trash, color: Colors.red),
                  label: Text(
                    WasteTexts.deleteAccount.tr,
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
