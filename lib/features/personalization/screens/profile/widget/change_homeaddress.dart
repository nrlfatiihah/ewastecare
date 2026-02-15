import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/personalization/controllers/update_homeaddress_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangeHomeAddress extends StatelessWidget {
  const ChangeHomeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateHomeAddressController());
    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(
          "Change Home Address",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This home address will be display and store in this application",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            Form(
              key: controller.updateHomeAddressFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.homeAddress,
                    validator: (value) =>
                        WasteValidator.validateEmptyText("homeAddress", value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: WasteTexts.homeAddress,
                      prefixIcon: Icon(Iconsax.location),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwInputFields),
                ],
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateHomeAddress(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
