import 'package:cloud_firestore/cloud_firestore.dart';

class OldMaterialModel {
  String id;
  String name;
  String type; // Added type field
  double value;

  OldMaterialModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
  });

  // Empty constructor for default values
  static OldMaterialModel empty() => OldMaterialModel(
        id: "",
        name: "",
        type: "",
        value: 0.0,
      );

  // Convert a MaterialValue into a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type, // Include type in JSON serialization
      'value': value,
    };
  }

  // Convert a DocumentSnapshot into a MaterialValue instance
  factory OldMaterialModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return OldMaterialModel.empty();
    final data = document.data()!;
    return OldMaterialModel(
      id: document.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '', // Extract type from Firestore document
      value: (data['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convert a MaterialValue into a Map for Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type, // Include type in Firestore storage
      'value': value,
    };
  }

  // // Helper method to delete a document from Firestore
  // Future<void> deleteFromFirestore() async {
  //   try {
  //     await FirebaseFirestore.instance.collection('material_values').doc(id).delete();
  //     print('Material successfully deleted');
  //   } catch (e) {
  //     print('Error deleting material: $e');
  //   }
  // }

  // // Helper method to update a document in Firestore
  // Future<void> updateInFirestore() async {
  //   try {
  //     await FirebaseFirestore.instance.collection('material_values').doc(id).update(toFirestore());
  //     print('Material successfully updated');
  //   } catch (e) {
  //     print('Error updating material: $e');
  //   }
  // }

  // // Helper method to save a new document to Firestore
  // Future<void> saveToFirestore() async {
  //   try {
  //     await FirebaseFirestore.instance.collection('material_values').doc(id).set(toFirestore());
  //     print('Material successfully saved');
  //   } catch (e) {
  //     print('Error saving material: $e');
  //   }
  // }
}
