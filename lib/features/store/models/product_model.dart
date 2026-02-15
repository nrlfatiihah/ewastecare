import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String productName;
  String productImage;
  // String point;
  int point;
  String productDescription;
  int stock;
  // String stock;
  String productQR;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.point,
    required this.productDescription,
    required this.stock,
    required this.productQR,
  });

  // Empty funct for clean code
  static ProductModel empty() => ProductModel(
        id: "",
        productName: "",
        productImage: "",
        // point: 0,
        point: 0,
        productDescription: "",
        // stock: 0,
        stock: 0,
        productQR: "",
      );

  // Json Format
  toJson() {
    return { 
      "productName": productName,
      "Image": productImage,
      "EcoPoint": point,
      "Description": productDescription,
      "Stock": stock,
      "Qr": productQR,
    };
  }

  // Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ProductModel.empty();
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      productName: data["productName"]??"",
      productImage: data["Image"] ??"",
      point: data["EcoPoint"] ?? "",
      // point: data["EcoPoint"] ?? 0,
      productDescription: data["Description"]?? "",
      // stock: data["Stock"] ?? 0,
      stock: data["Stock"] ?? "",
      productQR: data["Qr"] ?? "",
    );
  }
}
