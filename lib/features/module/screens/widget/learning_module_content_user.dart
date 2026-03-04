import 'package:ewastecare/features/module/models/learning_module_model.dart';
import 'package:flutter/material.dart';

class LearningModuleContentUser extends StatelessWidget {
  final ModuleModel module;
  const LearningModuleContentUser({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.moduleTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              module.moduleSubtitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Image Display
            if (module.moduleImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(module.moduleImage, fit: BoxFit.cover),
              ),
            const SizedBox(height: 15),

            // Section Display
            ...module.contentSections.map((section) => section.toWidget()),
          ],
        ),
      ),
    );
  }
}
