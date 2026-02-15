// import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionModel {
//   final String id; // Unique identifier for each transaction
//   final String type; // Type of transaction (e.g., "Add Point", "Redeem Item")
//   final bool isCredit; // true if points are added, false if points are deducted
//   final int amount; // Amount of points added or deducted
//   final Timestamp date; // Date and time of the transaction
//   final String logoType; // Type of logo to show (e.g., "add", "redeem")

//   TransactionModel({
//     required this.id,
//     required this.type,
//     required this.isCredit,
//     required this.amount,
//     required this.date,
//     required this.logoType,
//   });

//     // Empty funct for clean code
//   static TransactionModel empty() => TransactionModel(
//         id: "",
//         type:"",
//         isCredit:false,
//         amount: 0,
//         date: Timestamp.now(),
//         logoType: '',
//       );

//   // Factory method to create a Transaction from a map (e.g., from Firestore document)
//   // factory TransactionModel.fromJson(Map<String, dynamic> json) {
//   //   return TransactionModel(
//   //     id: json['id'],
//   //     type: json['type'],
//   //     isCredit: json['isCredit'],
//   //     amount: json['amount'],
//   //     date: DateTime.parse(json['date']),
//   //     logoType: json['logoType'],
//   //   );
//   // }

//   factory TransactionModel.fromSnapshot(DocumentSnapshot document) {
//     if (document.data() == null) return TransactionModel.empty();
//     final data = document.data() as Map<String, dynamic>;
//     return TransactionModel(
//       id: document.id,
//       type: data['type'],
//       isCredit: data['isCredit'],
//       amount: data['amount'],
//       date: data ['date'],
//       logoType: data['logoType'],
//     );
//   }

//   // Method to convert a Transaction to a map (e.g., for storing in Firestore)
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'type': type,
//       'isCredit': isCredit,
//       'amount': amount,
//       'date': date,
//       'logoType': logoType,
//     };
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';

// class TransactionModel {
//   final String id;
//   final String userId;
//   final String type; // 'add' or 'redeem'
//   final int amount;
//   final String description;
//   final DateTime date;

//   TransactionModel({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.amount,
//     required this.description,
//     required this.date,
//   });

//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       id: json['id'],
//       userId: json['userId'],
//       type: json['type'],
//       amount: json['amount'],
//       description: json['description'],
//       date: (json['date'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'type': type,
//       'amount': amount,
//       'description': description,
//       'date': date,
//     };
//   }

  // factory TransactionModel.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return TransactionModel(
  //     id: doc.id,
  //     amount: data['amount'],
  //     date: (data['date'] as Timestamp).toDate(),
  //     description: data['description'],
  //     type: data['type'],
  //     userId: data['userId'],
  //   );
  // }

//   factory TransactionModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     if (document.data() != null) {
//       final data = document.data()!;
//       return TransactionModel(
//         id: document.id,
//         amount: data['amount'] ?? "",
//         date: (data['date'] as Timestamp).toDate(),
//         description: data['description'] ?? "",
//         type: data['type'] ?? "",
//         userId: data['userId'] ?? "",
//       );
//     } else {
//       throw Exception("Documents data is null");
//     }
//   }

//   static TransactionModel empty() => TransactionModel(
//       id: "", 
//       userId: "",
//       type: "", 
//       amount: 0, 
//       description: "", 
//       date: DateTime.now()
//       );
// }



import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String type; // 'add' or 'redeem'
  final int amount;
  final String description;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
    };
  }

  factory TransactionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return TransactionModel(
        id: document.id,
        amount: data['amount'] ?? 0,
        date: (data['date'] as Timestamp).toDate(),
        description: data['description'] ?? "",
        type: data['type'] ?? "",
        userId: data['userId'] ?? "",
      );
    } else {
      throw Exception("Document data is null");
    }
  }

   factory TransactionModel.fromSnapshot2(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return TransactionModel(
      id: snapshot.id,
      amount: data['amount'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'],
      type: data['type'],
      userId: data['userId'],
    );
  }

  static TransactionModel empty() => TransactionModel(
        id: "",
        userId: "",
        type: "",
        amount: 0,
        description: "",
        date: DateTime.now(),
      );
}

