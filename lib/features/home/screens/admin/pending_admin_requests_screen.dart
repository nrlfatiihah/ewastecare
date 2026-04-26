import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_repository.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingAdminRequestsScreen extends StatelessWidget {
  const PendingAdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.put(AdminRepository());

    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(
          'Pending Admin Requests',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: repository.pendingAdminRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text('No pending admin requests right now.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(WasteSizes.defaultSpace),
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: WasteSizes.spaceBtwItems),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final username = (data['Username'] ?? 'New admin').toString();
              final email = (data['Email'] ?? '').toString();
              final profilePicture = (data['ProfilePicture'] ?? '').toString();

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: WasteColors.primary.withOpacity(
                              0.15,
                            ),
                            backgroundImage: profilePicture.isNotEmpty
                                ? NetworkImage(profilePicture)
                                : null,
                            child: profilePicture.isEmpty
                                ? const Icon(
                                    Icons.admin_panel_settings,
                                    color: WasteColors.primary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: WasteSizes.spaceBtwItems),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email.isEmpty ? 'No email provided' : email,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: WasteSizes.spaceBtwItems),
                      Text(
                        'This admin account is waiting for your approval.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: WasteSizes.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await repository.approveAdminRequest(doc.id);
                              WasteLoaders.successSnackBar(
                                title: 'Approved',
                                message:
                                    '$username can now log in as an admin.',
                              );
                            } catch (e) {
                              WasteLoaders.errorSnackBar(
                                title: 'Oops!',
                                message: e.toString(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WasteColors.buttonPrimary,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
