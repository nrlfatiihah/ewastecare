import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/home/screens/admin/widgets/admin_home_appbar.dart';
import 'package:ewastecare/features/home/screens/admin/widgets/drawer_admin.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/screens/widget/learning_module_content.dart';
import 'package:ewastecare/features/module/screens/widget/module_action_button.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminModule extends StatelessWidget {
  const AdminModule({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);
    final controller = Get.put(ModuleController());

    return Scaffold(
      endDrawer: AdminEndDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetModuleDataFetched();
          await controller.fetchLearningModule();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAdminHomeAppBar(),
                    SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Column(
                  children: [
                    const WasteSectionHeading(
                      title: "Learning Module",
                      showActionButton: false,
                    ),
                    Obx(
                      () => ListView.builder(
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
                                      builder: (context) =>
                                          LearningModuleContent(module: module),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
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
                                            module
                                                .moduleImage, // use moduleImage from ModuleModel
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const AdminModuleActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
