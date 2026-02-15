import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/login.dart';
import 'package:ewastecare/features/authentication/screens/qrcode/user/user_qr.dart';
import 'package:ewastecare/features/personalization/models/user_model.dart';
import 'package:ewastecare/features/personalization/screens/profile/widget/re_authenticate_user_login.dart';
import 'package:ewastecare/features/transaction/model/transaction_model.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/network_manager.dart';
import 'package:ewastecare/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  //static UserController get instance => Get.find<UserController>();
  static UserController get instance => Get.put(UserController());

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  bool dataFetched = false;

  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool dataFetched2 = false.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    fetchTransactions();
  }

  // fetch user record
  // Future<void> fetchUserRecord() async {
  //   try {
  //     profileLoading.value = true;
  //     final user = await userRepository.fetchUserDetails();
  //     this.user(user);
  //   } catch (e) {
  //     user(UserModel.empty());
  //   } finally {
  //     profileLoading.value = false;
  //   }
  // }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      if (!dataFetched) {
        final user = await userRepository.fetchUserDetails();
        this.user(user);
        dataFetched = true;
      }
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> fetchTransactions() async {
    try {
      final userId =
          await getCurrentUserId(); // Function to retrieve current user ID
      dataFetched2.value = false;
      transactions.value = await userRepository.fetchTransactions(userId);
    } catch (e) {
      print('Error fetching transactions: $e');
      transactions.value = [];
    } finally {
      dataFetched2.value = true;
    }
  }

  //  Future<void> fetchDetailsTransactions([DateTime? startDate, DateTime? endDate]) async {
  //     try {
  //       final userId = FirebaseAuth.instance.currentUser?.uid;
  //       if (userId == null) {
  //         throw Exception("User is not authenticated");
  //       }

  //       dataFetched2.value = false;
  //       transactions.value = await userRepository.fetchDetailsTransactions(userId, startDate, endDate);
  //       dataFetched2.value = true;
  //     } catch (e) {
  //       print('Error fetching transactions: $e');
  //       transactions.value = [];
  //       dataFetched2.value = true;
  //     }
  //   }

  Future<void> fetchDetailsTransactions([
    DateTime? startDate,
    DateTime? endDate,
  ]) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("User is not authenticated");
      }

      dataFetched2.value = true;
      transactions.value = await userRepository.fetchDetailsTransactions(
        userId,
        startDate,
        endDate,
      );
    } catch (e) {
      transactions.value = [];
    } finally {
      dataFetched2.value = false;
    }
  }

  void setDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
  }

  Future<String> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle case where user is not signed in
      throw Exception("User is not signed in");
    }
  }

  void resetDataFetched() {
    dataFetched = false;
  }

  // Save user record from any registation provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      await fetchUserRecord();
      if (userCredentials != null) {
        // Converts name to first name and last name
        final nameParts = UserModel.nameParts(
          userCredentials.user!.displayName ?? "",
        );
        final username = UserModel.generateUsername(
          userCredentials.user!.displayName ?? "",
        );

        // Map Data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join("") : "",
          username: username,
          homeAddress: "",
          gender: "",
          age: "",
          email: userCredentials.user!.email ?? "",
          phoneNo: userCredentials.user!.phoneNumber ?? "",
          profilePicture: userCredentials.user!.photoURL ?? "",
          ecoPoint: 0,
          role: "user",
          userQR: "",
        );

        // save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      WasteLoaders.warningSnackBar(
        title: "Data not saved",
        message:
            "Something went wrong while saving your information. Ypu can resave your data in your Profile.",
      );
    }
  }

  // Delete acc warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(WasteSizes.md),
      title: "Delete Account",
      middleText: "Are you sure you want to delete the account?",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: WasteSizes.lg),
          child: Text("Delete"),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text("Cancel"),
      ),
    );
  }

  void deleteUserAccount() async {
    try {
      WasteFullScreenLoader.openLoadingDialog(
        "Processing",
        WasteImages.docerAnimation,
      );

      //First re-auth user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData
          .map((e) => e.providerId)
          .first;
      if (provider.isNotEmpty) {
        //Re verify Auth Email
        if (provider == "google.com") {
          await auth.deleteAccount();
          WasteFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == "password") {
          WasteFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthUserLoginForm());
        }
      }
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.warningSnackBar(title: "Oops!", message: e.toString());
    }
  }

  Future<void> reAuthenticateEmaiAndPassword() async {
    try {
      WasteFullScreenLoader.openLoadingDialog(
        "Processing",
        WasteImages.docerAnimation,
      );

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        WasteFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await AuthenticationRepository.instance.deleteAccount();
      WasteFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.warningSnackBar(title: "Oops!", message: e.toString());
    }
  }

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
        final imageUrl = await userRepository.uploadImage(
          "Users/Images/Profile/",
          image,
        );

        //Update user image Record
        Map<String, dynamic> json = {"ProfilePicture": imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        WasteLoaders.successSnackBar(
          title: "Congratulations",
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

  // get user qr image and redirect to userQrCode page
  Future<String> generateAndSaveQRCode(String userId) async {
    try {
      final downloadUrl = await userRepository.generateAndSaveQRCode(userId);
      user.update((val) {
        val?.userQR = downloadUrl;
      });

      Get.to(() => const UserQrCode());

      return downloadUrl;
    } catch (e) {
      WasteFullScreenLoader.stopLoading();
      WasteLoaders.errorSnackBar(title: "Oops!", message: e.toString());
      rethrow;
    }
  }
}
