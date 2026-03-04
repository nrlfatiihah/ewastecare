import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/features/dashboard/controllers/download_data_controller.dart';
import 'package:ewastecare/features/dashboard/controllers/test_donwload_data_controller.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DownloadData extends StatelessWidget {
  const DownloadData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DownloadWasteDataController.instance;
    final controller2 = TestDownloadWasteDataController.instance;

    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Download Waste Data to Excel",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          /// Date Range Section
          Text(
            "Select Date Range",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          /// Date Picker Card
          Obx(() {
            final start = controller2.selectedStartDate.value;
            final end = controller2.selectedEndDate.value;
            final dateFormat = DateFormat('dd MMM yyyy');
            final hasDateSelected = start != null && end != null;

            return InkWell(
              onTap: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller2.selectedStartDate.value = picked.start;
                  controller2.selectedEndDate.value = picked.end;
                }
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: hasDateSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: hasDateSelected
                          ? theme.colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasDateSelected
                            ? "${dateFormat.format(start!)} - ${dateFormat.format(end!)}"
                            : "No date range selected",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: hasDateSelected
                          ? theme.colorScheme.primary
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 30),

          /// Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller2.resetFilters,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WasteColors.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  child: const Text("Download"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
