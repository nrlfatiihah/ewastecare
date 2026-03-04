import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/screens/widget/learning_module_content_user.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';

class UserModuleScreen extends StatelessWidget {
  UserModuleScreen({super.key});

  final ModuleController controller = ModuleController.instance;

  // Pull-to-refresh
  Future<void> _refresh() async {
    controller.resetModuleDataFetched();
    await controller.fetchLearningModule();
    await controller.fetchUserCompletedModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      title: Text(
                        "Learning Module",
                        style: Theme.of(context).textTheme.headlineMedium!
                            .apply(color: WasteColors.white),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.defaultSpace),
                  ],
                ),
              ),

              // Module List
              Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.learningModule.isEmpty) {
                    return const Center(child: Text("No modules found."));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.learningModule.length,
                    itemBuilder: (context, index) {
                      final module = controller.learningModule[index];

                      // Reactive badge check
                      final hasBadge = controller.completedModules.contains(
                        module.id,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LearningModuleContentUser(module: module),
                            ),
                          ).then((_) {
                            // Fetch badges when returning from module
                            controller.fetchUserCompletedModules();
                          });
                        },
                        child: Stack(
                          children: [
                            // Module card
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (module.moduleImage.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        module.moduleImage,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 60),
                                    ),
                                  ListTile(
                                    title: Text(module.moduleTitle),
                                    subtitle: Text(module.moduleSubtitle),
                                  ),
                                ],
                              ),
                            ),

                            // Badge overlay
                            if (hasBadge)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[600],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
