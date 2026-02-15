import 'package:cloud_firestore/cloud_firestore.dart';

class TestDownloadWasteDataRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getDataUsers() async {
    QuerySnapshot snapshot = await _db
        .collection('Users')
        // .where('date', isGreaterThanOrEqualTo: startDate)
        // .where('date', isLessThanOrEqualTo: endDate)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'UserId': doc.id,
        'FirstName': data['FirstName'],
        'LastName': data['LastName'],
        'Username': data['Username'],
        'WastePoint': data['EcoPoint'].toString(),
        'Email': data['Email'],
        'Age': data['Age'],
        'Gender': data['Gender'],
        'Address': data['Address'],
        'PhoneNumber': data['PhoneNumber'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataAllocatePoint(
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
    print('Fetching data from Firestore between $startDate and $endDate');
    try {
      QuerySnapshot snapshot = await _db
          .collection('AllocatePoint')
          .where('transactionDate', isGreaterThanOrEqualTo: startDate)
          .where('transactionDate', isLessThanOrEqualTo: endDate)
          .orderBy('transactionDate', descending: false)
          .get();

      print('Documents fetched: ${snapshot.docs.length}');

      // Step 1: Collect all unique material keys
      final allMaterialKeys = <String>{};
      final allPriceKeys = <String>{};

      // First pass to gather all material keys
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final materials = data['materials'] as Map<String, dynamic>? ?? {};
        final prices = data['prices'] as Map<String, dynamic>? ?? {};

        materials.forEach((category, subfields) {
          final subfieldsMap = subfields as Map<String, dynamic>;
          subfieldsMap.forEach((subfield, _) {
            allMaterialKeys.add('${category}_$subfield (Kg)');
          });
        });

        prices.forEach((category, subfields) {
          final subfieldsMap = subfields as Map<String, dynamic>;
          subfieldsMap.forEach((subfield, _) {
            allPriceKeys.add('${category}_$subfield (RM)');
          });
        });
      }

      print('All material keys: $allMaterialKeys');
      print('All prices keys: $allPriceKeys');

      // Step 2: Process documents and fill missing material keys with default value 0
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final materials = data['materials'] as Map<String, dynamic>? ?? {};
        final prices = data['prices'] as Map<String, dynamic>? ?? {};
        final flatMaterials = <String, dynamic>{};
        final flatPrices = <String, dynamic>{};
        double totalWeight = 0.0;

        // Flatten materials map and calculate total weight
        materials.forEach((category, subfields) {
          final subfieldsMap = subfields as Map<String, dynamic>;
          subfieldsMap.forEach((subfield, value) {
            double materialWeight = value is num
                ? (value as double)
                : double.tryParse(value.toString()) ?? 0.0;
            flatMaterials['${category}_$subfield (Kg)'] = materialWeight;
            totalWeight += materialWeight; // Add to total weight
          });
        });

        prices.forEach((category, subfields) {
          final subfieldsMap = subfields as Map<String, dynamic>;
          subfieldsMap.forEach((subfield, value) {
            double price = value is num
                ? value.toDouble()
                : double.tryParse(value.toString()) ?? 0.0;
            flatPrices['${category}_$subfield (RM)'] = price;
          });
        });

        // Ensure all material keys are present
        for (var key in allMaterialKeys) {
          flatMaterials.putIfAbsent(key, () => 0.0);
        }
        for (var key in allPriceKeys) {
          flatPrices.putIfAbsent(key, () => 0.0);
        }

        // Print flatMaterials data
        print('Flat Materials for TransactionId ${doc.id}: $flatMaterials');

        return {
          'Transaction_Id': doc.id,
          'User_Id': data['userId'],
          'Transaction_Date': data['transactionDate']
              .toDate(), // Convert Firestore timestamp to DateTime
          ...flatMaterials, // Add flattened and completed materials
          ...flatPrices,
          'Total_Weight (Kg)': totalWeight,
          'Total_Value (RM)': data['totalPrice'].toString(),
          'Total_WastePoint': data['totalPoints'].toString(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching AllocatePoint data: $e');
      rethrow;
    }
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
        // .collection('AdminDashboardTry')
        .collection('MainAdminDashboard')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final materials = data['materials'] as Map<String, dynamic>? ?? {};
      final flatMaterials = <String, dynamic>{};

      // Flatten materials map and calculate total weight
      materials.forEach((category, subfields) {
        final subfieldsMap = subfields as Map<String, dynamic>;
        subfieldsMap.forEach((subfield, value) {
          double materialWeight = value is num
              ? (value as double)
              : double.tryParse(value.toString()) ?? 0.0;
          flatMaterials['${category}_$subfield (Kg)'] = materialWeight;
        });
      });

      return {
        'RecordId': doc.id,
        'UserId': data['UserID'],
        'Date': data['date']
            .toDate(), // Convert Firestore timestamp to DateTime
        ...flatMaterials, // Add flattened and completed
        'TotalMaterialWeight': data['totalWeightAllMaterials'].toString(),
        'TotalWastePoints': data['totalWastePoints'].toString(),
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDataUsersDashboard() async {
    QuerySnapshot snapshot = await _db
        .collection('UserDashboardTry')
        // .where('date', isGreaterThanOrEqualTo: startDate)
        // .where('date', isLessThanOrEqualTo: endDate)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final materials = data['materials'] as Map<String, dynamic>? ?? {};
      final flatMaterials = <String, dynamic>{};

      // Flatten materials map and calculate total weight
      materials.forEach((category, subfields) {
        final subfieldsMap = subfields as Map<String, dynamic>;
        subfieldsMap.forEach((subfield, value) {
          double materialWeight = value is num
              ? (value as double)
              : double.tryParse(value.toString()) ?? 0.0;
          flatMaterials['${category}_$subfield (Kg)'] = materialWeight;
        });
      });

      return {
        'UserId': doc.id,
        'TierLevel': data['TierLevel'],
        ...flatMaterials, // Add flattened and completed
        'TotalMaterialWeight': data['totalWeightAllMaterials'].toString(),
        'TotalWastePoints': data['totalWastePoints']
            .toString(), // Convert Firestore timestamp to DateTime
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
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return {
        'ProductID': doc.id,
        'ProductName': data['productName'],
        'Description': data['Description'],
        'ProductPrice': data['EcoPoint']
            .toString(), // Convert Firestore timestamp to DateTime
        'Stock': data['Stock']
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
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return {
        'TransactionId': doc.id,
        'UserId': data['userId'],
        'Type': data['type'],
        'Description': data['description'],
        'Amount': data['amount'].toString(),
        'Date': data['date']
            .toDate(), // Convert Firestore timestamp to DateTime
      };
    }).toList();
  }
}
