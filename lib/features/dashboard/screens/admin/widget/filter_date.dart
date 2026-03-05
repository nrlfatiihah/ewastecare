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
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor: WasteColors.buttonPrimary,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ).copyWith(
                          side: WidgetStateProperty.all(BorderSide.none),
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
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
