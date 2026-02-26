import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:flutter/material.dart';

class LearningModuleContent extends StatelessWidget {
  final ModuleModel module; // <-- use ModuleModel here

  const LearningModuleContent({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.moduleTitle)), // use moduleTitle
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              module.moduleSubtitle, // use moduleSubtitle
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...module.contentSections.map((section) => section.toWidget()),
          ],
        ),
      ),
    );
  }
}
