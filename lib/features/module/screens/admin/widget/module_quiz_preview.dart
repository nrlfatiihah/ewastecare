import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleQuizPreviewScreen extends StatelessWidget {
  const ModuleQuizPreviewScreen({super.key, required this.controller});

  final ModuleController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Preview'),
        backgroundColor: WasteColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.quizQuestions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(WasteSizes.defaultSpace),
              child: Text(
                'No quiz questions have been added yet.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(WasteSizes.defaultSpace),
          itemCount: controller.quizQuestions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final question = controller.quizQuestions[index];
            final correctAnswerText = question
                .optionControllers[question.correctAnswerIndex]
                .text
                .trim();

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: WasteColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.questionController.text.trim().isEmpty
                          ? 'Untitled question'
                          : question.questionController.text.trim(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(question.optionControllers.length, (
                      optionIndex,
                    ) {
                      final optionText = question
                          .optionControllers[optionIndex]
                          .text
                          .trim();
                      final isCorrect =
                          optionIndex == question.correctAnswerIndex;

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? WasteColors.primary.withOpacity(0.08)
                              : Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCorrect
                                ? WasteColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                optionText.isEmpty
                                    ? 'Option ${optionIndex + 1}'
                                    : optionText,
                                style: TextStyle(
                                  fontWeight: isCorrect
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isCorrect)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: WasteColors.primary,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade700),
                      ),
                      child: Text(
                        correctAnswerText.isEmpty
                            ? 'Correct answer: Option ${question.correctAnswerIndex + 1}'
                            : 'Correct answer: $correctAnswerText',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
