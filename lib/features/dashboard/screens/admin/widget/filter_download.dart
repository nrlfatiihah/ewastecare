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
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: hasDateSelected
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.08),
                            theme.colorScheme.primary.withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: hasDateSelected ? null : theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasDateSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withOpacity(0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: hasDateSelected
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.grey.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: hasDateSelected
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date Range",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              hasDateSelected
                                  ? "${dateFormat.format(start!)} - ${dateFormat.format(end!)}"
                                  : "Tap to select date range",
                              key: ValueKey(hasDateSelected),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: hasDateSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: hasDateSelected
                                    ? theme.colorScheme.onSurface
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    AnimatedRotation(
                      turns: hasDateSelected ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: hasDateSelected
                            ? theme.colorScheme.primary
                            : Colors.grey,
                      ),
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
