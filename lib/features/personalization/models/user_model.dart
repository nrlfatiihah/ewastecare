import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  String homeAddress;
  String gender;
  String dateOfBirth;
  final String email;
  String phoneNo;
  String profilePicture;
  int wastePoint;
  final String role;
  String userQR;
  String customUserId;
  String? pdpaConsentAt;
  String? pdpaNoticeVersion;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.homeAddress,
    required this.gender,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNo,
    required this.profilePicture,
    required this.wastePoint,
    required this.role,
    required this.userQR,
    this.customUserId = "",
    this.pdpaConsentAt,
    this.pdpaNoticeVersion,
  });

  // helper fx to get full name
  String get fullName => "$firstName $lastName";

  // helper fx to format phone number
  String get formattedPhoneNumber =>
      WasteFormatter.formattedPhoneNumber(phoneNo);

  // Static function to split full name and last name
  static List<String> nameParts(fullName) => fullName.split("");

  // Static function to generate username from the fullname
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split("");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static String generateCustomUserIdFromAddress(String address) {
    final normalized = address.toLowerCase().trim();
    final slug = normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '');

    if (slug.isEmpty) return 'address-not-set';
    return slug.length > 100 ? slug.substring(0, 100) : slug;
  }

  // static function to create an empty user model
  static UserModel empty() => UserModel(
    id: "",
    firstName: "",
    lastName: "",
    username: "",
    homeAddress: "",
    gender: "",
    dateOfBirth: "",
    email: "",
    phoneNo: "",
    profilePicture: "",
    wastePoint: 0,
    role: "",
    userQR: "",
    customUserId: "",
    pdpaConsentAt: null,
    pdpaNoticeVersion: null,
  );

  // convert model to JSON structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "Username": username,
      "Address": homeAddress,
      "Gender": gender,
      "DateOfBirth": dateOfBirth,
      "Email": email,
      "PhoneNumber": phoneNo,
      "ProfilePicture": profilePicture,
      "WastePoint": wastePoint,
      "Role": role,
      "UserQR": userQR,
      "CustomUserId": customUserId,
      "PDPAConsentAt": pdpaConsentAt,
      "PDPANoticeVersion": pdpaNoticeVersion,
    };
  }

  // factory method to create a UserModel from a firebase document snapshot

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data["FirstName"] ?? "",
        lastName: data["LastName"] ?? "",
        username: data["Username"] ?? "",
        homeAddress: data["Address"] ?? "",
        gender: data["Gender"] ?? "",
        dateOfBirth: data["DateOfBirth"] ?? "",
        email: data["Email"] ?? "",
        phoneNo: data["PhoneNumber"] ?? "",
        profilePicture: data["ProfilePicture"] ?? "",
        wastePoint: data["WastePoint"] ?? 0,
        role: data["Role"] ?? "",
        userQR: data["UserQR"] ?? "",
        customUserId: data["CustomUserId"] ?? "",
        pdpaConsentAt: data["PDPAConsentAt"] ?? null,
        pdpaNoticeVersion: data["PDPANoticeVersion"] ?? null,
      );
    } else {
      throw Exception("Document data is null");
    }
  }
}
