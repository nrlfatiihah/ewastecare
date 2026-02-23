import 'package:ewastecare/features/module/models/learning_module_model.dart';

LearningModule learningModule4() {
  return LearningModule(
    imagePath: "assets/images/waste_module/modul4.png",
    title: "Modul 4",
    subTitle: "Konsep 5R: Refuse (Tolak)",
    contentSections: [
      ContentSection(
        sectionTitle1: "1. Definisi Refuse (Tolak)",
        sectionContent1:
            "Tindakan atau langkah yang diambil untuk menolak penggunaan bahan atau barang yang tidak diperlukan dalam kehidupan seharian yang boleh memberi kesan buruk kepada diri sendiri, masyarakat dan alam sekitar",
        sectionTitle2: "Bagaimana hendak tolak?",
        sectionContent2:
            "Kita haruslah membuat penilaian dan keputusan yang bijak sebelum menerima atau menolak bahan tersebut.",
        sectionImage1: ["assets/images/waste_module/modul4.png"],
      ),
      ContentSection(
        sectionTitle1: "Tolak Plastik Sekali Guna",
        sectionTitle2: "Apa itu plastik sekali guna?",
        sectionContent2:
            "Plastik sekali guna adalah plastik yang akan dibuang selepas diguna sebanyak satu kali (Contoh: pembungkusan makanan dan minuman)",
        sectionTitle3: "Mengapa Plastik Sekali Guna Bahaya?",
        sectionContent3AddPoint1: "1. Mudah dihasilkan tetapi sukar dilupuskan",
        sectionContent3AddPoint2:
            "2. Terlalu bergantung tanpa fikirkan kesan kepada alam sekitar pada jangka masa panjang",
        sectionContent3AddPoint3:
            "3. Plastik tidak boleh terurai secara sepenuhnya. Ia akan menjadi mikroplastik",
        sectionImage1: ["assets/images/waste_module/plastik_sekali_guna.png"],
      ),
    ],
  );
}
