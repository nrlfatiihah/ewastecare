import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/data/services/firebase_storage_services.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ModuleRepository extends GetxController {
  static ModuleRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all module
  Future<List<ModuleModel>> getAllMaterials() async {
    try {
      final snapshot = await _db.collection("Materials").get();
      return snapshot.docs.map((e) => ModuleModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> saveModuleRecord(ModuleModel module) async {
    try {
      await _db.collection("Materials").doc(module.id).set(module.toJson());
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<bool> isIdUnique(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _db
          .collection('Materials')
          .doc(id)
          .get();
      return !docSnapshot.exists;
    } catch (e) {
      return false; // Return false to be safe if there's an error
    }
  }

  // Future<void> updateModuleRecord(ModuleModel products) async {
  //   try {
  //     await _db
  //         .collection("Materials")
  //         .doc(module.id)
  //         .update(products.toJson());
  //   } on FirebaseException catch (e) {
  //     throw WasteFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const WasteFormatException();
  //   } on PlatformException catch (e) {
  //     throw WastePlatformException(e.code).message;
  //   } on SocketException catch (e) {
  //     throw "Error socket ${e.message}";
  //   } catch (e) {
  //     throw "Something went wrong, Please try again";
  //   }
  // }

  Future<Map<String, dynamic>> getModuleData(String id) async {
    try {
      final DocumentSnapshot moduleDoc = await _db
          .collection('Materials')
          .doc(id)
          .get();
      if (!moduleDoc.exists) {
        return {}; // Product not found
      }
      return moduleDoc.data() as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<void> deleteModule(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Materials').doc(id).delete();
      return;
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw 'Error deleting product: $e';
    }
  }
}
