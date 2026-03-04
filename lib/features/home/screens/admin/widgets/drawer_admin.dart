import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/waste_point/screen/recycle_rate.dart';
import 'package:ewastecare/features/home/controllers/admin_setting_controller.dart';
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
                    "Admin Panel",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Manage system settings",
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
                    title: "Recycle Rate",
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
                  label: const Text("Logout"),
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
