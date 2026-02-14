import 'package:ewastecare/widgets/loaders/loaders.dart';
import 'package:ewastecare/controllers/download_data_controller.dart';
import 'package:ewastecare/controllers/test_download_data_controller.data';
import 'package:ewastecare/constants/colors.dart';
import 'package:ewastecare/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DownloadData extends StatelessWidget {
  const DownloadData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DownloadWasteDataController.instance;
    final controller2 = TestDownloadWasteDataController.instance;
    final scaffoldContext = context;

    return SingleChildScrollView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Download Data to Excel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Date Range",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Obx(() {
              final start = controller2.selectedStartDate.value;
              final end = controller2.selectedEndDate.value;
              final dateFormat = DateFormat('dd-MM-yyyy');
              return Text(
                start == null || end == null
                    ? "No date range selected"
                    : "${dateFormat.format(start)} - ${dateFormat.format(end)}",
              );
            }),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: scaffoldContext,
                firstDate: DateTime(2026),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller2.selectedStartDate.value = picked.start;
                controller2.selectedEndDate.value = picked.end;
              }
            },
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  controller.resetFilters();
                },
                child: const Text("Reset"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: WasteColors.buttonPrimary,
                  side: const BorderSide(color: WasteColors.buttonPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 15,
                  ),
                ),
                onPressed: () async {
                  if (controller2.selectedStartDate.value != null &&
                      controller2.selectedEndDate.value != null) {
                    await controller2.generateAndShareExcel(
                      controller2.selectedStartDate.value!,
                      controller2.selectedEndDate.value!,
                    );
                  } else {
                    WasteLoaders.errorSnackBar(
                      title: "Oops!",
                      message:
                          "Please select the desired start and end date to download the data",
                    );
                  }
                },
                child: const Text("Download"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
