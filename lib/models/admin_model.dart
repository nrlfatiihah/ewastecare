import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String id;
  String username;
  final String email;
  String profilePicture;
  final String role;

  AdminModel({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Username": username,
      "Email": email,
      "ProfilePicture": profilePicture,
      "Role": role,
    };
  }

  factory AdminModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return AdminModel(
        id: data["ID"] ?? "",
        username: data["Username"] ?? "",
        email: data["Email"] ?? "",
        profilePicture: data["ProfilePicture"] ?? "",
        role: data["Role"] ?? "",
      );
    } else {
      throw Exception("Document data is null");
    }
  }
}
