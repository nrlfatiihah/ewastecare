// Use and checked
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/admin/admin_repository.dart';
import 'package:ewastecare/features/personalization/models/admin_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminController extends GetxController {
  //static UserController get instance => Get.find<UserController>();
  static AdminController get instance => Get.put(AdminController());

  final profileLoading = false.obs;
  Rx<AdminModel> user = AdminModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final adminRepository = Get.put(AdminRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAdminRecord();
  }

  // fetch admin record
  Future<void> fetchAdminRecord() async {
    try {
      profileLoading.value = true;
      final user = await adminRepository.fetchAdminDetails();
      this.user(user);
    } catch (e) {
      user(AdminModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // Save user record from any registation provider
  Future<void> saveAdminRecord(UserCredential? userCredentials) async {
    try {
      await fetchAdminRecord();
      if (userCredentials != null) {
        // Map Data
        final admin = AdminModel(
          id: userCredentials.user!.uid,
          username: "",
          email: userCredentials.user!.email ?? "",
          profilePicture: userCredentials.user!.photoURL ?? "",
          role: "admin",
        );

        // save user data
        await adminRepository.saveAdminRecord(admin);
      }
    } catch (e) {
      WasteLoaders.warningSnackBar(
        title: "Data not saved",
        message:
            "Something went wrong while saving your information. Ypu can resave your data in your Profile.",
      );
    }
  }

  // Function to use own image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        imageUploading.value = true;
        final imageUrl = await adminRepository.uploadImage(
          "Admins/Images/Profile/",
          image,
        );

        //Update Admin image Record
        Map<String, dynamic> json = {"ProfilePicture": imageUrl};
        await adminRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        WasteLoaders.successSnackBar(
          title: "Success",
          message: "Your profile picture has been updated successfully!",
        );
      }
    } catch (e) {
      WasteLoaders.errorSnackBar(
        title: "Oops!",
        message: "Something went wrong!: $e",
      );
    } finally {
      imageUploading.value = false;
    }
  }

  // uploadItemPicture() async {
  //   try {
  //     final image = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //       maxHeight: 512,
  //       maxWidth: 512,
  //     );
  //     if (image != null) {
  //       imageUploading.value = true;
  //       final imageUrl = await adminRepository.uploadStoreItemImage("Store/Images/Items",image);
  //       return imageUrl;
  //     }
  //   } catch (e) {
  //        WasteLoaders.errorSnackBar(
  //         title: "Oops!", message: "Something went wrong when uploading item image!: $e");
  //   } finally{
  //     imageUploading.value = false;

  //   }
  // }
}
