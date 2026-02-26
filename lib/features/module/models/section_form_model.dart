import 'package:flutter/material.dart';

class SectionFormModel {
  TextEditingController sectionTitle;
  TextEditingController sectionContent;
  List<TextEditingController> points;

  SectionFormModel({
    TextEditingController? sectionTitle,
    TextEditingController? sectionContent,
    List<TextEditingController>? points,
  }) : sectionTitle = sectionTitle ?? TextEditingController(),
       sectionContent = sectionContent ?? TextEditingController(),
       points =
           points ??
           [
             TextEditingController(),
             TextEditingController(),
             TextEditingController(),
           ];
}
