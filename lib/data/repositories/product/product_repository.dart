// use and checked
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/data/services/firebase_storage_services.dart';
import 'package:ewastecare/features/store/models/product_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  // Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection("Products").get();
      // final list = snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
      // return list;
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
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

  Future<void> saveProductRecord(ProductModel products) async {
    try {
      await _db.collection("Products").doc(products.id).set(products.toJson());
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

  // Upload dummyy data to the Cloud Firebase
  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      // Upload all the products along with their images
      final storage = Get.put(WasteFirebaseStorageService());

      // Loop through each product
      for (var product in products) {
        // Get image data link from local assets
        final productImage = await storage.getImageDataFromAssets(
          product.productImage,
        );

        // Upload image and get its URL
        final url = await storage.uploadImageData(
          "Products/Images",
          productImage,
          product.productImage.toString(),
        );

        // Assigb URL to product.productImage attribute
        product.productImage = url;

        await _db.collection("Products").doc(product.id).set(product.toJson());
      }
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
          .collection('Products')
          .doc(id)
          .get();
      return !docSnapshot.exists;
    } catch (e) {
      return false; // Return false to be safe if there's an error
    }
  }

  Future<void> updateProductRecord(ProductModel products) async {
    try {
      await _db
          .collection("Products")
          .doc(products.id)
          .update(products.toJson());
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

  Future<Map<String, dynamic>> getProductData(String id) async {
    try {
      final DocumentSnapshot productDoc = await _db
          .collection('Products')
          .doc(id)
          .get();
      if (!productDoc.exists) {
        return {}; // Product not found
      }
      return productDoc.data() as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  Future<int> getProductStock(String productId) async {
    try {
      final DocumentSnapshot productDoc = await _db
          .collection('Products')
          .doc(productId)
          .get();
      if (productDoc.exists) {
        final productData = productDoc.data() as Map<String, dynamic>;
        return productData['Stock'] as int;
      } else {
        throw Exception('Product not found');
      }
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw Exception('Failed to fetch product stock');
    }
  }

  Future<int> getUserEcoPointBalance() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        return 0; // User not authenticated
      }
      final DocumentSnapshot userDoc = await _db
          .collection('Users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        return 0; // User data not found
      }
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['EcoPoint'] as int;
    } catch (e) {
      return 0;
    }
  }

  Future<void> updateProductStock(String id, int newStock) async {
    try {
      await _db.collection('Products').doc(id).update({'Stock': newStock});
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw 'Error updating product stock: $e';
    }
  }

  Future<void> updateUserEcoPointBalance(int newUserBalance) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        return; // User not authenticated
      }
      await _db.collection('Users').doc(user.uid).update({
        'EcoPoint': newUserBalance,
      });
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw 'Error updating user balance: $e';
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(
            'Products',
          ) // Assuming your collection is named 'products'
          .doc(id) // Use the product ID as the document ID
          .delete();
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
