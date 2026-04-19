import 'dart:io';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/admin_navigation_menu.dart';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/module/module_repository.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/features/module/models/section_form_model.dart';
import 'package:ewastecare/features/module/models/section_model.dart';
import 'package:ewastecare/features/module/screens/admin/admin_module.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ModuleController extends GetxController {
  static ModuleController get instance => Get.find();
  final GlobalKey<FormState> addModuleFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final imagePath = "".obs;
  final sectionImagePath = "".obs;
  final imageUploading = false.obs;
  final moduleRepository = Get.put(ModuleRepository());
  final moduleID = TextEditingController();
  final moduleTitle = TextEditingController();
  final moduleSubtitle = TextEditingController();
  final sections = <SectionFormModel>[].obs;
  RxList<ModuleModel> learningModule = <ModuleModel>[].obs;
  bool moduleDataFetched = false;
  final isEditing = false.obs;
  RxList<String> completedModules = <String>[].obs;

  @override
  void onInit() {
    fetchLearningModule();
    super.onInit();

    ever(UserController.instance.user, (user) {
      fetchUserCompletedModules();
    });
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

  // Fetch modules
  Future<void> fetchLearningModule() async {
    try {
      isLoading.value = true;
      final module = await moduleRepository.getAllMaterials();
      learningModule.assignAll(module);
    } catch (e) {
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetModuleDataFetched() {
    moduleDataFetched = false;
  }

  // Image picking
  Future<String?> selectModuleImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile?.path;
  }

  void setImagePath(String path) {
    imagePath.value = path;
  }

  Future<void> pickSectionImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      sections[index].sectionImageFile = File(pickedFile.path);
      sections.refresh();
    }
  }

  Future<String> uploadImageToStorage(String imagePath) async {
    try {
      imageUploading.value = true;
      final reference = FirebaseStorage.instance
          .ref()
          .child("MaterialImages")
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = reference.putFile(File(imagePath));
      final snapshot = await uploadTask.whenComplete(() {});

      imageUploading.value = false;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      imageUploading.value = false;
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: '${WasteTexts.imageUploadFailed.tr}: $e',
      );
      throw Exception(WasteTexts.imageUploadFailed.tr);
    }
  }

  // Add Module
  void addNewModule() async {
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

      if (!addModuleFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      if (imagePath.value.isEmpty) {
        WasteLoaders.errorSnackBar(
          title: WasteTexts.oops.tr,
          message: WasteTexts.selectModuleImage.tr,
        );
        WasteFullScreenLoader.stopLoading();
        return;
      }

      final imageUrl = await uploadImageToStorage(imagePath.value);

      final List<SectionModel> contentSections = [];

      for (var section in sections) {
        String? sectionImageUrl;

        if (section.sectionImageFile != null) {
          sectionImageUrl = await uploadImageToStorage(
            section.sectionImageFile!.path,
          );
        }

        contentSections.add(
          SectionModel(
            sectionTitle1: section.sectionTitle.text.trim(),
            sectionContent1: section.sectionContent.text.trim(),
            sectionImage: sectionImageUrl,
            sectionContent1AddPoint1: section.points.isNotEmpty
                ? section.points[0].text.trim()
                : null,
            sectionContent1AddPoint2: section.points.length > 1
                ? section.points[1].text.trim()
                : null,
            sectionContent1AddPoint3: section.points.length > 2
                ? section.points[2].text.trim()
                : null,
          ),
        );
      }

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
          title: WasteTexts.oops.tr,
          message: WasteTexts.moduleIdInUse.tr,
        );
        return;
      }

      await moduleRepository.saveModuleRecord(newModule);

      await fetchLearningModule();

      WasteFullScreenLoader.stopLoading();

      WasteLoaders.successSnackBar(
        title: WasteTexts.success.tr,
        message: WasteTexts.moduleSuccessfullyAdded.tr,
      );

      clearFormData();

      Get.offAll(() => const AdminNavigationMenu());
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: e.toString(),
      );
    }
  }

  // Load module for editing
  void loadModuleForEditing(ModuleModel module) {
    if (isEditing.value) return;
    isEditing.value = true;

    moduleID.text = module.id;
    moduleTitle.text = module.moduleTitle;
    moduleSubtitle.text = module.moduleSubtitle;
    imagePath.value = module.moduleImage;

    sections.clear();

    for (var section in module.contentSections) {
      final sectionForm = SectionFormModel();
      sectionForm.sectionTitle.text = section.sectionTitle1;
      sectionForm.sectionContent.text = section.sectionContent1;

      // Load image URL in the form
      if (section.sectionImage != null && section.sectionImage!.isNotEmpty) {
        sectionForm.sectionImageFile = null;
        sectionForm.sectionImageUrl = section.sectionImage;
      }

      // Load points
      if (section.sectionContent1AddPoint1 != null) {
        sectionForm.points.add(
          TextEditingController()..text = section.sectionContent1AddPoint1!,
        );
      }
      if (section.sectionContent1AddPoint2 != null) {
        sectionForm.points.add(
          TextEditingController()..text = section.sectionContent1AddPoint2!,
        );
      }
      if (section.sectionContent1AddPoint3 != null) {
        sectionForm.points.add(
          TextEditingController()..text = section.sectionContent1AddPoint3!,
        );
      }
      sections.add(sectionForm);
    }
  }

  Future<void> updateModule(ModuleModel oldModule) async {
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

      if (!addModuleFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      // Upload module image if new one selected
      String moduleImageUrl = oldModule.moduleImage;
      if (imagePath.value != oldModule.moduleImage) {
        moduleImageUrl = await uploadImageToStorage(imagePath.value);
      }

      // Upload section images if any new selected
      final List<SectionModel> contentSections = [];
      for (var section in sections) {
        String? sectionImageUrl = section.sectionImageUrl; // existing URL
        if (section.sectionImageFile != null) {
          sectionImageUrl = await uploadImageToStorage(
            section.sectionImageFile!.path,
          );
        }

        contentSections.add(
          SectionModel(
            sectionTitle1: section.sectionTitle.text.trim(),
            sectionContent1: section.sectionContent.text.trim(),
            sectionImage: sectionImageUrl,
            sectionContent1AddPoint1: section.points.isNotEmpty
                ? section.points[0].text.trim()
                : null,
            sectionContent1AddPoint2: section.points.length > 1
                ? section.points[1].text.trim()
                : null,
            sectionContent1AddPoint3: section.points.length > 2
                ? section.points[2].text.trim()
                : null,
          ),
        );
      }

      final updatedModule = ModuleModel(
        id: oldModule.id,
        moduleTitle: moduleTitle.text.trim(),
        moduleSubtitle: moduleSubtitle.text.trim(),
        moduleImage: moduleImageUrl,
        contentSections: contentSections,
      );

      await moduleRepository.updateModuleRecord(updatedModule);

      await fetchLearningModule();

      WasteFullScreenLoader.stopLoading();
      WasteLoaders.successSnackBar(
        title: WasteTexts.success.tr,
        message: WasteTexts.moduleSuccessfullyUpdated.tr,
      );

      Get.offAll(() => const AdminNavigationMenu());
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: e.toString(),
      );
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

  Future<void> fetchUserCompletedModules() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('CompletedModules')
        .doc(userId)
        .get();

    final modules = doc.data()?['completedModules'] as List<dynamic>? ?? [];
    completedModules.assignAll(modules.cast<String>());
  }

  Future<void> markModuleCompleted(String moduleId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Update local controller
    if (!completedModules.contains(moduleId)) {
      completedModules.add(moduleId);
    }

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('CompletedModules')
        .doc(userId)
        .set(
          {
            'completedModules': FieldValue.arrayUnion([moduleId]),
          },
          SetOptions(merge: true), // Merge with existing data
        );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WasteTexts.confirmDeletion.tr),
          content: Text(WasteTexts.confirmDeleteModule.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(WasteTexts.cancel.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteModule(); // Perform the deletion
              },
              child: Text(WasteTexts.confirm.tr),
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
        title: WasteTexts.success.tr,
        message: WasteTexts.moduleSuccessfullyDeleted.tr,
      );
      Get.offAll(() => const AdminNavigationMenu());
    } catch (e) {
      WasteLoaders.errorSnackBar(
        title: WasteTexts.oops.tr,
        message: WasteTexts.moduleDeleteFailed.tr,
      );
    }
  }
}
