import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardModel {
  final String id;
  final String userId;
  final double pp;
  final double pet;
  final double hdpe;
  final int totalEcoPoints;
  final double totalAllPlastic;
  final DateTime date;

  AdminDashboardModel({
    required this.id,
    required this.userId,
    required this.pp,
    required this.pet,
    required this.hdpe,
    required this.totalEcoPoints,
    required this.totalAllPlastic,
    required this.date,
  });

  static AdminDashboardModel empty() => AdminDashboardModel(
      id: '',
      userId: '',
      pp: 0.0,
      pet: 0.0,
      hdpe: 0.0,
      totalEcoPoints: 0,
      totalAllPlastic: 0.0,
      date: DateTime.now());

  toJson() {
    return {
      "id":id,
      "UserID": userId,
      "TypePP": pp,
      "TypePET": pet,
      "TypeHDPE": hdpe,
      "TotalEcoPoints": totalEcoPoints,
      "TotalAllPlastic": totalAllPlastic,
      "date": date,
    };
  }

  factory AdminDashboardModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return AdminDashboardModel.empty();
    final data = document.data()!;
    return AdminDashboardModel(
      id: document.id,
      userId: data["userId"] ?? "",
      pp: data["TypePP"],
      pet: data["TypePET"],
      hdpe: data["TypeHDPE"],
      totalEcoPoints: data["TotalEcoPoints"],
      totalAllPlastic: data["TotalAllPlastic"],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
