import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/features/module/screens/admin/widget/add_module_image.dart';
import 'package:ewastecare/features/module/screens/admin/widget/add_section_image.dart';
import 'package:ewastecare/features/module/screens/admin/widget/module_quiz_form.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminEditModuleScreen extends StatelessWidget {
  final ModuleModel module;

  const AdminEditModuleScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ModuleController());

    controller.clearFormData();
    controller.isEditing.value = false;
    controller.loadModuleForEditing(module);

    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.editModule.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Form(
            key: controller.addModuleFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module ID
                TextFormField(
                  controller: controller.moduleID,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: WasteTexts.moduleId.tr,
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwInputFields),

                // Module Title
                TextFormField(
                  controller: controller.moduleTitle,
                  decoration: InputDecoration(
                    labelText: WasteTexts.moduleTitle.tr,
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwInputFields),

                // Module Subtitle
                TextFormField(
                  controller: controller.moduleSubtitle,
                  decoration: InputDecoration(
                    labelText: WasteTexts.moduleSubtitle.tr,
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwSections),

                // Module Image
                const AddModuleImage(),

                const SizedBox(height: WasteSizes.spaceBtwSections),

                // Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      WasteTexts.moduleSections.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 150, // set width
                      child: ElevatedButton.icon(
                        onPressed: controller.addSection,
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: WasteColors.primary,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                        icon: const Icon(Icons.add),
                        label: Text(
                          WasteTexts.addSection.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: WasteSizes.spaceBtwInputFields),

                Obx(
                  () => Column(
                    children: List.generate(controller.sections.length, (
                      index,
                    ) {
                      final section = controller.sections[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${WasteTexts.section.tr} ${index + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.removeSection(index),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Section Title
                              TextFormField(
                                controller: section.sectionTitle,
                                decoration: InputDecoration(
                                  labelText: WasteTexts.sectionTitle.tr,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Section Content
                              TextFormField(
                                controller: section.sectionContent,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: WasteTexts.sectionDescription.tr,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Section Image
                              AddSectionImage(index: index),

                              const SizedBox(height: 12),

                              // Add Point Button
                              if (section.points.length < 3)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      section.points.add(
                                        TextEditingController(),
                                      );
                                      controller.sections.refresh();
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text(WasteTexts.addPoint.tr),
                                  ),
                                ),

                              // Points List
                              Column(
                                children: List.generate(section.points.length, (
                                  pointIndex,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextFormField(
                                      controller: section.points[pointIndex],
                                      decoration: InputDecoration(
                                        labelText:
                                            "${WasteTexts.point.tr} ${pointIndex + 1}",
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: WasteSizes.spaceBtwSections),

                ModuleQuizForm(controller: controller),

                const SizedBox(height: WasteSizes.spaceBtwSections),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.updateModule(module),
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor: WasteColors.primary,
                          side: BorderSide.none,
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                    child: Text(
                      WasteTexts.updateModule.tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Delete Module button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.showDeleteConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: Text(WasteTexts.deleteModule.tr),
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
