import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel {
  final String id;
  final String name;
  final String role;
  final String profilePicture;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.profilePicture,
  });

  factory ChatUserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final firstName = data['FirstName'] ?? '';
    final lastName = data['LastName'] ?? '';
    final username = data['Username'] ?? '';
    final role = (data['Role'] ?? '').toString().toLowerCase();
    final profilePicture = (data['ProfilePicture'] ?? '').toString();
    final combinedName = ('$firstName $lastName').trim();

    return ChatUserModel(
      id: doc.id,
      name: combinedName.isNotEmpty ? combinedName : username,
      role: role,
      profilePicture: profilePicture,
    );
  }

  bool get isAdmin => role == 'admin';
}
