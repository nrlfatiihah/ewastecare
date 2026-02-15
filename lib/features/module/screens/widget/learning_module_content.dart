import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:flutter/material.dart';

class LearningModuleContent extends StatelessWidget {
  final LearningModule module;

  const LearningModuleContent({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              module.subTitle,
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
