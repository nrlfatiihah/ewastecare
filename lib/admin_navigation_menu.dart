import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_dashboard.dart';
import 'package:ewastecare/features/waste_point/waste_point_allocation.dart';
import 'package:ewastecare/features/home/screens/admin/admin_home.dart';
import 'package:ewastecare/features/store/screens/admin/store/admin_store.dart';
import 'package:ewastecare/utils/constants/colors.dart';
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

    // 🔥 Set initial index when widget builds
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
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: darkMode ? WasteColors.black : Colors.white,
            indicatorColor: darkMode
                ? WasteColors.white.withOpacity(0.1)
                : WasteColors.black.withOpacity(0.1),
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
              NavigationDestination(icon: Icon(Iconsax.shop), label: "Store"),
              NavigationDestination(
                icon: Icon(Iconsax.status_up),
                label: "Analytics",
              ),
              NavigationDestination(
                icon: Icon(Iconsax.wallet_add_1),
                label: "Allocate",
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
