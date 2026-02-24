import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/common/widget/list_tiles/settings_menu_tile.dart';
import 'package:ewastecare/common/widget/list_tiles/user_profile_tiles.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/features/dashboard/screens/user/user_dashboard.dart';
import 'package:ewastecare/features/personalization/screens/app_information/app_information.dart';
import 'package:ewastecare/features/personalization/screens/policy_n_privacy/policy_n_privacy.dart';
import 'package:ewastecare/features/personalization/screens/profile/profile.dart';
import 'package:ewastecare/features/personalization/screens/terms_n_condition/terms_n_condition.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserSettingScreen extends StatelessWidget {
  const UserSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WastePrimaryHeaderContainer(
              child: Column(
                children: [
                  // appBar
                  WasteAppBar(
                    title: Text(
                      "Account",
                      style: Theme.of(context).textTheme.headlineMedium!.apply(
                        color: WasteColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections / 2),

                  // User Profile card
                  WasteUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen()),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                ],
              ),
            ),

            //body
            Padding(
              padding: const EdgeInsets.all(WasteSizes.defaultSpace),
              child: Column(
                children: [
                  // Account Setting
                  const WasteSectionHeading(
                    title: "Account Settings",
                    showActionButton: false,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),

                  // User Profile Options
                  WasteSettingMenuTile(
                    icon: Iconsax.user,
                    title: "User Profile",
                    subTitle: "Set your profile details",
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),

                  // Redeem Point Options
                  WasteSettingMenuTile(
                    icon: Iconsax.graph,
                    title: "Performance Analytics",
                    subTitle: "View your performance",
                    onTap: () => Get.to(() => const UserDashboardScreen()),
                  ),

                  // Language Options
                  WasteSettingMenuTile(
                    icon: Iconsax.language_square,
                    title: "Language",
                    subTitle: "Set your preferred language",
                    onTap: () {},
                  ),

                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  const WasteSectionHeading(
                    title: "About App",
                    showActionButton: false,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),

                  // Terms & Conditions Options
                  WasteSettingMenuTile(
                    icon: Iconsax.document,
                    title: "Terms & Conditions",
                    subTitle:
                        "Details of terms & conditions of the application",
                    onTap: () => Get.to(() => const TermsNConditionScreen()),
                  ),

                  // Policy & Privacy Options
                  WasteSettingMenuTile(
                    icon: Iconsax.shield_tick,
                    title: "Policy & Privacy",
                    subTitle: "Details of privacy & policy of the application",
                    onTap: () => Get.to(() => const PolicyNPrivacyScreen()),
                  ),

                  //App Information Options
                  WasteSettingMenuTile(
                    icon: Iconsax.info_circle,
                    title: "App Information",
                    subTitle: "Details information about the application",
                    onTap: () => Get.to(() => const AppInformationScreen()),
                  ),

                  //Logout Button
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          AuthenticationRepository.instance.logout(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: WasteColors.buttonPrimary,
                        ),
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
