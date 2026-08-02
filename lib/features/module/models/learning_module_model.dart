import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewastecare/features/module/models/quiz_question_model.dart';
import 'package:ewastecare/features/module/models/section_model.dart';

class ModuleModel {
  String id;
  String moduleTitle;
  String moduleSubtitle;
  String moduleImage;
  List<SectionModel> contentSections;
  List<QuizQuestionModel> quizQuestions;

  ModuleModel({
    required this.id,
    required this.moduleTitle,
    required this.moduleSubtitle,
    required this.moduleImage,
    required this.contentSections,
    required this.quizQuestions,
  });

  static ModuleModel empty() => ModuleModel(
    id: "",
    moduleTitle: "",
    moduleSubtitle: "",
    moduleImage: "",
    contentSections: [],
    quizQuestions: [],
  );

  toJson() {
    return {
      "moduleTitle": moduleTitle,
      "moduleSubtitle": moduleSubtitle,
      "moduleImage": moduleImage,
      "contentSections": contentSections.map((e) => e.toJson()).toList(),
      "quizQuestions": quizQuestions.map((e) => e.toJson()).toList(),
    };
  }

  factory ModuleModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() == null) return ModuleModel.empty();
    final data = document.data()!;

    final sectionsData = data['contentSections'] as List<dynamic>? ?? [];
    final sections = sectionsData
        .map((e) => SectionModel.fromMap(e as Map<String, dynamic>))
        .toList();

    final quizQuestionsData = data['quizQuestions'] as List<dynamic>? ?? [];
    final quizQuestions = quizQuestionsData
        .map((e) => QuizQuestionModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return ModuleModel(
      id: document.id,
      moduleTitle: data["moduleTitle"] ?? "",
      moduleSubtitle: data["moduleSubtitle"] ?? "",
      moduleImage: data["moduleImage"] ?? "",
      contentSections: sections,
      quizQuestions: quizQuestions,
    );
  }
}
