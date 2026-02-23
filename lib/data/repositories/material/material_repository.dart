import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/waste_point/model/add_point_model.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/features/waste_point/model/point_result.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';

class MaterialRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Check if rateId is unique
  Future<bool> isIdUnique(String rateId) async {
    try {
      // Query the collection to see if the document exists
      final docSnapshot = await _db
          .collection('MaterialTypes')
          .doc('YourMaterialType') // Replace with the actual material type
          .collection('materials')
          .doc(rateId)
          .get();

      return !docSnapshot.exists;
    } catch (e) {
      print('Error checking ID uniqueness: $e');
      return false;
    }
  }

  // Save material record to Firestore
  Future<void> saveMaterialRecord(MaterialModel material) async {
    try {
      // Save material to the Firestore collection using rateId as the document ID
      await _db
          .collection('MaterialTypes')
          .doc(material.type)
          .collection('materials')
          .doc(material.name)
          .set(material.toMap());

      print('Material saved successfully');
    } catch (e) {
      print('Error saving material record: $e');
    }
  }

  // Fetch all materials from a specific type
  Future<List<MaterialModel>> fetchAllMaterials(String materialType) async {
    try {
      final querySnapshot = await _db
          .collection('MaterialTypes')
          .doc(materialType)
          .collection('materials')
          .get();

      return querySnapshot.docs.map((doc) {
        return MaterialModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching materials: $e');
      return [];
    }
  }
  //   Future<List<T>> fetchAllMaterials<T>(String materialType, T Function(Map<String, dynamic>) fromMap) async {
  //   try {
  //     final querySnapshot = await _db
  //         .collection('MaterialTypes')
  //         .doc(materialType)
  //         .collection('materials')
  //         .get();

  //     return querySnapshot.docs.map((doc) {
  //       return fromMap(doc.data());
  //     }).toList();
  //   } catch (e) {
  //     print('Error fetching materials: $e');
  //     return [];
  //   }
  // }

  // Update material value
  Future<void> updateMaterialValue(
    String materialType,
    String materialName,
    double newValue,
  ) async {
    try {
      await _db
          .collection('MaterialTypes')
          .doc(materialType)
          .collection('materials')
          .doc(materialName)
          .update({'value': newValue});
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

  Future<void> saveUserPoints(AllocatePoint transaction) async {
    try {
      await _db
          .collection('AllocatePoint')
          .doc(transaction.transactionId)
          .set(transaction.toMap());
    } catch (e) {
      print('Error saving transaction: $e');
      rethrow; // Optionally rethrow to let the controller handle errors
    }
  }

  Future<Map<String, double>> fetchMaterialValues() async {
    Map<String, double> materialValues = {};

    List<String> materialTypes = [
      'Can',
      'Paper',
      'Plastic',
      'Used Oil',
      "Others",
    ];

    try {
      // Loop through each hardcoded material type
      for (var materialType in materialTypes) {
        // Get the sub-collection of materials within each material type
        final materialsSnapshot = await FirebaseFirestore.instance
            .collection('MaterialTypes')
            .doc(materialType)
            .collection('materials')
            .get();

        // Loop through each material in the sub-collection
        for (var materialDoc in materialsSnapshot.docs) {
          print('Material found: ${materialDoc.id}');
          // Extract the material name and value
          final materialName = materialDoc.data()['name'];
          final materialValue = materialDoc.data()['value']?.toDouble() ?? 0.0;

          // Print the material name and value for debugging
          print('Fetched Material: $materialName, Value: $materialValue');

          // Add the material to the map
          materialValues[materialName] = materialValue;
        }
      }
    } catch (e) {
      print('Error fetching material values: $e');
    }

    return materialValues;
  }

  //   Future<int> calculateTotalPoints(Map<String, Map<String, double>> materials) async {
  //   double totalPoints = 0.0;
  //   int finalPoints = 0;

  //   // Fetch the material values from the database
  //   final materialValues = await fetchMaterialValues();

  //   // Iterate through each material category and its materials
  //   materials.forEach((category, materialMap) {
  //     materialMap.forEach((material, weight) {
  //       // Retrieve the value for the specific material from the fetched data
  //       final value = materialValues[material] ?? 0.0;

  //       // Calculate the points for the material and add to the total
  //       totalPoints += weight * value;
  //     });
  //   });

  //   totalPoints = double.parse(totalPoints.toStringAsFixed(2));
  //   finalPoints = (totalPoints * 100).toInt();

  //   return finalPoints;
  // }

  Future<PointsResult> calculateTotalPoints(
    Map<String, Map<String, double>> materials,
  ) async {
    double totalPrice = 0.0;

    // Fetch the material values from the database
    final materialValues = await fetchMaterialValues();

    // Iterate through each material category and its materials
    materials.forEach((category, materialMap) {
      materialMap.forEach((material, weight) {
        // Retrieve the value for the specific material from the fetched data
        final value = materialValues[material] ?? 0.0;

        // Calculate the points for the material and add to the total
        totalPrice += weight * value;
      });
    });

    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    int finalPoints = (totalPrice * 100).toInt();

    // Return both totalPoints and finalPoints in the PointsResult class
    return PointsResult(totalPrice: totalPrice, finalPoints: finalPoints);
  }
}
