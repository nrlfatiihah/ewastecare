import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/material/older_material_repository.dart';
import 'package:ewastecare/features/waste_point/model/rate_model.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OldMaterialController extends GetxController {
  static OldMaterialController get instance => Get.find();

  GlobalKey<FormState> addMaterialFormKey = GlobalKey<FormState>();

  final materialRepository = Get.put(OlderMaterialRepository());
  final rateId = TextEditingController();
  final materialName = TextEditingController();
  final materialValue = TextEditingController();
  final materialType = Rx<String?>(null); // Default value

  void addNewMaterial() async {
    try {
      WasteFullScreenLoader.openLoadingDialog(
        "We are processing your request",
        WasteImages.docerAnimation,
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      if (!addMaterialFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      final newMaterial = OldMaterialModel(
        id: rateId.text.trim(),
        name: materialName.text.trim(),
        value: double.tryParse(materialValue.text) ?? 0.0,
        type: materialType.value?.trim() ?? "",
      );

      final bool isUnique = await materialRepository.isIdUnique(
        rateId.text.trim(),
      );
      if (!isUnique) {
        WasteFullScreenLoader.stopLoading();
        WasteLoaders.errorSnackBar(
          title: "Error",
          message:
              "The Id has been used on other products, please try again with another id",
        );
        return;
      }

      await materialRepository.saveMaterialRecord(newMaterial);

      WasteFullScreenLoader.stopLoading();

      WasteLoaders.successSnackBar(
        title: "Success",
        message: "Your product has been successfully added to the store.",
      );

      clearFormData();
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  void clearFormData() {
    rateId.clear();
    materialName.clear();
    materialValue.clear();
  }
}
