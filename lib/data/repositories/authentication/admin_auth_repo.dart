// use and checked
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/admin_navigation_menu.dart';
import 'package:ewastecare/features/authentication/screens/welcome/welcome.dart';
import 'package:ewastecare/features/authentication/screens/login/login_admin/admin_login.dart';
import 'package:ewastecare/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ewastecare/features/authentication/screens/signup/admin_signup/admin_verify_email.dart';
import 'package:ewastecare/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminAuthenticationRepository extends GetxController {
  static AdminAuthenticationRepository get instance => Get.find();

  // variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Get authenticate user data
  User? get authUser => _auth.currentUser;

  // called from main.dart on app launch
  @override
  void onReady() {
    // Remove the native splash screen
    FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    adminScreenRedirect();
  }

  Future<void> adminScreenRedirect() async {
    final user = _auth.currentUser;
    final box = GetStorage();
    final isAdminLoggedIn =
        box.read('admin_logged_in') ?? false; // Check login flag

    if (user != null) {
      if (user.emailVerified && isAdminLoggedIn) {
        // If the user did not log in using the adminEmailAndPasswordSignIn function, redirect to ChooseRole
        Get.offAll(() => const AdminNavigationMenu());
        return;
      } else if (user.emailVerified) {
        // If the user did not log in using the adminEmailAndPasswordSignIn function, redirect to ChooseRole
        Get.offAll(() => const Welcome());
        return;
      } else {
        // User email not verified, redirect to email verification screen
        Get.offAll(
          () => AdminVerifyEmailScreen(email: _auth.currentUser?.email),
        );
      }
    } else {
      // User not logged in, handle first-time launch or other scenarios
      deviceStorage.writeIfNull("isFirstTime", true);
      deviceStorage.read("isFirstTime") != true
          ? Get.offAll(() => const Welcome()) // Redirect to choose role screen
          : Get.offAll(
              () => const OnBoardingScreen(),
            ); // Redirect to onboarding screen if user is first time
    }
  }

  /*-------------------------------- Email & Password sign-in -------------------------------*/

  /// Email auth - sign in
  ///
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw WasteFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, please try again.";
    }
  }

  // check user role
  Future<String?> getAdminRole(String uid) async {
    try {
      // Get user document from Firestore
      final adminDoc = await FirebaseFirestore.instance
          .collection("Admins")
          .doc(uid)
          .get();

      // Check if user document exists
      if (adminDoc.exists) {
        // Get the role field from the user document
        final role = adminDoc.get("Role");

        // Check if role is not null or empty
        if (role != null && role.isNotEmpty) {
          return role;
        } else {
          // If role is null or empty, return null
          return null;
        }
      } else {
        // If user document doesn't exist, return null
        return null;
      }
    } catch (e) {
      // Handle errors
      return null;
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw WasteFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, please try again.";
    }
  }

  /// emailVerification - email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw WasteFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, please try again.";
    }
  }

  // LogoutUser - Valid for any authentication.
  Future<void> logout() async {
    try {
      // await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const AdminLoginScreen());
    } on FirebaseAuthException catch (e) {
      throw WasteFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, please try again.";
    }
  }
}
