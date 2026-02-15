import 'package:ewastecare/features/transaction/screens/details_transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:ewastecare/utils/constants/sizes.dart'; // Make sure this import is correct

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );

              if (picked != null) {
                controller.setDateRange(picked.start, picked.end);
                controller.fetchDetailsTransactions(picked.start, picked.end);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
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
              if (controller.startDate.value == null ||
                  controller.endDate.value == null) {
                return const Center(
                  child: Text(
                    "Please use the filter function to select start and end dates.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else if (controller.dataFetched2.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.transactions.isEmpty) {
                return const Center(
                  child: Text("No data found", style: TextStyle(fontSize: 16)),
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
    );
  }
}
