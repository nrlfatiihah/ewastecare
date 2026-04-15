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
import 'package:ewastecare/translations/app_translations.dart';
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
                      "account".tr,
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
                  WasteSectionHeading(
                    title: "account_settings".tr,
                    showActionButton: false,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),

                  // User Profile Options
                  WasteSettingMenuTile(
                    icon: Iconsax.user,
                    title: "user_profile".tr,
                    subTitle: "set_your_profile_details".tr,
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),

                  // Redeem Point Options
                  WasteSettingMenuTile(
                    icon: Iconsax.graph,
                    title: "performance_analytics".tr,
                    subTitle: "view_your_performance".tr,
                    onTap: () => Get.to(() => const UserDashboardScreen()),
                  ),

                  // Language Options
                  WasteSettingMenuTile(
                    icon: Iconsax.language_square,
                    title: "language".tr,
                    subTitle: "set_preferred_language".tr,
                    onTap: () => Get.bottomSheet(
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "select_language".tr,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: Text("english".tr),
                              trailing: Get.locale?.languageCode == 'en'
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                              onTap: () {
                                AppTranslations.changeLocale(
                                  const Locale('en', 'US'),
                                );
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("bahasa_malaysia".tr),
                              trailing: Get.locale?.languageCode == 'ms'
                                  ? Icon(
                                      Icons.check,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  : null,
                              onTap: () {
                                AppTranslations.changeLocale(
                                  const Locale('ms', 'MY'),
                                );
                                Get.back();
                              },
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: Get.back,
                                child: Text(
                                  "cancel".tr,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isDismissible: true,
                    ),
                  ),

                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  WasteSectionHeading(
                    title: "about_app".tr,
                    showActionButton: false,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwItems),

                  // Terms & Conditions Options
                  WasteSettingMenuTile(
                    icon: Iconsax.document,
                    title: "terms_conditions".tr,
                    subTitle: "details_of_terms".tr,
                    onTap: () => Get.to(() => const TermsNConditionScreen()),
                  ),

                  // Policy & Privacy Options
                  WasteSettingMenuTile(
                    icon: Iconsax.shield_tick,
                    title: "policy_privacy".tr,
                    subTitle: "details_of_privacy".tr,
                    onTap: () => Get.to(() => const PolicyNPrivacyScreen()),
                  ),

                  //App Information Options
                  WasteSettingMenuTile(
                    icon: Iconsax.info_circle,
                    title: "app_information".tr,
                    subTitle: "details_of_app_information".tr,
                    onTap: () => Get.to(() => const AppInformationScreen()),
                  ),

                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          AuthenticationRepository.instance.logout(),
                      icon: const Icon(Iconsax.logout, color: Colors.white),
                      label: Text(
                        "logout".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.red,
                      ), // subtle red background
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
