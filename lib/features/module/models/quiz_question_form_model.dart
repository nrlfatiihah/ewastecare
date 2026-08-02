import 'package:ewastecare/features/module/models/quiz_question_model.dart';
import 'package:flutter/material.dart';

class QuizQuestionFormModel {
  TextEditingController questionController;
  List<TextEditingController> optionControllers;
  int correctAnswerIndex;

  QuizQuestionFormModel({
    TextEditingController? questionController,
    List<TextEditingController>? optionControllers,
    this.correctAnswerIndex = 0,
  }) : questionController = questionController ?? TextEditingController(),
       optionControllers =
           optionControllers ??
           List.generate(4, (_) => TextEditingController());

  QuizQuestionModel toModel() {
    return QuizQuestionModel(
      question: questionController.text.trim(),
      options: optionControllers
          .map((controller) => controller.text.trim())
          .toList(),
      correctAnswerIndex: correctAnswerIndex,
    );
  }

  void dispose() {
    questionController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
  }
}
