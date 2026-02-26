import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/screens/admin/widget/add_module_image.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminAddModuleScreen extends StatelessWidget {
  const AdminAddModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ModuleController());

    return Scaffold(
      appBar: const WasteAppBar(
        showBackArrow: true,
        title: Text("Add New Module"),
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
                  validator: (value) =>
                      WasteValidator.validateEmptyText("Module ID", value),
                  decoration: const InputDecoration(
                    labelText: "Module ID",
                    prefixIcon: Icon(Iconsax.tag),
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwInputFields),

                // Module Title
                TextFormField(
                  controller: controller.moduleTitle,
                  validator: (value) =>
                      WasteValidator.validateEmptyText("Module Title", value),
                  decoration: const InputDecoration(
                    labelText: "Module Title",
                    prefixIcon: Icon(Iconsax.book),
                  ),
                ),
                const SizedBox(height: WasteSizes.spaceBtwInputFields),

                // Module Subtitle
                TextFormField(
                  controller: controller.moduleSubtitle,
                  validator: (value) => WasteValidator.validateEmptyText(
                    "Module Subtitle",
                    value,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Module Subtitle",
                    prefixIcon: Icon(Iconsax.text),
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
                    const Text(
                      "Module Sections",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 150, // set width
                      child: ElevatedButton.icon(
                        onPressed: controller.addSection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WasteColors.primary,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Section"),
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
                                    "Section ${index + 1}",
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
                                decoration: const InputDecoration(
                                  labelText: "Section Title",
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Section Content
                              TextFormField(
                                controller: section.sectionContent,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: "Section Description",
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Add Point Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    section.points.add(TextEditingController());
                                    controller.sections.refresh();
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text("Add Point"),
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
                                        labelText: "Point ${pointIndex + 1}",
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

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.addNewModule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WasteColors.primary,
                    ),
                    child: const Text("Save Module"),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
