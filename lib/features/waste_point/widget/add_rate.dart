import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/waste_point/controller/old_material_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminAddMaterialScreen extends StatelessWidget {
  const AdminAddMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OldMaterialController());
    return Scaffold(
      appBar: const WasteAppBar(
        showBackArrow: true,
        title: Text("Add New Material"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: controller.addMaterialFormKey,
                child: Column(
                  children: [
                    // Rate ID
                    TextFormField(
                      controller: controller.rateId,
                      validator: (value) =>
                          WasteValidator.validateEmptyText("Rate ID", value),
                      decoration: const InputDecoration(
                        labelText: WasteTexts.materialID,
                        prefixIcon: Icon(Iconsax.security_user),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwInputFields),

                    // Material Name
                    TextFormField(
                      controller: controller.materialName,
                      validator: (value) => WasteValidator.validateEmptyText(
                        "Material Name",
                        value,
                      ),
                      decoration: const InputDecoration(
                        labelText: WasteTexts.materialName,
                        prefixIcon: Icon(Iconsax.firstline),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwInputFields),

                    // Material Type
                    Obx(() {
                      return DropdownButtonFormField<String>(
                        value: controller.materialType.value,
                        validator: (value) => WasteValidator.validateDropdown(
                          "Material Type",
                          value,
                        ),
                        onChanged: (String? newValue) {
                          controller.materialType.value = newValue!;
                        },
                        items:
                            <String>[
                              'Plastic',
                              'Paper',
                              'Can',
                              'Used Oil',
                              'Others',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        decoration: const InputDecoration(
                          labelText: WasteTexts.materialType,
                          prefixIcon: Icon(Iconsax.clipboard),
                        ),
                      );
                    }),
                    const SizedBox(height: WasteSizes.spaceBtwInputFields),

                    // Value
                    TextFormField(
                      controller: controller.materialValue,
                      validator: (value) =>
                          WasteValidator.validateDecimalPlaces("Value", value),
                      decoration: const InputDecoration(
                        labelText: WasteTexts.materialValue,
                        prefixIcon: Icon(Iconsax.coin),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),

                    // Add Material button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.addNewMaterial(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WasteColors.buttonPrimary,
                          side: const BorderSide(
                            color: WasteColors.buttonPrimary,
                          ),
                        ),
                        child: const Text(WasteTexts.materialAddButton),
                      ),
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwSections),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
