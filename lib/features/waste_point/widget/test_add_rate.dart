import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/waste_point/controller/material_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TestAdminAddMaterialScreen extends StatelessWidget {
  const TestAdminAddMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaterialController());
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(WasteTexts.addNewMaterial.tr),
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
                    // Material Name
                    TextFormField(
                      controller: controller.materialName,
                      validator: (value) => WasteValidator.validateEmptyText(
                        "Material Name",
                        value,
                      ),
                      decoration: InputDecoration(
                        labelText: WasteTexts.materialName.tr,
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
                        decoration: InputDecoration(
                          labelText: WasteTexts.materialType.tr,
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
                      decoration: InputDecoration(
                        labelText: WasteTexts.materialValue.tr,
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
                        child: Text(WasteTexts.materialAddButton.tr),
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
