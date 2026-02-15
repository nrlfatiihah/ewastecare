// import 'package:ewastecare/common/widget/analytic_details_card/admin_analytic_card_verticle.dart';
// import 'package:ewastecare/features/dashboard/controllers/admin_dashboard_controller.dart';
// import 'package:ewastecare/features/dashboard/screens/admin/admin_dashboard.dart';
// import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart1.dart';
// import 'package:ewastecare/features/dashboard/screens/admin/widget/admin_dashboard_chart2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DashboardHelper{
//    static Widget buildChartWidget(FilterController filterController, AdminDashboardController controller) {
//      if (filterController.selectedType.value == 'Plastic Collection') {
//       return const BarGraphPlasticInformation(); // Render plastic collection chart
//     } else {
//      return const BarGraphUserInformation();
// }
// }

// static List<Widget> buildAnalyticCards(FilterController filterController, AdminDashboardController controller) {
//     // Method to build the analytic cards based on the selected type
//     if (filterController.selectedType.value == 'Plastic Collection') {
//       return [
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'PP',
//           value: "${controller.totalTypePPSum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'PET',
//           value: "${controller.totalTypePETSum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'HDPE',
//           value: "${controller.totalTypeHDPESum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'Total Recycled Plastic',
//           value: "${controller.totalAllPlasticSum.value} Kg",
//         )),
//       ];
//     } else {
//       return [
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'PPTEST',
//           value: "${controller.totalTypePPSum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'PETTEST',
//           value: "${controller.totalTypePETSum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'HDPETEST',
//           value: "${controller.totalTypeHDPESum.value} Kg",
//         )),
//         Obx(() => AdminAnalyticCardVertical(
//           title: 'Total Recycled PlasticTEST',
//           value: "${controller.totalAllPlasticSum.value} Kg",
//         )),
//       ];
//     }
// }
// }
