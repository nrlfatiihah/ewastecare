import 'package:get/get.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/features/waste_point/screen/recycle_rate.dart';
import 'package:ewastecare/features/home/controllers/admin_setting_controller.dart';
import 'package:ewastecare/translations/app_translations.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AdminEndDrawer extends StatelessWidget {
  AdminEndDrawer({super.key});

  final AdminSettingsController _controller = AdminSettingsController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WasteColors.primary,
                    WasteColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 35,
                      color: WasteColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    WasteTexts.adminPanel.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    WasteTexts.manageSystemSettings.tr,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // ===== MENU ITEMS =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildMenuTile(
                    context,
                    icon: Icons.recycling,
                    title: WasteTexts.recycleRate.tr,
                    onTap: () async {
                      bool isVerified = await _controller
                          .verifyRecycleRatePassword(context);

                      if (isVerified) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecycleRate(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildMenuTile(
                    context,
                    icon: Icons.language,
                    title: 'language'.tr,
                    onTap: () => _showLanguageSheet(context),
                  ),

                  const SizedBox(height: 10),
                  const Divider(indent: 20, endIndent: 20),
                ],
              ),
            ),

            // ===== LOGOUT BUTTON =====
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      AdminAuthenticationRepository.instance.logout(),
                  icon: const Icon(Icons.logout),
                  label: Text(WasteTexts.logout.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    Get.bottomSheet(
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
              'select_language'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('english'.tr),
              trailing: Get.locale?.languageCode == 'en'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                AppTranslations.changeLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('bahasa_malaysia'.tr),
              trailing: Get.locale?.languageCode == 'ms'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                AppTranslations.changeLocale(const Locale('ms', 'MY'));
                Get.back();
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: Get.back,
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  /// ===== Reusable Menu Tile =====
  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: WasteColors.primary),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
