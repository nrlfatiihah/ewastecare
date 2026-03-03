// use and checked
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DownloadWasteData extends GetxController {
  static DownloadWasteData get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> getDataUsers() async {
    QuerySnapshot snapshot = await _db
        .collection('Users')
        // .where('date', isGreaterThanOrEqualTo: startDate)
        // .where('date', isLessThanOrEqualTo: endDate)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'UserId': doc.id,
        'FirstName': doc['FirstName'],
        'LastName': doc['LastName'],
        'Username': doc['Username'],
        'WastePoint': doc['WastePoint'].toString(),
        'Email': doc['Email'],
        'Age': doc['Age'],
        'Gender': doc['Gender'],
        'Address': doc['Address'],
        'PhoneNumber': doc['PhoneNumber'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataAdminDashboard(
    DateTime startDate,
    DateTime endDate,
  ) async {
    endDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    );
    QuerySnapshot snapshot = await _db
        .collection('AdminDashboard')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'RecordId': doc.id,
        'UserId': doc['UserID'],
        'TotalPP': doc['TypePP'].toString(),
        'TotalPET': doc['TypePET'].toString(),
        'TotalHDPE': doc['TypeHDPE'].toString(),
        'TotalAllPlastic': doc['TotalAllPlastic'].toString(),
        'TotalWastePoints': doc['TotalWastePoints'].toString(),
        'Date': doc['date'].toDate(), // Convert Firestore timestamp to DateTime
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataUsersDashboard() async {
    QuerySnapshot snapshot = await _db
        .collection('UserDashboard')
        // .where('date', isGreaterThanOrEqualTo: startDate)
        // .where('date', isLessThanOrEqualTo: endDate)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'UserId': doc.id,
        'TierLevel': doc['TierLevel'],
        'TotalPP': doc['TypePP'].toString(),
        'TotalPET': doc['TypePET'].toString(),
        'TotalHDPE': doc['TypeHDPE'].toString(),
        'TotalAllPlastic': doc['TotalAllPlastic'].toString(),
        'TotalWastePoints': doc['TotalPoints']
            .toString(), // Convert Firestore timestamp to DateTime
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataTransactions(
    DateTime startDate,
    DateTime endDate,
  ) async {
    endDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      23,
      59,
      59,
      999,
    );
    QuerySnapshot snapshot = await _db
        .collection('Transactions')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'TransactionId': doc.id,
        'UserId': doc['userId'],
        'Type': doc['type'],
        'Description': doc['description'],
        'Amount': doc['amount'].toString(),
        'Date': doc['date'].toDate(), // Convert Firestore timestamp to DateTime
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataProducts() async {
    QuerySnapshot snapshot = await _db
        .collection('Products')
        // .where('date', isGreaterThanOrEqualTo: startDate)
        // .where('date', isLessThanOrEqualTo: endDate)
        // .orderBy('date', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'ProductID': doc.id,
        'ProductName': doc['productName'],
        'Description': doc['Description'],
        'ProductPrice': doc['WastePoint']
            .toString(), // Convert Firestore timestamp to DateTime
        'Stock': doc['Stock']
            .toString(), // Convert Firestore timestamp to DateTime
      };
    }).toList();
  }
}
