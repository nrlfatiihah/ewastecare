import 'package:ewastecare/features/module/models/learning_module_model.dart';

LearningModule learningModule2() {
  return LearningModule(
    title: "Modul 2",
    subTitle: "Saya Menghasilkan Sisa Pepejal",
    imagePath: "assets/images/waste_module/modul2.png",
    contentSections: [
      ContentSection(
        sectionTitle1: "Objektif",
        sectionContent1AddPoint1:
            "1. Memberi pengetahuan akan jenis-jenis sisa pepejal yang dihasilkan di rumah (Domestic Waste) dan yang lain-lain (contoh: Industry Waste, Clinical Waste, Agricultural Waste).",
        sectionContent1AddPoint2:
            "2. Mengkelaskan sisa pepejal kepada yang boleh terurai dan tidak terurai.",
        mainImage: ["assets/images/waste_module/modul2.png"],
      ),
      ContentSection(
        sectionTitle1: "Sisa Domestik",
        sectionImage1: ["assets/images/waste_module/sisa_domestik.png"],
        sectionContent1:
            "Terdapat pelbagai jenis sisa domestik. Antaranya ialah besi, kertas, kaca, plastik, bahan-bahan organik, bateri, lampu dan bahan elektronik",
      ),
      ContentSection(
        sectionTitle1: "Sisa Industri",
        sectionImage1: ["assets/images/waste_module/sisa_industri.png"],
        sectionContent1:
            "Terdapat pelbagai jenis sisa industri. Antaranya adalah:",
        sectionContent1AddPoint1: "1. Sisa toksik",
        sectionContent1AddPoint2: "2. Sisa air buangan",
        sectionContent1AddPoint3: "3. Sisa nuklear",
      ),
      ContentSection(
        sectionTitle1: "Sisa Klinikal",
        sectionImage1: ["assets/images/waste_module/sisa_perubatan.png"],
        sectionContent1:
            "Antara contoh-contoh sisa perubatan adalah seperti berikut:",
        sectionContent1AddPoint1:
            "1. Sisa berjangkit: Pakaian pembedahan, darah, kapas dan sebagainya",
        sectionContent1AddPoint2:
            "2. Sisa tajam: Peralatan klinikal yang tajam seperti jarum, pisau dan sebagainya",
        sectionContent1AddPoint3:
            "3. Sisa ubatan: Ubat-ubatan yan telah tamat tempoh",
        addPoint4: "4. Sisa radioaktif",
        addPoint5: "5. Sisa tidak berbahaya",
      ),
      ContentSection(
        sectionTitle1: "Sisa Pertanian",
        sectionImage1: ["assets/images/waste_module/sisa_pertanian.png"],
        sectionContent1:
            "Antara contoh-contoh sisa perubatan adalah seperti berikut:",
        sectionContent1AddPoint1: "1. Sisa pembalakkan",
        sectionContent1AddPoint2: "2. Sisa air buangan tanaman",
        sectionContent1AddPoint3: "3. Sisa tanaman hutan dan haiwan ternakkan",
        addPoint4: "4. Sisa tanaman",
        addPoint5: "5. Sisa agro industri",
      ),
      ContentSection(
        sectionTitle1: "Asingkan Sisa Sampah Buangan Anda",
        sectionImage1: ["assets/images/waste_module/asing_sampah.png"],
        sectionContent1:
            "Asingkan sisa sampah anda kepada dua bahagian iaitu sisa sampah kering (non-biodegradable) dan sisa sampah basah (biodegradable)",
        sectionTitle2: "Jenis Sisa Sampah kering (non-biodegradable)",
        sectionContent2AddPoint1: "1. Kertas, plastik, kayu",
        sectionContent2AddPoint2: "2. Besi, kaca, getah",
        sectionContent2AddPoint3: "3. Fabrik, kulit",
        sectionTitle3: "Jenis Sisa Sampah basah (biodegradable)",
        sectionContent3AddPoint1: "1. Sisa makanan yang telah masak",
        sectionContent3AddPoint2: "2. Sisa makanan mentah",
      ),
      ContentSection(
        sectionTitle1: "Aktiviti",
        sectionImage1: ["assets/images/waste_module/aktiviti_modul_2.png"],
        sectionContent1AddPoint1:
            "1. Pengkelasan sampah dari setiap rumah mengikut sisa organik dan tidak organik",
        sectionContent1AddPoint2:
            "2. Beberapa pelajar akan membawa hasil sampah yang dikumpulkan bagi tempoh 2 hari dan perubahan yang berlaku pada sisa tersebut",
        sectionContent1AddPoint3:
            "3. Mengenalpasti dan merekod destinasi sampah yang dihasilkan dirumah dan tempat terakhir sampah tersebut (mengikut rutin harian di rumah)",
      ),
      ContentSection(
        sectionTitle1: "Perbincangan",
        sectionImage1: ["assets/images/waste_module/perbincangan_modul_2.png"],
        sectionContent1AddPoint1:
            "1. Bincang kepentingan & mengetahui jenis sampah yang dihasilkan",
        sectionContent1AddPoint2:
            "2. Memberikan cadangan jika lori sampah tidak dapat ambil oleh pihak penguasa, apakah pilihan yang akan di ambil oleh penduduk",
        sectionContent1AddPoint3:
            "3. Kenal pasti sampah ynag berbahaya dan tidak berbahaya(toksid) kepada manusia/hidupan lain",
      ),
    ],
  );
}
