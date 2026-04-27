// use and checked
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';
import 'package:ewastecare/features/personalization/models/user_model.dart';
import 'package:ewastecare/features/transaction/model/transaction_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Function to save user data to firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Build an address-based CustomUserId and append a numeric suffix when needed.
  Future<String> generateUniqueCustomUserIdFromAddress(String address) async {
    try {
      final base = UserModel.generateCustomUserIdFromAddress(address);
      var candidate = base;
      var suffix = 2;

      while (suffix < 10000) {
        final existing = await _db
            .collection("Users")
            .where("CustomUserId", isEqualTo: candidate)
            .limit(1)
            .get();

        if (existing.docs.isEmpty) return candidate;

        final suffixText = suffix.toString();
        final maxBaseLength = 100 - suffixText.length;
        final trimmedBase = base.length > maxBaseLength
            ? base.substring(0, maxBaseLength)
            : base;
        candidate = '$trimmedBase$suffixText';
        suffix++;
      }

      throw "Unable to generate a unique CustomUserId. Please try again.";
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Resolve either a Firebase Auth user ID or a scanned CustomUserId.
  Future<String?> resolveUserIdFromInput(String input) async {
    try {
      final trimmedInput = input.trim();
      if (trimmedInput.isEmpty) return null;

      final directDoc = await _db.collection("Users").doc(trimmedInput).get();
      if (directDoc.exists) {
        return trimmedInput;
      }

      final customIdSnapshot = await _db
          .collection("Users")
          .where("CustomUserId", isEqualTo: trimmedInput)
          .limit(1)
          .get();

      if (customIdSnapshot.docs.isNotEmpty) {
        return customIdSnapshot.docs.first.id;
      }

      return null;
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Function to fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Function to update user data in Firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Update any field in specific user collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Function to remove user data from Firestore
  Future<void> removeUserRecord(String userID) async {
    try {
      await _db.collection("Users").doc(userID).delete();
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  // Getting the user's current Waste point from database
  Future<int> fetchUserWastePoints(String userid) async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(userid).get();
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data();
        if (userData != null && userData.containsKey('WastePoint')) {
          final wastePoints = userData['WastePoint'] as int?;
          if (wastePoints != null) {
            return wastePoints;
          }
        }
      }
      return 0;
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Error fetching user WastePoint: $e";
    }
  }

  // Updating the new Waste point after claiming point
  Future<void> updateUserWastePoints(String userid, int newPoints) async {
    try {
      final documentReference = _db.collection("Users").doc(userid);
      await documentReference.update({'WastePoint': newPoints});
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Error updating user WastePoint: $e";
    }
  }

  // Function to check if the user already has a qr code id or not
  Future<bool> checkUserQR(String userId) async {
    try {
      final docSnapshot = await _db.collection('Users').doc(userId).get();
      final userQR = docSnapshot.data()?['UserQR'];
      return userQR == null || userQR.isEmpty;
    } catch (e) {
      return true; // Assume QR is empty if an error occurs
    }
  }

  // Generate User qr code, render in image format and save in database
  Future<String> generateAndSaveQRCode(
    String authUserId, {
    String? qrData,
    String? customUserId,
  }) async {
    try {
      // qrData can be a custom display ID while authUserId remains the
      // Firestore/Storage key to keep user records consistent.
      final payload = qrData ?? authUserId;
      final qrPainter = QrPainter(
        data: payload,
        version: QrVersions.auto,
        gapless: true,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF000000),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF000000),
        ),
      );

      // Convert QR image to bytes
      final picData = await qrPainter.toImageData(200);
      final imageData = picData!.buffer.asUint8List();

      // Upload QR code image to Firebase Storage
      final storageRef = _storage.ref().child(
        'Users/Images/qr_codes/$authUserId.png',
      );
      await storageRef.putData(imageData);

      // Get download URL of the uploaded QR code image
      final downloadUrl = await storageRef.getDownloadURL();

      // Update UserQR field in Firestore with the download URL
      await _db.collection('Users').doc(authUserId).update({
        'UserQR': downloadUrl,
        if (customUserId != null && customUserId.isNotEmpty)
          'CustomUserId': customUserId,
      });

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // fetch transaction history data
  Future<List<TransactionModel>> fetchTransactions(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => TransactionModel.fromSnapshot(doc))
            .toList();
      } else {
        print("No data found");
        return [];
      }
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

  Future<List<TransactionModel>> fetchDetailsTransactions(
    String userId, [
    DateTime? startDate,
    DateTime? endDate,
  ]) async {
    try {
      Query query = _db
          .collection('Transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true);

      if (startDate != null && endDate != null) {
        // Set endDate to the end of the day
        endDate = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
          999,
        );
        query = query
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map(
              (doc) => TransactionModel.fromSnapshot(
                doc as QueryDocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();
      } else {
        return [];
      }
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
