import 'package:ewastecare/utils/constants/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final controller = ModuleController.instance;

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

            // Show button if not completed
            if (!isCompleted)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => isCompleted = true);

                    // Mark module as completed in Firestore
                    await controller.markModuleCompleted(widget.module.id);

                    Get.snackbar(
                      "Congratulations!",
                      "You earned a badge for completing this module!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: WasteColors.primary,
                      colorText: Colors.white,
                    );
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text("Finish Module & Earn Badge"),
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
            else
              // Show badge if completed
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                    SizedBox(height: 8),
                    Text(
                      "Badge Earned!",
                      style: TextStyle(
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
