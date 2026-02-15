import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/ecobako_point/screen/recycle_rate.dart';
import 'package:ewastecare/features/home/controllers/admin_setting_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AdminEndDrawer extends StatelessWidget {
  final AdminSettingsController _controller = AdminSettingsController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Admin Menu',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  decoration: BoxDecoration(color: WasteColors.primary),
                ),
                ListTile(
                  title: Text('Recycle Rate'),
                  onTap: () async {
                    bool isVerified = await _controller
                        .verifyRecycleRatePassword(context);
                    if (isVerified) {
                      Navigator.pop(
                        context,
                      ); // Close the drawer only if verification is successful
                      Future.delayed(Duration.zero, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecycleRate(),
                          ),
                        );
                      });
                    }
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () => AdminAuthenticationRepository.instance.logout(),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red, // Red background color
                side: BorderSide(color: Colors.red), // Red outline
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 25,
                ), // Padding inside the button
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white), // Text color (white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
