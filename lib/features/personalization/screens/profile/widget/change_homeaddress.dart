import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/form_fields/address_autocomplete_field.dart';
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
              "Choose a registered address from the list.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            Form(
              key: controller.updateHomeAddressFormKey,
              child: Column(
                children: [
                  WasteAddressAutocompleteField(
                    controller: controller.homeAddress,
                    validator: (value) => WasteValidator.validateEmptyText(
                      WasteTexts.homeAddressValidation.tr,
                      value,
                    ),
                    labelText: WasteTexts.homeAddress.tr,
                    prefixIcon: const Icon(Iconsax.location),
                    hintText: 'Search your address',
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
                child: Text(WasteTexts.save.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
