// use and checked
import 'dart:io';
import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

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
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/dfcwleooo/image/upload",
      );

      final request = http.MultipartRequest("POST", uri);

      request.fields['upload_preset'] = 'ewastecare_preset';

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decoded = json.decode(responseData);

      if (response.statusCode == 200) {
        return decoded['secure_url'];
      } else {
        throw "Image upload failed";
      }
    } catch (e) {
      throw "Cloudinary upload error: $e";
    }
  }

  // Getting the user's current Waste point from database
  Future<int> fetchUserEcoPoints(String userid) async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(userid).get();
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data();
        if (userData != null && userData.containsKey('EcoPoint')) {
          final ecoPoints = userData['EcoPoint'] as int?;
          if (ecoPoints != null) {
            return ecoPoints;
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
      throw "Error fetching user EcoPoint: $e";
    }
  }

  // Updating the new Waste point after claiming point
  Future<void> updateUserEcoPoints(String userid, int newPoints) async {
    try {
      final documentReference = _db.collection("Users").doc(userid);
      // Convert newPoints to String
      // String ecoPointsAsString = newPoints.toString();
      // Update EcoPoint field with the converted value
      // await documentReference.update({'EcoPoint': ecoPointsAsString});
      await documentReference.update({'EcoPoint': newPoints});
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } catch (e) {
      throw "Error updating user EcoPoint: $e";
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
  Future<String> generateAndSaveQRCode(String userId) async {
    try {
      // 1️⃣ Generate QR code for the user ID
      final qrPainter = QrPainter(
        data: userId,
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

      // 2️⃣ Convert QR code to PNG bytes
      final picData = await qrPainter.toImageData(200);
      if (picData == null) throw "Failed to generate QR image data";
      final qrBytes = picData.buffer.asUint8List();

      // 3️⃣ Save the QR image temporarily
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$userId.png';
      final file = File(filePath);
      await file.writeAsBytes(qrBytes);

      // 4️⃣ Upload QR image to Cloudinary
      final qrUrl = await _uploadQRCodeToCloudinary(filePath, userId);

      // 5️⃣ Save the QR code URL in Firestore under "UserQR"
      await _db.collection('Users').doc(userId).update({'UserQR': qrUrl});

      return qrUrl;
    } catch (e) {
      throw "Failed to generate/save user QR code: $e";
    }
  }

  // Helper function to upload QR image to Cloudinary
  Future<String> _uploadQRCodeToCloudinary(
    String filePath,
    String userId,
  ) async {
    try {
      final cloudName = "dfcwleooo";
      final uploadPreset = "ewastecare_preset";
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final file = File(filePath);
      final mimeType = lookupMimeType(filePath) ?? 'image/png';
      final mimeParts = mimeType.split('/');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );

      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final secureUrl = RegExp(
          r'"secure_url"\s*:\s*"(.+?)"',
        ).firstMatch(resBody.body)?.group(1);
        if (secureUrl != null) return secureUrl;
        throw "Failed to get QR image URL from Cloudinary";
      } else {
        throw "Cloudinary upload failed: ${resBody.body}";
      }
    } catch (e) {
      throw "Cloudinary QR upload error: $e";
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
