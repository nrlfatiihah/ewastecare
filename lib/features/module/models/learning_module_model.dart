// import 'package:flutter/material.dart';

// class LearningModule {
//   final String title;
//   final String subTitle;
//   final String imagePath;
//   final List<ContentSection> contentSections;

//   LearningModule({
//     required this.title,
//     required this.subTitle,
//     required this.imagePath,
//     required this.contentSections,
//   });
// }

// class ContentSection {
//   final String? sectionTitle1;
//   final String? sectionTitle2;
//   final String? sectionTitle3;
//   final String? sectionContent;
//   final List<String>? imagePaths;
//   final String? otherContent;
//   final String? addPoint1;
//   final String? addPoint2;
//   final String? addPoint3;

//   ContentSection({
//     required this.sectionTitle1,
//     required this.sectionTitle2,
//     required this.sectionTitle3,
//     required this.sectionContent,
//     required this.imagePaths,
//     this.otherContent,
//     this.addPoint1,
//     this.addPoint2,
//     this.addPoint3,
//   });

//   Widget toWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//          const SizedBox(height: 10),
//         ...imagePaths.map((imagePath) => Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Image.asset(imagePath),
//             )
//             ),
//         const SizedBox(height: 30),
//         Text(
//           sectionTitle1,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           sectionContent,
//           style: const TextStyle(fontSize: 16),
//         ),
//         if (otherContent != null) ...[
//           const SizedBox(height: 10),
//           Text(
//             otherContent!,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],

//       ],
//     );
//   }
// }

import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class LearningModule {
  final String title;
  final String subTitle;
  final String imagePath;
  final List<ContentSection> contentSections;

  LearningModule({
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.contentSections,
  });
}

class ContentSection {
  final String? mainTitle;
  final List<String>? mainImage;
  final String? sectionTitle1;
  final String? sectionContent1;
  final List<String>? sectionImage1;
  final String? sectionContent1AddPoint1;
  final String? sectionContent1AddPoint2;
  final String? sectionContent1AddPoint3;
  final String? sectionTitle2;
  final String? sectionContent2;
  final List<String>? sectionImage2;
  final String? sectionContent2AddPoint1;
  final String? sectionContent2AddPoint2;
  final String? sectionContent2AddPoint3;
  final String? sectionContent2AddPoint4;
  final String? sectionTitle3;
  final String? sectionContent3;
  final List<String>? sectionImage3;
  final String? sectionContent3AddPoint1;
  final String? sectionContent3AddPoint2;
  final String? sectionContent3AddPoint3;
  final String? otherContent;
  final String? addPoint1;
  final String? addPoint2;
  final String? addPoint3;
  final String? addPoint4;
  final String? addPoint5;
  final String? addPoint6;

  ContentSection({
    this.mainTitle,
    this.mainImage,
    this.sectionTitle1,
    this.sectionContent1,
    this.sectionImage1,
    this.sectionContent1AddPoint1,
    this.sectionContent1AddPoint2,
    this.sectionContent1AddPoint3,
    this.sectionTitle2,
    this.sectionContent2,
    this.sectionImage2,
    this.sectionContent2AddPoint1,
    this.sectionContent2AddPoint2,
    this.sectionContent2AddPoint3,
    this.sectionContent2AddPoint4,
    this.sectionTitle3,
    this.sectionContent3,
    this.sectionImage3,
    this.sectionContent3AddPoint1,
    this.sectionContent3AddPoint2,
    this.sectionContent3AddPoint3,
    this.otherContent,
    this.addPoint1,
    this.addPoint2,
    this.addPoint3,
    this.addPoint4,
    this.addPoint5,
    this.addPoint6,
  });

  Widget toWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (mainTitle != null) ...[
          Text(
            mainTitle!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (mainImage != null) ...[
          ...mainImage!.map(
            (imagePath) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(child: Image.asset(imagePath)),
            ),
          ),
          const SizedBox(height: 30),
        ],
        if (sectionTitle1 != null) ...[
          Text(
            sectionTitle1!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionImage1 != null) ...[
          ...sectionImage1!.map(
            (imagePath) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(child: Image.asset(imagePath)),
            ),
          ),
          const SizedBox(height: 30),
        ],
        if (sectionContent1 != null) ...[
          Text(sectionContent1!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionContent1AddPoint1 != null) ...[
          Text(sectionContent1AddPoint1!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent1AddPoint2 != null) ...[
          Text(sectionContent1AddPoint2!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent1AddPoint3 != null) ...[
          Text(sectionContent1AddPoint3!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionTitle2 != null) ...[
          const SizedBox(height: WasteSizes.spaceBtwItems),
          Text(
            sectionTitle2!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionImage2 != null) ...[
          ...sectionImage2!.map(
            (imagePath) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(child: Image.asset(imagePath)),
            ),
          ),
          const SizedBox(height: 30),
        ],
        if (sectionContent2 != null) ...[
          Text(sectionContent2!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionContent2AddPoint1 != null) ...[
          Text(sectionContent2AddPoint1!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent2AddPoint2 != null) ...[
          Text(sectionContent2AddPoint2!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent2AddPoint3 != null) ...[
          Text(sectionContent2AddPoint3!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent2AddPoint4 != null) ...[
          Text(sectionContent2AddPoint4!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionTitle3 != null) ...[
          // const SizedBox(height: WasteSizes.spaceBtwItems),
          Text(
            sectionTitle3!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionImage3 != null) ...[
          ...sectionImage3!.map(
            (imagePath) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(child: Image.asset(imagePath)),
            ),
          ),
          const SizedBox(height: 30),
        ],
        if (sectionContent3 != null) ...[
          Text(sectionContent3!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (sectionContent3AddPoint1 != null) ...[
          Text(sectionContent3AddPoint1!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent3AddPoint2 != null) ...[
          Text(sectionContent3AddPoint2!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (sectionContent3AddPoint3 != null) ...[
          Text(sectionContent3AddPoint3!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (otherContent != null) ...[
          // const SizedBox(height: WasteSizes.spaceBtwItems),
          Text(otherContent!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwItems),
        ],
        if (addPoint1 != null) ...[
          Text(addPoint1!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (addPoint2 != null) ...[
          Text(addPoint2!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (addPoint3 != null) ...[
          Text(addPoint3!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (addPoint4 != null) ...[
          Text(addPoint4!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (addPoint5 != null) ...[
          Text(addPoint5!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
        if (addPoint6 != null) ...[
          Text(addPoint6!, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: WasteSizes.spaceBtwInputFields),
        ],
      ],
    );
  }
}
