import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/images/bako_circular_image.dart';
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
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? networkImage
                          : WasteImages.userImage;
                      return controller.imageUploading.value
                          ? const WasteShimmerEffect(
                              width: 80,
                              height: 80,
                              radius: 80,
                            )
                          : WasteCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text("Change Profile Picture"),
                    ),
                  ],
                ),
              ),

              //Details
              const SizedBox(height: WasteSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: WasteSizes.spaceBtwItems),
              const WasteSectionHeading(
                title: "Profile Information",
                showActionButton: false,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Obx(() {
                return WasteProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeName()),
                  icon: Iconsax.edit,
                );
              }),
              Obx(() {
                return WasteProfileMenu(
                  title: 'Username',
                  value: controller.user.value.username,
                  onPressed: () => Get.to(() => const ChangeUserName()),
                  icon: Iconsax.edit,
                );
              }),
              WasteProfileMenu(
                title: 'UserID',
                value: controller.user.value.id,
                icon: Iconsax.lock,
                onPressed: () {},
              ),

              const SizedBox(height: WasteSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              const WasteSectionHeading(
                title: "Personal Information",
                showActionButton: false,
              ),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Obx(() {
                return WasteProfileMenu(
                  title: 'Address',
                  value: controller.user.value.homeAddress,
                  onPressed: () => Get.to(() => const ChangeHomeAddress()),
                  icon: Iconsax.edit,
                );
              }),
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

              const Divider(),
              const SizedBox(height: WasteSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
