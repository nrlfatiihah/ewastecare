import 'package:ewastecare/data/repositories/material/older_material_repository.dart';
import 'package:ewastecare/features/ecobako_point/model/rate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Adjust import as needed

class AllocateEcoPointController extends GetxController {
  final OlderMaterialRepository repository = OlderMaterialRepository();

  var isPlasticExpanded = false.obs;
  var isPaperExpanded = false.obs;
  var isCanExpanded = false.obs;
  var isCookingOilExpanded = false.obs;
  var isOthersExpanded = false.obs;

  var plasticMaterials = <OldMaterialModel>[].obs;
  var paperMaterials = <OldMaterialModel>[].obs;
  var canMaterials = <OldMaterialModel>[].obs;
  var oilMaterials = <OldMaterialModel>[].obs;
  var othersMaterials = <OldMaterialModel>[].obs;

  var expandedPanels = <bool>[].obs; // Track the expanded state of panels
  // var weightControllers = <String, TextEditingController>{}.obs; // Track weight input controllers
  Map<String, TextEditingController> weightControllers = {};

  var userID = TextEditingController();
  final addPointFormKey = GlobalKey<FormState>();

  bool dataFetched = false;

  @override
  void onInit() {
    super.onInit();
    fetchMaterialsAllocateScreen();
  }

  @override
  void onClose() {
    // Dispose of controllers when the screen is closed
    weightControllers.values.forEach((controller) => controller.dispose());
    super.onClose();
  }

  Future<void> fetchMaterialsAllocateScreen() async {
    try {
      // Fetch materials by type
      plasticMaterials.value = await repository.getMaterialsByType('Plastic');
      paperMaterials.value = await repository.getMaterialsByType('Paper');
      canMaterials.value = await repository.getMaterialsByType('Can');
      oilMaterials.value = await repository.getMaterialsByType('Used Oil');
      othersMaterials.value = await repository.getMaterialsByType('Others');

      // Set up controllers only for the relevant material types
      for (var material in plasticMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in paperMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in canMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in oilMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
      for (var material in othersMaterials) {
        weightControllers[material.name] = TextEditingController();
      }
    } catch (e) {
      print("Error fetching materials: $e");
    }
  }

  Future<void> allocatePoints() async {
    if (addPointFormKey.currentState?.validate() ?? false) {
      double totalPoints = 0.0;

      final allMaterials = [
        ...plasticMaterials,
        ...paperMaterials,
        ...canMaterials,
        ...oilMaterials,
        ...othersMaterials,
      ];

      for (var material in allMaterials) {
        final weightController = weightControllers[material.name];
        final weight = double.tryParse(weightController?.text ?? '') ?? 0.0;
        totalPoints += weight * material.value;
      }

      // Save the transaction
      // await _saveTransaction(totalPoints);
    }
  }

  void resetDataFetched() {
    dataFetched = false;
  }
}
