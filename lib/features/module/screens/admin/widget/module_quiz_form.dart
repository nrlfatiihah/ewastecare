import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/screens/admin/widget/module_quiz_preview.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleQuizForm extends StatelessWidget {
  const ModuleQuizForm({super.key, required this.controller});

  final ModuleController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Module Quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add questions that users must answer before earning a badge.',
            ),
            const SizedBox(height: WasteSizes.spaceBtwInputFields),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => Get.to(
                  () => ModuleQuizPreviewScreen(controller: controller),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: WasteColors.primary,
                  side: const BorderSide(color: WasteColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.visibility),
                label: const Text('Preview Quiz'),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.addQuizQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.primary,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
              ),
            ),
            const SizedBox(height: WasteSizes.spaceBtwInputFields),
            Obx(() {
              if (controller.quizQuestions.isEmpty) {
                return const Text('No questions added yet.');
              }

              return Column(
                children: List.generate(controller.quizQuestions.length, (
                  index,
                ) {
                  final question = controller.quizQuestions[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Question ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    controller.removeQuizQuestion(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: question.questionController,
                            decoration: const InputDecoration(
                              labelText: 'Question text',
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(question.optionControllers.length, (
                            optionIndex,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller:
                                    question.optionControllers[optionIndex],
                                decoration: InputDecoration(
                                  labelText: 'Option ${optionIndex + 1}',
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 4),
                          const Text(
                            'Correct answer',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...List.generate(question.optionControllers.length, (
                            optionIndex,
                          ) {
                            return RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Option ${optionIndex + 1}'),
                              value: optionIndex,
                              groupValue: question.correctAnswerIndex,
                              onChanged: (value) {
                                if (value == null) return;
                                question.correctAnswerIndex = value;
                                controller.quizQuestions.refresh();
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
