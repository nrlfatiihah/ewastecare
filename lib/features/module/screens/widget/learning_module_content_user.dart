import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:ewastecare/features/module/models/learning_module_model.dart';

class LearningModuleContentUser extends StatefulWidget {
  final ModuleModel module;
  const LearningModuleContentUser({super.key, required this.module});

  @override
  State<LearningModuleContentUser> createState() =>
      _LearningModuleContentUserState();
}

class _LearningModuleContentUserState extends State<LearningModuleContentUser> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkCompletion();
  }

  void _checkCompletion() {
    final controller = ModuleController.instance;
    setState(() {
      isCompleted = controller.completedModules.contains(widget.module.id);
    });
  }

  Future<void> _refresh() async {
    final controller = ModuleController.instance;

    // Fetch updated completed modules from Firestore
    await controller.fetchUserCompletedModules();

    // Update the UI
    _checkCompletion();
  }

  Future<void> _showQuizPopup() async {
    if (widget.module.quizQuestions.isEmpty) {
      Get.snackbar(
        WasteTexts.oops.tr,
        'No quiz questions are configured for this module yet.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final selectedAnswers = <int, int?>{};
    final questionResults = <int, bool>{};
    int correctAnswersCount = 0;
    var hasSubmitted = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Module Quiz'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Answer all questions correctly to earn your badge.',
                      ),
                      if (hasSubmitted) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                questionResults.values.every((value) => value)
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  questionResults.values.every((value) => value)
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          child: Text(
                            'Score: $correctAnswersCount/${widget.module.quizQuestions.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color:
                                  questionResults.values.every((value) => value)
                                  ? Colors.green
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ...widget.module.quizQuestions.asMap().entries.map((
                        entry,
                      ) {
                        final questionIndex = entry.key;
                        final question = entry.value;
                        final isCorrect = questionResults[questionIndex];
                        final questionColor = !hasSubmitted
                            ? Colors.white
                            : isCorrect == true
                            ? Colors.green.withOpacity(0.08)
                            : Colors.red.withOpacity(0.08);
                        final questionBorderColor = !hasSubmitted
                            ? Colors.grey.shade300
                            : isCorrect == true
                            ? Colors.green
                            : Colors.red;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            color: questionColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: questionBorderColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Q${questionIndex + 1}. ${question.question}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (hasSubmitted)
                                        Icon(
                                          isCorrect == true
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: isCorrect == true
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...question.options.asMap().entries.map((
                                    optionEntry,
                                  ) {
                                    return RadioListTile<int>(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: Text(optionEntry.value),
                                      value: optionEntry.key,
                                      groupValue:
                                          selectedAnswers[questionIndex],
                                      onChanged: (value) {
                                        setDialogState(() {
                                          selectedAnswers[questionIndex] =
                                              value;
                                        });
                                      },
                                    );
                                  }),
                                  if (hasSubmitted)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        isCorrect == true
                                            ? 'Correct'
                                            : 'Incorrect. Correct answer: ${question.options[question.correctAnswerIndex]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isCorrect == true
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final allAnswered = widget.module.quizQuestions
                        .asMap()
                        .entries
                        .every((entry) {
                          return selectedAnswers[entry.key] != null;
                        });

                    if (!allAnswered) {
                      Get.snackbar(
                        WasteTexts.oops.tr,
                        'Please answer all questions before submitting.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    final results = <int, bool>{};
                    correctAnswersCount = 0;
                    for (final entry
                        in widget.module.quizQuestions.asMap().entries) {
                      final selectedAnswer = selectedAnswers[entry.key];
                      final isCorrect =
                          selectedAnswer == entry.value.correctAnswerIndex;
                      results[entry.key] = isCorrect;
                      if (isCorrect) {
                        correctAnswersCount++;
                      }
                    }

                    final passed = results.values.every((value) => value);

                    setDialogState(() {
                      hasSubmitted = true;
                      questionResults
                        ..clear()
                        ..addAll(results);
                    });

                    if (!passed) {
                      return;
                    }

                    final controller = ModuleController.instance;
                    await controller.markModuleCompleted(widget.module.id);
                    if (!mounted) return;

                    setState(() {
                      isCompleted = true;
                    });

                    Navigator.of(dialogContext).pop();

                    Get.snackbar(
                      WasteTexts.congratulations.tr,
                      'Quiz passed. You earned a badge!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: WasteColors.primary,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasteColors.primary,
                    side: BorderSide.none,
                  ),
                  child: Text(hasSubmitted ? 'Check Again' : 'Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.module.moduleTitle)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              widget.module.moduleSubtitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (widget.module.moduleImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.module.moduleImage,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 15),

            // Module content sections
            ...widget.module.contentSections.map(
              (section) => section.toWidget(),
            ),

            const SizedBox(height: 20),

            if (!isCompleted && widget.module.quizQuestions.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _showQuizPopup,
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Take Quiz & Earn Badge'),
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: WasteColors.primary,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
                          WasteColors.primary.withOpacity(0.2),
                        ),
                      ),
                ),
              )
            else if (!isCompleted) ...[
              const Text(
                'This module does not have quiz questions yet.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
            ] else
              // Show badge if completed
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 48,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      WasteTexts.badgeEarned.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WasteColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
