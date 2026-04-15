import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/personalization/controllers/update_name_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(
          "Change Name",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Use real neme for easy verification process.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),

            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        WasteValidator.validateEmptyText("First name", value),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.firstName.tr,
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        WasteValidator.validateEmptyText("Last name", value),
                    expands: false,
                    decoration: InputDecoration(
                      labelText: WasteTexts.lastName.tr,
                      prefixIcon: Icon(Iconsax.user_edit),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateUserName(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                ),
                child: Text(WasteTexts.save.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
