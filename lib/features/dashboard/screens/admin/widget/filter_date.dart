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
      switch (selectedType) {
        case "User Information":
        case "Materials Distribution":
          await controller2.calculateMaterialWeightsByFilterDate(
            startDate,
            endDate,
          );
          break;
      }
    } else {
      switch (selectedType) {
        case "User Information":
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
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Choose a Type",
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Type Options
            Obx(() {
              return Column(
                children: [
                  _buildTypeOption(
                    context: context,
                    title: "User Information",
                    controller: controller,
                  ),
                  const SizedBox(height: 10),
                  _buildTypeOption(
                    context: context,
                    title: "Materials Distribution",
                    controller: controller,
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Date Section
            Text(
              "Select Date Range",
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final start = controller.selectedStartDate.value;
              final end = controller.selectedEndDate.value;
              final dateFormat = DateFormat('dd MMM yyyy');

              return InkWell(
                onTap: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: scaffoldContext,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.selectedStartDate.value = picked.start;
                    controller.selectedEndDate.value = picked.end;
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
                      color: theme.dividerColor.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          start == null || end == null
                              ? "No date range selected"
                              : "${dateFormat.format(start)} - ${dateFormat.format(end)}",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.resetFilters,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper for Type Options
  Widget _buildTypeOption({
    required BuildContext context,
    required String title,
    required AdminDashboardController controller,
  }) {
    final theme = Theme.of(context);
    final isSelected = controller.selectedType.value == title;

    return GestureDetector(
      onTap: () => controller.selectedType.value = title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
