import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String id;
  String username;
  final String email;
  String profilePicture;
  final String role;


  AdminModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.role,
  });


  // static function to create an empty user model
  static AdminModel empty() => AdminModel(
        id: "",
        username: "",
        email: "",
        profilePicture: "",
        role: "",
      );

  // convert model to JSON structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Email": email,
      "ProfilePicture": profilePicture,
      "Role": role,
    };
  }

  // factory method to create a AdminModel from a firebase document snapshot

  factory AdminModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AdminModel(
        id: document.id,
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
