// use and checked
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/transaction/model/transaction_model.dart';
import 'package:ewastecare/utils/exceptions/firebase_exceptions.dart';
import 'package:ewastecare/utils/exceptions/format_exceptions.dart';
import 'package:ewastecare/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TransactionRepository extends GetxController {
  final CollectionReference transactionCollection = FirebaseFirestore.instance
      .collection('Transactions');

  Future<void> logTransaction({
    required String userId,
    required String type,
    required int amount,
    required String description,
  }) async {
    try {
      await transactionCollection.add({
        'userId': userId,
        'type': type,
        'amount': amount,
        'description': description,
        'date': Timestamp.now(), // Include the current timestamp
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
      throw 'Error logging transaction: $e';
    }
  }

  // Used this for new transactions add point log
  Future<void> AddPointLog({
    required String userId,
    required String type,
    required int amount,
    required String description,
  }) async {
    try {
      await transactionCollection.add({
        'userId': userId,
        'type': type,
        'amount': amount,
        'description': description,
        'date': Timestamp.now(), // Include the current timestamp
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
      throw 'Error logging transaction: $e';
    }
  }

  Future<List<TransactionModel>> fetchUserTransactions(String userId) async {
    try {
      // Query transactions for the specified user
      final querySnapshot = await transactionCollection
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      // Convert query snapshot to a list of TransactionModel objects
      return querySnapshot.docs
          .map(
            (doc) =>
                TransactionModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw WasteFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const WasteFormatException();
    } on PlatformException catch (e) {
      throw WastePlatformException(e.code).message;
    } on SocketException catch (e) {
      throw "Error socket ${e.message}";
    } catch (e) {
      throw 'Error fecthing user transactions: $e';
    }
  }
}
