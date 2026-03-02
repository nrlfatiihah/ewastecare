import 'package:flutter/material.dart';
import 'dart:io';

class SectionFormModel {
  TextEditingController sectionTitle;
  TextEditingController sectionContent;
  List<TextEditingController> points;

  File? sectionImageFile;
  String? sectionImageUrl;

  SectionFormModel({
    TextEditingController? sectionTitle,
    TextEditingController? sectionContent,
    List<TextEditingController>? points,
    this.sectionImageFile,
    this.sectionImageUrl,
  }) : sectionTitle = sectionTitle ?? TextEditingController(),
       sectionContent = sectionContent ?? TextEditingController(),
       points = points ?? [];
}
