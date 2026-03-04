import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SectionModel {
  String sectionTitle1;
  String sectionContent1;
  String? sectionImage;
  String? sectionContent1AddPoint1;
  String? sectionContent1AddPoint2;
  String? sectionContent1AddPoint3;

  SectionModel({
    required this.sectionTitle1,
    required this.sectionContent1,
    this.sectionImage,
    this.sectionContent1AddPoint1,
    this.sectionContent1AddPoint2,
    this.sectionContent1AddPoint3,
  });

  Widget toWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle1.isNotEmpty)
          Text(
            sectionTitle1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: WasteSizes.spaceBtwItems),
        if (sectionContent1.isNotEmpty)
          Text(sectionContent1, style: const TextStyle(fontSize: 16)),
        if (sectionImage != null && sectionImage!.isNotEmpty) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(sectionImage!, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
        ],
        if (sectionContent1AddPoint1 != null)
          Text(sectionContent1AddPoint1!, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        if (sectionContent1AddPoint2 != null)
          Text(sectionContent1AddPoint2!, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        if (sectionContent1AddPoint3 != null)
          Text(sectionContent1AddPoint3!, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: WasteSizes.spaceBtwItems),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sectionTitle1": sectionTitle1,
      "sectionContent1": sectionContent1,
      "sectionImage": sectionImage,
      "sectionContent1AddPoint1": sectionContent1AddPoint1,
      "sectionContent1AddPoint2": sectionContent1AddPoint2,
      "sectionContent1AddPoint3": sectionContent1AddPoint3,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      sectionTitle1: map["sectionTitle1"] ?? "",
      sectionContent1: map["sectionContent1"] ?? "",
      sectionImage: map["sectionImage"],
      sectionContent1AddPoint1: map["sectionContent1AddPoint1"],
      sectionContent1AddPoint2: map["sectionContent1AddPoint2"],
      sectionContent1AddPoint3: map["sectionContent1AddPoint3"],
    );
  }
}
