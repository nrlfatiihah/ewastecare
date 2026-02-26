import 'dart:io';
import 'dart:ui';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/module/module_repository.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/features/module/models/section_form_model.dart';
import 'package:ewastecare/features/module/models/section_model.dart';
import 'package:ewastecare/features/module/screens/admin/admin_module.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ModuleController extends GetxController {
  static ModuleController get instance => Get.find();
  final GlobalKey<FormState> addModuleFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final imagePath = "".obs;
  final imageUploading = false.obs;
  final moduleRepository = Get.put(ModuleRepository());
  final moduleID = TextEditingController();
  final moduleTitle = TextEditingController();
  final moduleSubtitle = TextEditingController();
  final sections = <SectionFormModel>[].obs;
  RxList<ModuleModel> learningModule = <ModuleModel>[].obs;
  bool moduleDataFetched = false;

  @override
  void onInit() {
    fetchLearningModule();
    super.onInit();
  }

  @override
  void onClose() {
    moduleID.dispose();
    moduleTitle.dispose();
    moduleSubtitle.dispose();

    for (var section in sections) {
      section.sectionTitle.dispose();
      section.sectionContent.dispose();
      for (var point in section.points) {
        point.dispose();
      }
    }

    super.onClose();
  }

  Future<void> fetchLearningModule() async {
    try {
      isLoading.value = true;
      final module = await moduleRepository.getAllMaterials();
      learningModule.assignAll(module);
    } catch (e) {
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetModuleDataFetched() {
    moduleDataFetched = false;
  }

  Future<String?> selectModuleImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile?.path;
  }

  void setImagePath(String path) {
    imagePath.value = path;
  }

  void addNewModule() async {
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

      if (!addModuleFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      if (imagePath.value.isEmpty) {
        WasteLoaders.errorSnackBar(
          title: "Error",
          message: "Please select a module image.",
        );
        WasteFullScreenLoader.stopLoading();
        return;
      }

      final imageUrl = await uploadImageToStorage(imagePath.value);

      final List<SectionModel> contentSections = sections.map((section) {
        return SectionModel(
          sectionTitle1: section.sectionTitle.text.trim(),
          sectionContent1: section.sectionContent.text.trim(),
          sectionContent1AddPoint1: section.points.isNotEmpty
              ? section.points[0].text.trim()
              : null,
          sectionContent1AddPoint2: section.points.length > 1
              ? section.points[1].text.trim()
              : null,
          sectionContent1AddPoint3: section.points.length > 2
              ? section.points[2].text.trim()
              : null,
        );
      }).toList();

      final newModule = ModuleModel(
        id: moduleID.text.trim(),
        moduleTitle: moduleTitle.text.trim(),
        moduleSubtitle: moduleSubtitle.text.trim(),
        moduleImage: imageUrl,
        contentSections: contentSections,
      );

      final bool isUnique = await moduleRepository.isIdUnique(
        moduleID.text.trim(),
      );
      if (!isUnique) {
        WasteFullScreenLoader.stopLoading();
        WasteLoaders.errorSnackBar(
          title: "Error",
          message:
              "The Id has been used on other modules, please try again with another id",
        );
        return;
      }

      await moduleRepository.saveModuleRecord(newModule);

      await fetchLearningModule();

      WasteFullScreenLoader.stopLoading();

      WasteLoaders.successSnackBar(
        title: "Success",
        message: "Your module has been successfully added.",
      );

      clearFormData();
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  void updateModule(ModuleModel oldModule) async {
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

      if (!addModuleFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      if (imagePath.value.isNotEmpty) {
        oldModule.moduleImage = await uploadImageToStorage(imagePath.value);
      }

      final List<SectionModel> contentSections = sections.map((section) {
        return SectionModel(
          sectionTitle1: section.sectionTitle.text.trim(),
          sectionContent1: section.sectionContent.text.trim(),
          sectionContent1AddPoint1: section.points.isNotEmpty
              ? section.points[0].text.trim()
              : null,
          sectionContent1AddPoint2: section.points.length > 1
              ? section.points[1].text.trim()
              : null,
          sectionContent1AddPoint3: section.points.length > 2
              ? section.points[2].text.trim()
              : null,
        );
      }).toList();

      final updatedModule = ModuleModel(
        id: oldModule.id,
        moduleTitle: moduleTitle.text.trim(),
        moduleSubtitle: moduleSubtitle.text.trim(),
        moduleImage: oldModule.moduleImage,
        contentSections: contentSections,
      );

      // await moduleRepository.updateModuleRecord(updatedModule);

      WasteFullScreenLoader.stopLoading();

      WasteLoaders.successSnackBar(
        title: "Success",
        message: "Your material has been successfully updated.",
      );
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
    }
  }

  Future<String> uploadImageToStorage(String imagePath) async {
    try {
      imageUploading.value = true;
      final reference = FirebaseStorage.instance
          .ref()
          .child("ProductImages")
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = reference.putFile(File(imagePath));
      final snapshot = await uploadTask.whenComplete(() {});

      imageUploading.value = false;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      imageUploading.value = false;
      WasteLoaders.errorSnackBar(
        title: "Oops!",
        message: "Failed to upload image: $e",
      );
      throw Exception("Image upload failed");
    }
  }

  void updateModuleID(String newID) {
    moduleID.text = newID;
  }

  void updateModuleTitle(String newTitle) {
    moduleTitle.text = newTitle;
  }

  void updateModuleSubTitle(String newSubTitle) {
    moduleSubtitle.text = newSubTitle;
  }

  void updateSectionTitle(int index, String newTitle) {
    sections[index].sectionTitle.text = newTitle;
  }

  void updateSectionContent(int index, String newContent) {
    sections[index].sectionContent.text = newContent;
  }

  void updateSectionPoint(int sectionIndex, int pointIndex, String newPoint) {
    sections[sectionIndex].points[pointIndex].text = newPoint;
  }

  void addSection() {
    sections.add(SectionFormModel());
  }

  void removeSection(int index) {
    sections.removeAt(index);
  }

  void clearFormData() {
    moduleID.clear();
    moduleTitle.clear();
    moduleSubtitle.clear();
    imagePath.value = "";

    for (var section in sections) {
      section.sectionTitle.dispose();
      section.sectionContent.dispose();

      for (var point in section.points) {
        point.dispose();
      }
    }
    sections.clear();
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteModule(); // Perform the deletion
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteModule() async {
    final id = moduleID.text;
    try {
      await moduleRepository.deleteModule(id);
      WasteLoaders.successSnackBar(
        title: "Success",
        message: "The product have been deleted successfully",
      );
      Get.off(() => const AdminModule());
    } catch (e) {
      WasteLoaders.errorSnackBar(
        title: "Opps",
        message: "Failed to delete the product. Please try again",
      );
    }
  }
}
