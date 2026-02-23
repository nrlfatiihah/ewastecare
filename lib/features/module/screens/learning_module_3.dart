import 'package:ewastecare/features/module/models/learning_module_model.dart';

LearningModule learningModule3() {
  return LearningModule(
    imagePath: "assets/images/waste_module/5r.png",
    title: "Modul 3",
    subTitle: "Pengurusan Plastik Melalui 5R",
    contentSections: [
      ContentSection(
        mainImage: ["assets/images/waste_module/piramid.png"],
        sectionTitle1: "Konsep 5R",
        sectionContent1AddPoint1: "1. Refuse: Tolak",
        sectionContent1AddPoint2: "2. Reduce: Kurang",
        sectionContent1AddPoint3: "3. Reuse: Guna Semula",
        addPoint1: "4. Recycle: Kitar Semula",
        addPoint2: "5. Repurpose: Tukar Tujuan",
      ),
    ],
  );
}
