import 'dart:io';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';

class WasteDetectorPage extends StatefulWidget {
  const WasteDetectorPage({super.key});

  @override
  State<WasteDetectorPage> createState() => _WasteDetectorPageState();
}

class _WasteDetectorPageState extends State<WasteDetectorPage> {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  bool isCameraReady = false;

  Interpreter? interpreter;
  List<String> labels = [];
  String prediction = WasteTexts.noResult.tr;

  // Waste disposal guide
  final Map<String, String> wasteDisposalGuide = {
    "Plastic": "Kitar semula dalam tong kitar semula plastik.",
    "Paper":
        "Letakkan dalam tong kitar semula kertas atau kompos jika dicincang.",
    "Glass": "Bilas dan letakkan dalam tong kitar semula kaca.",
    "Metal": "Bersihkan dan kitar semula di pusat pengumpulan logam.",
    "Organic": "Kompok atau buang dalam tong sisa organik.",
    "E-Waste": "Bawa ke pusat kutipan e-waste.",
    "Hazardous":
        "Jangan buang dalam sampah biasa. Bawa ke kemudahan sisa berbahaya.",
  };

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/model/model_unquant.tflite',
    );
    String labelData = await rootBundle.loadString('assets/model/labels.txt');
    labels = labelData
        .split('\n')
        .map((e) => e.replaceAll(RegExp(r'^\d+\s*'), '').trim())
        .toList();
    setState(() {});
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await cameraController.initialize();
    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> captureAndDetect() async {
    try {
      final XFile imageFile = await cameraController.takePicture();
      File file = File(imageFile.path);

      img.Image? image = img.decodeImage(file.readAsBytesSync());
      img.Image resized = img.copyResize(image!, width: 224, height: 224);

      var input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            var pixel = resized.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          }),
        ),
      );

      var output = List.generate(1, (_) => List.filled(labels.length, 0.0));

      interpreter!.run(input, output);

      List<double> result = output[0];
      double maxScore = result.reduce((a, b) => a > b ? a : b);
      int index = result.indexOf(maxScore);

      setState(() {
        prediction =
            "${labels[index]} (${(maxScore * 100).toStringAsFixed(2)}%)";
      });
    } catch (e) {
      print("Error detecting image: $e");
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : WasteColors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Gradient Header
            WastePrimaryHeaderContainer(
              child: Column(
                children: [
                  WasteAppBar(
                    title: Text(
                      WasteTexts.wasteScanner.tr,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Camera Preview Card
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WasteSizes.defaultSpace,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: CameraPreview(cameraController),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Prediction & Disposal Suggestion
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WasteSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  Text(
                    WasteTexts.detectedWaste.tr,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isDarkMode ? Colors.white : WasteColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : WasteColors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Prediction text
                        Text(
                          prediction,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: isDarkMode
                                    ? Colors.white
                                    : WasteColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        // Disposal suggestion
                        Text(
                          wasteDisposalGuide[prediction.split('(')[0].trim()] ??
                              WasteTexts.noDisposalInfoAvailable.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Scan Waste Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: captureAndDetect,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(WasteTexts.scanWaste.tr),
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: WasteColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide.none,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ).copyWith(
                            overlayColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
