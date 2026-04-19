import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_dashboard.dart';
import 'package:ewastecare/features/waste_point/waste_point_allocation.dart';
import 'package:ewastecare/features/home/screens/admin/admin_home.dart';
import 'package:ewastecare/features/store/screens/admin/store/admin_store.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:ewastecare/utils/popups/logout_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminNavigationMenu extends StatelessWidget {
  final int selectedIndex;

  const AdminNavigationMenu({
    Key? key,
    this.selectedIndex = 0, // default = Home
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController());

    // Set initial index when widget builds
    controller.setIndex(selectedIndex);

    final darkMode = WasteHelperFunctions.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) async {
        if (didPop) return;

        bool shouldLogout = await DialogUtils.showLogoutConfirmationDialog(
          context,
        );

        if (shouldLogout) {
          AdminAuthenticationRepository.instance.logout();
        }
      }),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 85, // slightly taller
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
                icon: Icon(Iconsax.shop, size: 26),
                selectedIcon: Icon(
                  Iconsax.shop,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.store.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.status_up, size: 26),
                selectedIcon: Icon(
                  Iconsax.status_up,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.analytics.tr,
              ),
              NavigationDestination(
                icon: Icon(Iconsax.wallet_add_1, size: 26),
                selectedIcon: Icon(
                  Iconsax.wallet_add_1,
                  color: WasteColors.buttonPrimary,
                  size: 28,
                ),
                label: WasteTexts.allocate.tr,
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class AdminNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  final screens = [
    const AdminHomeScreen(), // index 0
    const AdminStoreScreen(), // index 1
    const AdminDashboardScreen(), // index 2
    const PointAllocationScreen(), // index 3
  ];
}
