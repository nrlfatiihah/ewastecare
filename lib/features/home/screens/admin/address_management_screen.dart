import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/data/repositories/address/address_repository.dart';
import 'package:ewastecare/features/home/controllers/address_management_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  Future<void> _confirmDelete(
    AddressManagementController controller,
    AddressEntry address,
  ) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Remove "${address.name}" from the address list?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(WasteTexts.cancel.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(WasteTexts.delete.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (shouldDelete == true) {
      await controller.deleteAddress(address.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressManagementController());

    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(
          WasteTexts.manageAddresses.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(WasteSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add the addresses users can search and select during signup or profile updates.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            Form(
              key: controller.addressFormKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.addressName,
                      validator: (value) => WasteValidator.validateEmptyText(
                        WasteTexts.address.tr,
                        value,
                      ),
                      decoration: InputDecoration(
                        labelText: WasteTexts.address.tr,
                        prefixIcon: const Icon(Iconsax.location),
                      ),
                    ),
                  ),
                  const SizedBox(width: WasteSizes.spaceBtwInputFields),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.addAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WasteColors.buttonPrimary,
                        side: const BorderSide(
                          color: WasteColors.buttonPrimary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      child: controller.isSubmitting.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(WasteTexts.save.tr),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwSections),
            Expanded(
              child: StreamBuilder<List<AddressEntry>>(
                stream: controller.addressRepository.watchAddressEntries(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final addresses = snapshot.data ?? const <AddressEntry>[];
                  if (addresses.isEmpty) {
                    return Center(
                      child: Text(
                        'No addresses yet. Add one above to make it searchable.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: WasteSizes.spaceBtwItems),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Iconsax.location),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                address.name,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _confirmDelete(controller, address),
                              icon: const Icon(Iconsax.trash),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
