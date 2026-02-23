import 'package:ewastecare/features/module/models/learning_module_model.dart';

LearningModule learningModule7() {
  return LearningModule(
    imagePath: "assets/images/waste_module/modul7.png",
    title: "Modul 7",
    subTitle: "Konsep 5R: Recycle (Kitar Semula)",
    contentSections: [
      ContentSection(
        sectionTitle1: "4. Definisi Recycle (Kitar Semula)",
        sectionContent1:
            "Proses menukar bahan yang tidak digunakan kepada produk baru.",
        sectionImage1: ["assets/images/waste_module/modul7.png"],
        sectionTitle2: "Penerangan tambahan",
        sectionContent2AddPoint1:
            "1. Proses pengenalpastian jenis plastik perlu dilakukan di awal proses kitar semula.",
        sectionContent2AddPoint2:
            "2. Tidak semua jenis bahan plastik bole dikitar semula.",
        sectionContent2AddPoint3:
            "3. Kebiasaannya, di setiap bawah produk plastik mempunyai nombor antara 1-7 di dalam segit tiga anak panah.",
        addPoint1:
            "4. Kod tersebut mewakili jenis plastik yang digunakan untuk pembuatan produk tersebut dan bukan kod kitar semula produk.",
        sectionImage2: ["assets/images/waste_module/helping_eo.png"],
      ),
      ContentSection(
        sectionTitle1:
            "Kod kitar semula yang terdapat pada produk-produk plastik",
        sectionImage1: ["assets/images/waste_module/kod_plastik.png"],
        sectionContent1AddPoint1:
            "1. Sisa plastik berkod 1,2 4 dan 5 merupakan jenis-jenis plastik yang selamat dan tidak membahayakan serta diterima di semua pusat kitar semula",
        sectionContent1AddPoint2:
            "2. Sisa plastik berkod 3,6 dan 7 merupakan jenis-jenis plastik yang sukar dikitar semula dan membahayakan pada keadaan tertentu serta tidak diterima di kebanyakkan pusat kitar semula",
        sectionContent1AddPoint3:
            "3. Produk plastik berkod 3, 6 dan 7 disarankan untuk dikurangkan penggunaannya di Malaysia ",
      ),
      ContentSection(
        sectionTitle1: "Proses Kitar Semula",
        sectionImage1: ["assets/images/waste_module/proses_kitar_semula.png"],
        sectionContent1AddPoint1:
            "1. Proses pengumpulan barangan kitar semula.",
        sectionContent1AddPoint2:
            "2. Proses pengasingan barangan kitar semula.",
        sectionContent1AddPoint3:
            "3. Proses penghancuran barangan kitar semula.",
        addPoint1: "4. Proses basuhan barangan kitar semula.",
        addPoint2:
            "5. Proses penghasilan barangan baharu daripada sumber kitar semula.",
      ),
      ContentSection(
        sectionTitle1:
            "Contoh barangan yang boleh dihasilakan daripada sumber barangan kitar semula.",
        sectionImage1: ["assets/images/waste_module/ks1.jpg"],
        sectionImage2: ["assets/images/waste_module/ks2.jpg"],
        sectionImage3: ["assets/images/waste_module/ks3.jpg"],
      ),
    ],
  );
}
