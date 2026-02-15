// import 'package:cloud_firestore/cloud_firestore.dart';

// class AllocatePoint {
//   String transactionId;
//   String userId;
//   int totalPoints;
//   DateTime transactionDate;
//   Map<String, Map<String, double>> materials; // Grouped materials (plastics, papers, etc.)

//   AllocatePoint({
//     required this.transactionId,
//     required this.userId,
//     required this.totalPoints,
//     required this.transactionDate,
//     required this.materials,
//   });

//   // Factory method to create a model from Firestore data
//   factory AllocatePoint.fromMap(Map<String, dynamic> map) {
//     return AllocatePoint(
//       transactionId: map['transactionId'],
//       userId: map['userId'],
//       totalPoints: map['totalPoints'],
//       transactionDate: (map['transactionDate'] as Timestamp).toDate(),
//       materials: Map<String, Map<String, double>>.from(map['materials']),
//     );
//   }

//   // Method to convert the model to a Firestore-friendly map
//   Map<String, dynamic> toMap() {
//     return {
//       'transactionId': transactionId,
//       'userId': userId,
//       'totalPoints': totalPoints,
//       'transactionDate': transactionDate,
//       'materials': materials,
//     };
//   }
// }

class AllocatePoint {
  final String transactionId;
  final String userId;
  final int totalPoints;
  final double totalPrice;
  final DateTime transactionDate;
  final Map<String, Map<String, double>> materials;
  final Map<String, Map<String, double>> prices; // New field for prices

  AllocatePoint({
    required this.transactionId,
    required this.userId,
    required this.totalPoints,
    required this.totalPrice,
    required this.transactionDate,
    required this.materials,
    required this.prices, // Include prices in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'totalPoints': totalPoints,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'materials': materials,
      'prices': prices, // Add prices to the map for saving
    };
  }
}
