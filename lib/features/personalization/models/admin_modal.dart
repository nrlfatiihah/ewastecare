import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String id;
  String username;
  final String email;
  String profilePicture;
  final String role;
  final bool approved;
  final bool isDeveloper;

  AdminModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.role,
    this.approved = false,
    this.isDeveloper = false,
  });

  // static function to create an empty user model
  static AdminModel empty() => AdminModel(
    id: "",
    username: "",
    email: "",
    profilePicture: "",
    role: "",
    approved: false,
    isDeveloper: false,
  );

  // convert model to JSON structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Email": email,
      "ProfilePicture": profilePicture,
      "Role": role,
      "Approved": approved,
      "IsDeveloper": isDeveloper,
    };
  }

  // factory method to create a AdminModel from a firebase document snapshot

  factory AdminModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return AdminModel(
        id: document.id,
        username: data["Username"] ?? "",
        email: data["Email"] ?? "",
        profilePicture: data["ProfilePicture"] ?? "",
        role: data["Role"] ?? "",
        approved: data["Approved"] ?? false,
        isDeveloper: data["IsDeveloper"] ?? false,
      );
    } else {
      throw Exception("Document data is null");
    }
  }
}
