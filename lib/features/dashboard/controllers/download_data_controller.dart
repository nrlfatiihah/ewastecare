import 'dart:io';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/dashboard/download_data_repository.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DownloadWasteDataController extends GetxController {
  static const MethodChannel _downloadsChannel = MethodChannel(
    'ewastecare/downloads',
  );
  static DownloadWasteDataController get instance =>
      Get.put(DownloadWasteDataController());
  final downloadWasteData = DownloadWasteData();
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();

  Future<void> generateAndShareExcel(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Generate Excel
      // Fetching data for each sheet
      List<Map<String, List<Map<String, dynamic>>>> dataSets = [];

      List<Map<String, dynamic>> userData = await downloadWasteData
          .getDataUsers();
      dataSets.add({"Users": userData});

      List<Map<String, dynamic>> adminDashboardData = await downloadWasteData
          .getDataAdminDashboard(startDate, endDate);
      dataSets.add({"Admin Dashboard": adminDashboardData});

      List<Map<String, dynamic>> usersDashboardData = await downloadWasteData
          .getDataUsersDashboard();
      dataSets.add({"User Dashboard": usersDashboardData});

      List<Map<String, dynamic>> transactionsData = await downloadWasteData
          .getDataTransactions(startDate, endDate);
      dataSets.add({"Transaction": transactionsData});

      List<Map<String, dynamic>> productsData = await downloadWasteData
          .getDataProducts();
      dataSets.add({"Products": productsData});

      String outputPath = await saveExcel(dataSets);

      if (outputPath.isNotEmpty) {
        final downloadedPath = await copyFileToDownloads(outputPath);

        if (downloadedPath != null) {
          WasteLoaders.successSnackBar(
            title: "Downloaded",
            message: "File downloaded to: $downloadedPath",
          );
        } else {
          WasteLoaders.errorSnackBar(
            title: "Not In Downloads",
            message:
                "Could not save to public Downloads. File is in app storage: $outputPath",
          );
        }
      } else {
        WasteLoaders.errorSnackBar(
          title: "Error",
          message: "Failed to save Excel file",
        );
      }
    } catch (e) {
      WasteLoaders.errorSnackBar(
        title: "Error",
        message: "Error generating or downloading file",
      );
    }
  }

  Future<String?> copyFileToDownloads(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!sourceFile.existsSync()) {
        return null;
      }

      final fileName = sourcePath.split(Platform.pathSeparator).last;

      if (Platform.isAndroid) {
        try {
          final bytes = await sourceFile.readAsBytes();
          final savedUri = await _downloadsChannel.invokeMethod<String>(
            'saveFileToDownloads',
            {
              'fileName': fileName,
              'mimeType':
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              'bytes': bytes,
            },
          );

          if (savedUri != null && savedUri.isNotEmpty) {
            return savedUri;
          }
        } on PlatformException catch (e) {
          print('MediaStore save failed: ${e.message}');
        }
      }

      Directory? downloadsDirectory;
      try {
        downloadsDirectory = await getDownloadsDirectory();
      } catch (_) {
        downloadsDirectory = null;
      }

      if (downloadsDirectory == null && Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      }

      if (downloadsDirectory == null) {
        return null;
      }

      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      final destinationPath =
          '${downloadsDirectory.path}${Platform.pathSeparator}$fileName';

      await sourceFile.copy(destinationPath);
      return destinationPath;
    } catch (e) {
      print('Failed to copy file to Downloads: $e');
      return null;
    }
  }

  Future<String> saveExcel(
    List<Map<String, List<Map<String, dynamic>>>> dataSets,
  ) async {
    try {
      var excel = Excel.createExcel();

      for (var dataSet in dataSets) {
        String sheetName = dataSet.keys.first;
        List<Map<String, dynamic>> data = dataSet[sheetName]!;

        Sheet sheetObject = excel[sheetName];

        // Adding headers if required
        if (data.isNotEmpty) {
          List<String> headers = data.first.keys.toList();
          sheetObject.appendRow(
            headers.map((header) => TextCellValue(header)).toList(),
          );
        }

        // Adding rows
        for (var row in data) {
          List<CellValue> cells = row.values.map((value) {
            if (value == null) {
              return TextCellValue(''); // Handle null values
              // return const TextCellValue(''); // Handle null values
            } else if (value is String) {
              return TextCellValue(value);
            } else if (value is int) {
              return IntCellValue(value);
            } else if (value is double) {
              return DoubleCellValue(value);
            } else if (value is bool) {
              return BoolCellValue(value);
            } else if (value is DateTime) {
              // Format the DateTime as DD/MM/YYYY
              String formattedDate = DateFormat('dd/MM/yyyy').format(value);
              return TextCellValue(formattedDate);
            } else {
              return TextCellValue(value.toString());
            }
          }).toList();

          sheetObject.appendRow(cells);
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'WasteData_${getCurrentDateTimeString()}.xlsx';
      String outputPath = '${directory.path}/$fileName';
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      return outputPath;
    } catch (e) {
      // Handle or log the error
      print('Error saving Excel file: $e');
      return '';
    }
  }

  // Function to generate current date time formatted string
  String getCurrentDateTimeString() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy_HHmm');
    return formatter.format(now);
  }

  void resetFilters() {
    selectedStartDate.value = null;
    selectedEndDate.value = null;
  }
}
