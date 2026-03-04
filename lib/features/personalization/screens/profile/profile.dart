import 'package:ewastecare/common/widget/appbar/appbar.dart';
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
      appBar: const WasteAppBar(showBackArrow: true, title: Text("Profile")),
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
                      child: const Text("Change Profile Picture"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Profile Info Section
              const WasteSectionHeading(
                title: "Profile Information",
                showActionButton: false,
              ),
              const SizedBox(height: 16),

              Obx(
                () => WasteProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeName()),
                  icon: Iconsax.edit,
                ),
              ),
              Obx(
                () => WasteProfileMenu(
                  title: 'Username',
                  value: controller.user.value.username,
                  onPressed: () => Get.to(() => const ChangeUserName()),
                  icon: Iconsax.edit,
                ),
              ),
              WasteProfileMenu(
                title: 'UserID',
                value: controller.user.value.id,
                icon: Iconsax.lock,
                onPressed: () {},
              ),

              const SizedBox(height: 32),

              // Personal Info Section
              const WasteSectionHeading(
                title: "Personal Information",
                showActionButton: false,
              ),
              const SizedBox(height: 16),

              Obx(
                () => WasteProfileMenu(
                  title: 'Address',
                  value: controller.user.value.homeAddress,
                  onPressed: () => Get.to(() => const ChangeHomeAddress()),
                  icon: Iconsax.edit,
                ),
              ),
              WasteProfileMenu(
                title: 'Gender',
                value: controller.user.value.gender,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: "Oops!",
                    message: "Sorry this detail cannot be edited",
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: 'Age',
                value: controller.user.value.age,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: "Oops!",
                    message: "Sorry this detail cannot be edited",
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: 'Email',
                value: controller.user.value.email,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: "Oops!",
                    message: "Sorry this detail cannot be edited",
                  );
                },
                icon: Iconsax.lock,
              ),
              WasteProfileMenu(
                title: 'Phone Number',
                value: controller.user.value.phoneNo,
                onPressed: () {
                  WasteLoaders.cannotEdit(
                    title: "Oops!",
                    message: "Sorry this detail cannot be edited",
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
                  label: const Text(
                    "Delete Account",
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
