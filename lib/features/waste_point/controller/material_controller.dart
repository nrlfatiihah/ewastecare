import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/material/material_repository.dart';
import 'package:ewastecare/features/dashboard/models/material_distribution_model.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/features/waste_point/screen/recycle_rate.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialController extends GetxController {
  static MaterialController get instance => Get.find();

  GlobalKey<FormState> addMaterialFormKey = GlobalKey<FormState>();

  final materialRepository = Get.put(MaterialRepository());
  final MaterialRepository _materialRepository = MaterialRepository();
  final materialName = TextEditingController();
  final materialValue = TextEditingController();
  final materialType = Rx<String?>(null); // Default value

  // UI state variables
  var isPlasticExpanded = false.obs;
  var isPaperExpanded = false.obs;
  var isCanExpanded = false.obs;
  var isCookingOilExpanded = false.obs;
  var isOthersExpanded = false.obs;

  // Material data
  var plasticMaterials = <MaterialModel>[].obs;
  var paperMaterials = <MaterialModel>[].obs;
  var canMaterials = <MaterialModel>[].obs;
  var oilMaterials = <MaterialModel>[].obs;
  var othersMaterials = <MaterialModel>[].obs;

  // Material Distribution model
  var plasticMaterialsDistribution = <MaterialDistributionModel>[].obs;
  var paperMaterialsDistribution = <MaterialDistributionModel>[].obs;
  var canMaterialsDistribution = <MaterialDistributionModel>[].obs;
  var oilMaterialsDistribution = <MaterialDistributionModel>[].obs;
  var othersMaterialsDistribution = <MaterialDistributionModel>[].obs;

  // Track whether data has been fetched already
  var dataFetched = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRateMaterials();
  }

  void addNewMaterial() async {
    try {
      WasteFullScreenLoader.openLoadingDialog(
        WasteTexts.processingInformation.tr,
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

      final newMaterial = MaterialModel(
        name: materialName.text.trim(),
        value: double.tryParse(materialValue.text) ?? 0.0,
        type: materialType.value?.trim() ?? "",
      );

      final bool isUnique = await materialRepository.isIdUnique(
        materialName.text.trim(),
      );
      if (!isUnique) {
        WasteFullScreenLoader.stopLoading();
        WasteLoaders.errorSnackBar(
          title: WasteTexts.oops.tr,
          message: WasteTexts.materialNameInUse.tr,
        );
        return;
      }

      await materialRepository.saveMaterialRecord(newMaterial);

      WasteFullScreenLoader.stopLoading();

      WasteLoaders.successSnackBar(
        title: WasteTexts.success.tr,
        message: WasteTexts.materialSuccessfullyAdded.tr,
      );

      Get.offAll(() => const RecycleRate());
      clearFormData();
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: e.toString(),
      );
    }
  }

  void clearFormData() {
    materialName.clear();
    materialValue.clear();
  }

  Future<void> fetchRateMaterials() async {
    try {
      // Fetching materials from the repository based on the material type
      plasticMaterials.value = await _materialRepository.fetchAllMaterials(
        'Plastic',
      );
      paperMaterials.value = await _materialRepository.fetchAllMaterials(
        'Paper',
      );
      canMaterials.value = await _materialRepository.fetchAllMaterials('Can');
      oilMaterials.value = await _materialRepository.fetchAllMaterials(
        'Used Oil',
      );
      othersMaterials.value = await _materialRepository.fetchAllMaterials(
        'Others',
      );

      dataFetched.value = true; // Mark data as fetched
    } catch (e) {
      print("Error fetching materials: $e");
    }
  }

  Future<void> updateMaterial(MaterialModel material) async {
    try {
      await _materialRepository.updateMaterialValue(
        material.type,
        material.name,
        material.value,
      );
      fetchRateMaterials();
      // // You can show a success message here if needed
    } catch (e) {
      print("Error updating material: $e");
      // You can handle errors and show a snackbar or alert
    }
  }

  void resetDataFetched() {
    dataFetched.value = false;
  }
}
