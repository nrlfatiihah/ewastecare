import 'dart:io';
import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/dashboard/test_download_data_repository.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class TestDownloadWasteDataController extends GetxController {
  static const MethodChannel _downloadsChannel = MethodChannel(
    'ewastecare/downloads',
  );
  static TestDownloadWasteDataController get instance =>
      Get.put(TestDownloadWasteDataController());
  final TestDownloadWasteDataRepo testDownloadWasteDataRepo =
      TestDownloadWasteDataRepo();
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();

  Future<void> generateAndShareExcel(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      print('Starting to generate Excel file');
      List<Map<String, List<Map<String, dynamic>>>> dataSets = [];

      List<Map<String, dynamic>> userData = await testDownloadWasteDataRepo
          .getDataUsers();
      dataSets.add({"Users": userData});

      List<Map<String, dynamic>> allocatePointData =
          await testDownloadWasteDataRepo.getDataAllocatePoint(
            startDate,
            endDate,
          );
      print('Data fetched from repository: $allocatePointData');
      dataSets.add({"Allocate Point": allocatePointData});

      List<Map<String, dynamic>> transactionsData =
          await testDownloadWasteDataRepo.getDataTransactions(
            startDate,
            endDate,
          );
      dataSets.add({"Transaction": transactionsData});

      List<Map<String, dynamic>> adminDashboardData =
          await testDownloadWasteDataRepo.getDataAdminDashboard(
            startDate,
            endDate,
          );
      dataSets.add({"Admin Dashboard": adminDashboardData});

      List<Map<String, dynamic>> usersDashboardData =
          await testDownloadWasteDataRepo.getDataUsersDashboard();
      dataSets.add({"Users Dashboard": usersDashboardData});

      List<Map<String, dynamic>> productsData = await testDownloadWasteDataRepo
          .getDataProducts();
      dataSets.add({"Products": productsData});

      String outputPath = await saveExcel(dataSets);
      print('Excel file saved at: $outputPath');

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
      print('Error generating or downloading file: $e');
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

      // Android fallback for public Downloads path if provider returns null.
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

      // Process each data set
      for (var dataSet in dataSets) {
        String sheetName = dataSet.keys.first;
        List<Map<String, dynamic>> data = dataSet[sheetName]!;

        // Create a new sheet
        Sheet sheetObject = excel[sheetName];

        if (data.isNotEmpty) {
          // Collect unique headers for the current sheet
          Set<String> headersSet = {};
          for (var row in data) {
            headersSet.addAll(row.keys);
          }
          List<String> headers = headersSet.toList();

          // Header styling with borders and colors
          CellStyle headerStyle = CellStyle(
            bold: true,
            fontColorHex: ExcelColor.fromHexString(
              '#000000',
            ), // Black font color
            backgroundColorHex: ExcelColor.fromHexString(
              '#6B8E23',
            ), // Olive green background color
            horizontalAlign: HorizontalAlign.Center,
            verticalAlign: VerticalAlign.Center,
            leftBorder: Border(borderStyle: BorderStyle.Thin),
            rightBorder: Border(borderStyle: BorderStyle.Thin),
            topBorder: Border(borderStyle: BorderStyle.Thin),
            bottomBorder: Border(borderStyle: BorderStyle.Thin),
          );

          // Data cell styling with borders
          CellStyle dataCellStyle = CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            verticalAlign: VerticalAlign.Center,
            leftBorder: Border(borderStyle: BorderStyle.Thin),
            rightBorder: Border(borderStyle: BorderStyle.Thin),
            topBorder: Border(borderStyle: BorderStyle.Thin),
            bottomBorder: Border(borderStyle: BorderStyle.Thin),
          );

          // Add headers to the sheet with styling
          for (int i = 0; i < headers.length; i++) {
            var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
            );
            cell.value = TextCellValue(headers[i]);
            cell.cellStyle = headerStyle; // Apply the header style
          }

          // Add rows to the sheet
          for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
            var row = data[rowIndex];
            for (int colIndex = 0; colIndex < headers.length; colIndex++) {
              var header = headers[colIndex];
              var value = row[header];
              var cell = sheetObject.cell(
                CellIndex.indexByColumnRow(
                  columnIndex: colIndex,
                  rowIndex: rowIndex + 1,
                ),
              );

              // Assign value to the cell
              if (value == null) {
                cell.value = TextCellValue(''); // Handle null values
              } else if (value is String) {
                cell.value = TextCellValue(value);
              } else if (value is int) {
                cell.value = IntCellValue(value);
              } else if (value is double) {
                cell.value = DoubleCellValue(value);
              } else if (value is bool) {
                cell.value = BoolCellValue(value);
              } else if (value is DateTime) {
                // Format the DateTime as DD/MM/YYYY
                String formattedDate = DateFormat('dd/MM/yyyy').format(value);
                cell.value = TextCellValue(formattedDate);
              } else {
                cell.value = TextCellValue(value.toString());
              }

              // Apply data cell style with borders
              cell.cellStyle = dataCellStyle;
            }
          }
        }
      }

      // Save the Excel file
      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'WasteData_${getCurrentDateTimeString()}.xlsx';
      String outputPath = '${directory.path}/$fileName';
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      print('Excel file saved at: $outputPath');
      return outputPath;
    } catch (e) {
      print('Error saving Excel file: $e');
      return '';
    }
  }

  // Helper function to get the current date and time as a string
  String getCurrentDateTimeString() {
    return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  }

  void resetFilters() {
    selectedStartDate.value = null;
    selectedEndDate.value = null;
  }
}
