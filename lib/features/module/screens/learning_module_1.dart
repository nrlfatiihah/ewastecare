import 'package:ewastecare/features/module/models/learning_module_model.dart';

LearningModule learningModule1() {
  return LearningModule(
    title: "Modul 1",
    subTitle: "Dunia Bahan Terbuang",
    imagePath: "assets/images/waste_module/Picture1.png",
    contentSections: [
      ContentSection(
        sectionTitle1: "Objektif",
        addPoint1:
            "1. Untuk memberi kesedaran mengenai kesan dan akibat daripada pengurusan sampah yang tidak teratur",
        addPoint2:
            "2. Memberi pengetahuan mengenai kesan negatif tidak menjaga alam sekitar kepada manusia, haiwan dan kehidupan laut secara amnya.",
        mainImage: ["assets/images/waste_module/Picture1.png"],
      ),
      ContentSection(
        sectionTitle1: "Apakah maksud dunia bahan terbuang",
        sectionContent1:
            "Bahan yang tidak digunakan dan disimpan. Bahan yang tidak diperlukan lagi dan tidak mahu disimpan. Atau bahan yang tidak dikehendaki atau tidak boleh guna oleh kebanyakkan aktiviti manusia",
        sectionTitle2:
            "Kategori bahan terbuang - bergantung kepada beberapa aspek:",
        sectionContent2AddPoint1:
            "1. Punca atau sumber penjanaan sesuatu bahan buangan berkenaan",
        sectionContent2AddPoint2: "2. Jenis atau komposisi bahan buangan",
        sectionContent2AddPoint3: "3. Sifat bahaya atau tahap risiko",
        sectionContent2AddPoint4: "4. Kaedah menguruskan bahan buangan",
      ),
      ContentSection(
        sectionTitle1: "Akibat Pengurusan Sisa Tidak Sempurna",
        sectionContent1:
            "Berikut merupakan akibat pengurusan sisa tidak sempurna:",
        sectionImage1: ["assets/images/waste_module/sisa_tidak_sempurna.png"],
        sectionContent1AddPoint1: "1. Pencemaran alam sekitar",
        sectionContent1AddPoint2: "2. Degradasi alam sekitar",
        sectionContent1AddPoint3: "3. Risiko kesihatan diri",
      ),
      ContentSection(
        sectionTitle1: "Kesan Ke Atas Manusia",
        sectionImage1: ["assets/images/waste_module/kesan_kepada_manusia.png"],
        sectionContent1:
            "Berikut merupakan kesan pengurusan sisa tidak sempurna ke atas manusia:",
        sectionContent1AddPoint1: "1. Masalah pernafasan",
        sectionContent1AddPoint2: "2. Pencemaran air (minuman)",
        sectionContent1AddPoint3: "3. Risiko dijangkiti penyakit",
      ),
      ContentSection(
        sectionTitle1: "Kesan Ke Atas Haiwan",
        sectionImage1: ["assets/images/waste_module/kesan_kepada_haiwan.png"],
        sectionContent1:
            "Berikut merupakan kesan pengurusan sisa tidak sempurna ke atas haiwan:",
        sectionContent1AddPoint1:
            "1. Haiwan terperangkap dalam plastik menyebabkan kesukaran bernafas, berjalan dan sebagainya",
        sectionContent1AddPoint2:
            "2. Haiwan termakan sisa sampah yang berbahaya",
      ),
      ContentSection(
        sectionTitle1: "Kesan Ke Atas Hidupan Marin",
        sectionImage1: [
          "assets/images/waste_module/kesan_kepada_hidupan_marin.png",
        ],
        sectionContent1:
            "Berikut merupakan kesan pengurusan sisa tidak sempurna ke atas hidupan marin:",
        sectionContent1AddPoint1: "1. Memusnahkan habitat di dalam laut",
        sectionContent1AddPoint2:
            "2. Meningkatkan risiko spesies marin terancam",
      ),
      ContentSection(
        sectionTitle1: "Aktiviti",
        sectionContent1AddPoint1:
            "1. Mengenalpasti kawasan longkang atau aliran air dikawasan sekitar yang terkesan akibat pembuangan sampah merata-rata (Sistem ekologi)",
        sectionContent1AddPoint2:
            "2. Berkongsi video/gambar tentang sistem pengurusan sisa pepejal yang diamalkan di Malaysia (dump-site) dan kesan negatif dari kaedah tersebut",
      ),
      ContentSection(
        sectionTitle1: "Perbincangan",
        sectionImage1: ["assets/images/waste_module/dump_site.png"],
        sectionContent1AddPoint1:
            "1. Apa yang difahami/konsep pengurusan sampah bagi tapak tersebut. Bandingkan dari segi kebaikan dan kelemahan bagi tapak tersebut. Apakah contoh pencemaran yang berlaku",
        sectionContent1AddPoint2:
            "2. Bincangkan apa yang berlaku jika tapak pelupusan sampah telah penuh. (jangka masa pendek (5 Tahun), sederhana (10 Tahun), dan panjagn (30 Tahun)). Apa yang perlu dilakukan untuk membaiki isu ini?",
      ),
    ],
  );
}
