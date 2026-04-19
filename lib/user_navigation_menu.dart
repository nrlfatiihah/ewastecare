import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/features/personalization/screens/settings/settings.dart';
import 'package:ewastecare/features/home/screens/user/home.dart';
import 'package:ewastecare/features/module/screens/user/user_module.dart';
import 'package:ewastecare/features/store/screens/admin/store/user_store.dart';
import 'package:ewastecare/features/waste_detection/waste_detactor.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:ewastecare/utils/popups/logout_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserNavigationMenu extends StatelessWidget {
  const UserNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserNavigationController());
    final darkMode = WasteHelperFunctions.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) async {
        if (didPop) return;

        bool shouldLogout = await DialogUtils.showLogoutConfirmationDialog(
          context,
        );
        if (shouldLogout) {
          AuthenticationRepository.instance.logout();
        }
      }),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 85, // taller for better touch targets
            elevation: 5,
            backgroundColor: darkMode ? WasteColors.black : Colors.white,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            indicatorColor: darkMode
                ? WasteColors.primary.withOpacity(0.15)
                : WasteColors.buttonPrimary.withOpacity(0.15),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            surfaceTintColor: Colors.transparent,
            destinations: [
              NavigationDestination(
                icon: Icon(Iconsax.home, size: 26),
                selectedIcon: Icon(
                  Iconsax.home,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.homeNav.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.teacher, size: 26),
                selectedIcon: Icon(
                  Iconsax.teacher,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.module.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.scan, size: 26),
                selectedIcon: Icon(
                  Iconsax.scan,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.scan.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.shop, size: 26),
                selectedIcon: Icon(
                  Iconsax.shop,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.store.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.user, size: 26),
                selectedIcon: Icon(
                  Iconsax.user,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.profile.tr,
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class UserNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const UserHomeScreen(),
    UserModuleScreen(),
    const WasteDetectorPage(),
    const UserStoreScreen(),
    const UserSettingScreen(),
  ];
}
