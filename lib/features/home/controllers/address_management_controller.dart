import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/address/address_repository.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressManagementController extends GetxController {
  static AddressManagementController get instance => Get.find();

  final AddressRepository addressRepository = Get.put(AddressRepository());
  final addressName = TextEditingController();
  final addressFormKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;

  Future<void> addAddress() async {
    if (!addressFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;
      await addressRepository.addAddress(addressName.text);
      addressName.clear();
      WasteLoaders.successSnackBar(
        title: WasteTexts.success.tr,
        message: 'Address added successfully.',
      );
    } catch (e) {
      WasteLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await addressRepository.deleteAddress(addressId);
      WasteLoaders.successSnackBar(
        title: WasteTexts.success.tr,
        message: 'Address removed successfully.',
      );
    } catch (e) {
      WasteLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
