import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/features/module/screens/widget/learning_module_content.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModuleScreen extends StatelessWidget {
  UserModuleScreen({super.key});

  // Access the controller
  final controller = ModuleController.instance;

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetModuleDataFetched();
          await controller.fetchLearningModule();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
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

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LearningModuleContent(module: module),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 250,
                                        maxWidth: double.infinity,
                                      ),
                                      child: Image.network(
                                        module.moduleImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Title and Subtitle
                                  ListTile(
                                    title: Text(module.moduleTitle),
                                    subtitle: Text(module.moduleSubtitle),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
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
