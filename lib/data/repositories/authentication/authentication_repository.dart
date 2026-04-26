// use and checked
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/admin_navigation_menu.dart';
import 'package:ewastecare/data/repositories/user/user_repository.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/authentication/screens/welcome/welcome.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/login.dart';
import 'package:ewastecare/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ewastecare/features/authentication/screens/signup/admin_signup/admin_verify_email.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/verify_email.dart';
import 'package:ewastecare/user_navigation_menu.dart';
import 'package:ewastecare/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

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
    userScreenRedirect();
  }

  // safest choice
  Future<void> userScreenRedirect() async {
    final user = _auth.currentUser;
    final box = GetStorage();
    final isUserLoggedIn =
        box.read('user_logged_in') ?? false; // Check login flag
    final isAdminLoggedIn = box.read('admin_logged_in') ?? false;

    if (user != null) {
      if (!user.emailVerified) {
        if (isAdminLoggedIn) {
          Get.offAll(
            () => AdminVerifyEmailScreen(email: _auth.currentUser?.email),
          );
          return;
        }

        Get.offAll(
          () => VerifyEmailScreen(email: _auth.currentUser?.email, role: ''),
        );
        return;
      }

      if (isUserLoggedIn) {
        Get.offAll(() => const UserNavigationMenu());
        return;
      }

      if (isAdminLoggedIn) {
        final isApproved = await AdminAuthenticationRepository.instance
            .isAdminApproved(user.uid);

        if (isApproved) {
          Get.offAll(() => const AdminNavigationMenu());
        } else {
          await AdminAuthenticationRepository.instance.logout();
        }
        return;
      }

      if (!isUserLoggedIn && !isAdminLoggedIn) {
        Get.offAll(() => const Welcome());
        return;
      }
    } else {
      // User not logged in, handle first-time launch or other scenarios
      deviceStorage.writeIfNull("isFirstTime", true);
      deviceStorage.read("isFirstTime") != true
          ? Get.offAll(() => const Welcome()) // Redirect to welcome screen
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
  Future<String?> getUserRole(String uid) async {
    try {
      // Get user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get();

      // Check if user document exists
      if (userDoc.exists) {
        // Get the role field from the user document
        final role = userDoc.get("Role");

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

  /// reauth - reauth user
  Future<void> reAuthenticateEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      // Reauthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
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

  /// emailAuthentication - forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
      final box = GetStorage();

      box.remove('admin_logged_in');
      box.remove('user_logged_in');
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const Welcome());
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

  // DeleteUser - Remove user Auth and Firestore Account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
      Get.offAll(() => const LoginScreen());
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
