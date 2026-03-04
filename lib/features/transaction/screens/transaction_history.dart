import 'package:ewastecare/features/transaction/screens/details_transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/sizes.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        actions: [
          // Filter / Date Range Picker
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Pick Date Range',
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  // Respect dark/light mode and custom theme
                  final theme = Theme.of(context);
                  return Theme(
                    data: theme.copyWith(
                      dialogTheme: DialogThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                controller.setDateRange(picked.start, picked.end);
                await controller.fetchDetailsTransactions(
                  picked.start,
                  picked.end,
                );
              }
            },
          ),

          // Reset Button
          Obx(() {
            final hasDate =
                controller.startDate.value != null &&
                controller.endDate.value != null;
            return hasDate
                ? IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset Date Range',
                    onPressed: () {
                      controller.setDateRange(null, null);
                      controller.transactions.clear();
                      controller.dataFetched2.value = false;
                    },
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),

      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: RefreshIndicator(
          onRefresh: () async {
            if (controller.startDate.value != null &&
                controller.endDate.value != null) {
              await controller.fetchDetailsTransactions(
                controller.startDate.value!,
                controller.endDate.value!,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(WasteSizes.defaultSpace),
              child: Obx(() {
                final start = controller.startDate.value;
                final end = controller.endDate.value;

                if (start == null || end == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "Please use the filter function to select start and end dates.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                } else if (controller.dataFetched2.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.transactions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "No data found",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  return DetailsTransactionHistory(
                    transactions: controller.transactions,
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
