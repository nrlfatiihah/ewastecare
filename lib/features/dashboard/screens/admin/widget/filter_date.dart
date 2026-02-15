import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({super.key});

  Future<void> _fetchDataBasedOnType({
    required String selectedType,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final controller = AdminDashboardController.instance;
    final controller2 = AdminDashboardService.instance;

    if (startDate != null && endDate != null) {
      // Fetch data with date filter
      switch (selectedType) {
        // case "Plastic Collection":
        case "User Information":
          await controller2.calculateMaterialWeightsByFilterDate(
            startDate,
            endDate,
          );
          // await controller.fetchAdminDashboardDataByFilterDate(
          //     startDate, endDate);
          break;
        case "Materials Distribution":
          await controller2.calculateMaterialWeightsByFilterDate(
            startDate,
            endDate,
          );
          break;
      }
    } else {
      // Fetch default data (no date filter)
      switch (selectedType) {
        // case "Plastic Collection":
        case "User Information":
          await controller2.calculateMaterialWeights();
          break;
        // await controller.fetchAdminDashboardData();
        // break;
        case "Materials Distribution":
          await controller2.calculateMaterialWeights();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AdminDashboardController.instance;
    final controller2 = AdminDashboardService.instance;
    final scaffoldContext = context;

    return SingleChildScrollView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose a Type",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...[
            // "Plastic Collection",
            "User Information",
            "Materials Distribution",
          ].map((type) {
            return Obx(
              () => RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: controller.selectedType.value,
                onChanged: (String? value) {
                  controller.selectedType.value = value!;
                },
              ),
            );
          }),
          const SizedBox(height: 20),
          const Text(
            "Select Date Range",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Obx(() {
              final start = controller.selectedStartDate.value;
              final end = controller.selectedEndDate.value;
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
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                // Update both controllers' dates
                controller.selectedStartDate.value = picked.start;
                controller.selectedEndDate.value = picked.end;
                controller2.selectedStartDate.value = picked.start;
                controller2.selectedEndDate.value = picked.end;
              }
            },
          ),
          const SizedBox(height: 20),
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
                onPressed: () async {
                  final currentContext = context;

                  await _fetchDataBasedOnType(
                    selectedType: controller.selectedType.value,
                    startDate: controller.selectedStartDate.value,
                    endDate: controller.selectedEndDate.value,
                  );

                  if (currentContext.mounted) {
                    Navigator.pop(currentContext);
                  }
                },
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
                child: const Text("Confirm"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
