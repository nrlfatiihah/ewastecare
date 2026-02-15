// // import 'package:ewastecare/common/widget/appbar/appbar.dart';
// // import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
// // import 'package:ewastecare/features/Waste_point/controller/material_controller.dart';
// // import 'package:ewastecare/features/Waste_point/model/material_model.dart';
// // import 'package:ewastecare/features/Waste_point/widget/test_add_rate_action_button.dart';
// // import 'package:ewastecare/utils/constants/sizes.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class AdminSegmentInfo extends StatelessWidget {
// //   const AdminSegmentInfo({super.key});
  
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = Get.put(MaterialController());
// //     final adminDashboardService = AdminDashboardService();

// //     return Scaffold(
// //       appBar: WasteAppBar(
// //         showBackArrow: true,
// //         title: Text("Recycle Rate", style: Theme.of(context).textTheme.headlineSmall),
// //       ),
// //       body: RefreshIndicator(
// //         onRefresh: () async {
// //           controller.resetDataFetched(); // Reset dataFetched flag
// //           await controller.fetchRateMaterials(); // Fetch user record again
// //         },
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           child: Padding(
// //             padding: const EdgeInsets.all(WasteSizes.defaultSpace),
// //             child: Obx(() {
// //               return ClipRRect(
// //                 borderRadius: BorderRadius.circular(20),
// //                 child: Container(
// //                   margin: EdgeInsets.all(WasteSizes.defaultSpace),
// //                   padding: EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     color: Theme.of(context).cardColor, // Background color of the panel
// //                     borderRadius: BorderRadius.all(Radius.circular(20)), // Match border radius
// //                     border: Border.all(
// //                       color: Theme.of(context).colorScheme.outline, // Change this to your desired border color
// //                       width: 2, // Adjust the border width as needed
// //                     ),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       _buildExpansionPanel(
// //                         context: context,
// //                         title: "Plastic Materials",
// //                         icon: Icons.recycling,
// //                         percentage: adminDashboardService.materialGroupPercentages['Plastic'] ?? 0.0,
// //                         isExpanded: controller.isPlasticExpanded.value,
// //                         onExpansionChanged: (isExpanded) => controller.isPlasticExpanded.value = isExpanded,
// //                         materials: controller.plasticMaterials,
// //                         controller: controller,
// //                       ),
// //                       _buildExpansionPanel(
// //                         context: context,
// //                         title: "Paper Materials",
// //                         icon: Icons.description,
// //                         percentage: adminDashboardService.materialGroupPercentages['Paper'] ?? 0.0,
// //                         isExpanded: controller.isPaperExpanded.value,
// //                         onExpansionChanged: (isExpanded) => controller.isPaperExpanded.value = isExpanded,
// //                         materials: controller.paperMaterials,
// //                         controller: controller,
// //                       ),
// //                       _buildExpansionPanel(
// //                         context: context,
// //                         title: "Can Materials",
// //                         icon: Icons.directions_car,
// //                         percentage: adminDashboardService.materialGroupPercentages['Can'] ?? 0.0,
// //                         isExpanded: controller.isCanExpanded.value,
// //                         onExpansionChanged: (isExpanded) => controller.isCanExpanded.value = isExpanded,
// //                         materials: controller.canMaterials,
// //                         controller: controller,
// //                       ),
// //                       _buildExpansionPanel(
// //                         context: context,
// //                         title: "Used Oil Materials",
// //                         icon: Icons.local_gas_station,
// //                         percentage: adminDashboardService.materialGroupPercentages['Used Oil'] ?? 0.0,
// //                         isExpanded: controller.isCookingOilExpanded.value,
// //                         onExpansionChanged: (isExpanded) => controller.isCookingOilExpanded.value = isExpanded,
// //                         materials: controller.oilMaterials,
// //                         controller: controller,
// //                       ),
// //                       _buildExpansionPanel(
// //                         context: context,
// //                         title: "Others",
// //                         icon: Icons.miscellaneous_services,
// //                         percentage: adminDashboardService.materialGroupPercentages['Others'] ?? 0.0,
// //                         isExpanded: controller.isOthersExpanded.value,
// //                         onExpansionChanged: (isExpanded) => controller.isOthersExpanded.value = isExpanded,
// //                         materials: controller.othersMaterials,
// //                         controller: controller,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             }),
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: const TestRateActionbutton(),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
// //   }

// //   Widget _buildExpansionPanel({
// //     required BuildContext context,
// //     required String title,
// //     required IconData icon,
// //     required double percentage,
// //     required bool isExpanded,
// //     required void Function(bool) onExpansionChanged,
// //     required List<MaterialModel> materials,
// //     required MaterialController controller,
// //   }) {
// //     return ExpansionPanelList(
// //       elevation: 0,
// //       expandedHeaderPadding: EdgeInsets.all(0),
// //       dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
// //       expansionCallback: (index, isExpanded) {
// //         print("Panel $index: $isExpanded");
// //         onExpansionChanged(!isExpanded);
// //       },
// //       children: [
// //         ExpansionPanel(
// //           headerBuilder: (context, isExpanded) {
// //             return Container(
// //               padding: EdgeInsets.all(10),
// //               child: ListTile(
// //                 title: Text(
// //                   '$title: ${percentage.toStringAsFixed(2)}%',
// //                   style: Theme.of(context).textTheme.titleLarge,
// //                 ),
// //                 leading: Icon(icon, color: Theme.of(context).iconTheme.color),
// //               ),
// //             );
// //           },
// //           body: Container(
// //             padding: EdgeInsets.all(16),
// //             child: Column(
// //               children: materials.map((material) {
// //                 final TextEditingController textController = TextEditingController(
// //                   text: material.value.toStringAsFixed(2),
// //                 );

// //                 // Calculate individual material contribution
// //                 final double totalWeight = materials.fold(0, (sum, item) => sum + item.value);
// //                 final double materialPercentage = (material.value / totalWeight) * 100;

// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     ListTile(
// //                       title: Text(
// //                         '${material.name}: (Total weight: ${material.value.toStringAsFixed(2)} Kg | ${materialPercentage.toStringAsFixed(2)}%)',
// //                       ),
// //                       subtitle: Text('Value: RM ${textController.text}'),
// //                       trailing: IconButton(
// //                         icon: Icon(Icons.edit),
// //                         onPressed: () {
// //                           showDialog(
// //                             context: context,
// //                             builder: (context) {
// //                               return AlertDialog(
// //                                 title: Text('Edit Value for ${material.name}'),
// //                                 content: TextField(
// //                                   controller: textController,
// //                                   keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                                   decoration: InputDecoration(
// //                                     labelText: 'Enter new value',
// //                                     border: OutlineInputBorder(),
// //                                   ),
// //                                 ),
// //                                 actions: [
// //                                   TextButton(
// //                                     onPressed: () {
// //                                       final newValue = double.tryParse(textController.text) ?? material.value;
// //                                       material.value = newValue;
// //                                       controller.updateMaterial(material);
// //                                       Navigator.of(context).pop();
// //                                     },
// //                                     child: Text('Save'),
// //                                   ),
// //                                   TextButton(
// //                                     onPressed: () => Navigator.of(context).pop(),
// //                                     child: Text('Cancel'),
// //                                   ),
// //                                 ],
// //                               );
// //                             },
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //           isExpanded: isExpanded,
// //           canTapOnHeader: true,
// //         ),
// //       ],
// //     );
// //   }
// // }


// // import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';


// // class AdminSegmentInfo extends StatelessWidget {
// //   const AdminSegmentInfo({super.key});
  
// //   @override
// //   Widget build(BuildContext context) {
// //     final adminDashboardService = Get.put(AdminDashboardService());

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Recycle Rate", style: Theme.of(context).textTheme.headlineSmall),
// //       ),
// //       body: RefreshIndicator(
// //         onRefresh: () async {
// //           await adminDashboardService.calculateMaterialWeights();
// //         },
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: FutureBuilder(
// //               future: adminDashboardService.calculateMaterialWeights(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(child: CircularProgressIndicator());
// //                 }
// //                 if (snapshot.hasError) {
// //                   return Center(child: Text('Error: ${snapshot.error}'));
// //                 }

// //                 final materialGroupWeights = adminDashboardService.materialGroupWeights;

// //                 return Column(
// //                   children: [
// //                     _buildExpansionPanel(
// //                       context: context,
// //                       title: "Plastic Materials",
// //                       icon: Icons.recycling,
// //                       percentage: _calculatePercentage('Plastic', materialGroupWeights),
// //                       materials: _getMaterialList('Plastic', materialGroupWeights),
// //                     ),
// //                     _buildExpansionPanel(
// //                       context: context,
// //                       title: "Paper Materials",
// //                       icon: Icons.description,
// //                       percentage: _calculatePercentage('Paper', materialGroupWeights),
// //                       materials: _getMaterialList('Paper', materialGroupWeights),
// //                     ),
// //                     _buildExpansionPanel(
// //                       context: context,
// //                       title: "Can Materials",
// //                       icon: Icons.directions_car,
// //                       percentage: _calculatePercentage('Can', materialGroupWeights),
// //                       materials: _getMaterialList('Can', materialGroupWeights),
// //                     ),
// //                     _buildExpansionPanel(
// //                       context: context,
// //                       title: "Used Oil Materials",
// //                       icon: Icons.local_gas_station,
// //                       percentage: _calculatePercentage('Used Oil', materialGroupWeights),
// //                       materials: _getMaterialList('Used Oil', materialGroupWeights),
// //                     ),
// //                     _buildExpansionPanel(
// //                       context: context,
// //                       title: "Others",
// //                       icon: Icons.miscellaneous_services,
// //                       percentage: _calculatePercentage('Others', materialGroupWeights),
// //                       materials: _getMaterialList('Others', materialGroupWeights),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   double _calculatePercentage(String group, Map<String, double> weights) {
// //     double totalWeight = weights.values.fold(0, (sum, weight) => sum + weight);
// //     return totalWeight > 0 ? (weights[group] ?? 0) / totalWeight * 100 : 0;
// //   }

// //   List<Widget> _getMaterialList(String group, Map<String, double> weights) {
// //     final materialWeight = weights[group] ?? 0.0;
// //     return [
// //       ListTile(
// //         title: Text('$group: ${materialWeight.toStringAsFixed(2)} Kg'),
// //       ),
// //     ];
// //   }

// //   Widget _buildExpansionPanel({
// //     required BuildContext context,
// //     required String title,
// //     required IconData icon,
// //     required double percentage,
// //     required List<Widget> materials,
// //   }) {
// //     return ExpansionPanelList(
// //       elevation: 0,
// //       expandedHeaderPadding: EdgeInsets.all(0),
// //       dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
// //       children: [
// //         ExpansionPanel(
// //           headerBuilder: (context, isExpanded) {
// //             return ListTile(
// //               title: Text(
// //                 '$title: ${percentage.toStringAsFixed(2)}%',
// //                 style: Theme.of(context).textTheme.titleLarge,
// //               ),
// //               leading: Icon(icon, color: Theme.of(context).iconTheme.color),
// //             );
// //           },
// //           body: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: materials,
// //           ),
// //           isExpanded: true,
// //           canTapOnHeader: true,
// //         ),
// //       ],
// //     );
// //   }
// // }


// import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//  // Update with your correct import path

// class AdminSegmentInfo extends StatelessWidget {
//   const AdminSegmentInfo({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     final adminDashboardService = Get.put(AdminDashboardService());

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Recycle Rate", style: Theme.of(context).textTheme.headlineSmall),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await adminDashboardService.calculateMaterialWeights();
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(16), // Adjust padding as needed
//             child: Obx(() {
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   margin: EdgeInsets.all(16), // Adjust margin as needed
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor, // Background color of the panel
//                     borderRadius: BorderRadius.circular(20), // Match border radius
//                     border: Border.all(
//                       color: Theme.of(context).colorScheme.outline, // Border color
//                       width: 2, // Border width
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildExpansionPanel(
//                         context: context,
//                         title: "Plastic Materials",
//                         icon: Icons.recycling,
//                         percentage: _calculatePercentage('Plastic', adminDashboardService.materialGroupWeights),
//                         materials: _getMaterialList('Plastic', adminDashboardService.materialGroupWeights),
//                       ),
//                       _buildExpansionPanel(
//                         context: context,
//                         title: "Paper Materials",
//                         icon: Icons.description,
//                         percentage: _calculatePercentage('Paper', adminDashboardService.materialGroupWeights),
//                         materials: _getMaterialList('Paper', adminDashboardService.materialGroupWeights),
//                       ),
//                       _buildExpansionPanel(
//                         context: context,
//                         title: "Can Materials",
//                         icon: Icons.directions_car,
//                         percentage: _calculatePercentage('Can', adminDashboardService.materialGroupWeights),
//                         materials: _getMaterialList('Can', adminDashboardService.materialGroupWeights),
//                       ),
//                       _buildExpansionPanel(
//                         context: context,
//                         title: "Used Oil Materials",
//                         icon: Icons.local_gas_station,
//                         percentage: _calculatePercentage('Used Oil', adminDashboardService.materialGroupWeights),
//                         materials: _getMaterialList('Used Oil', adminDashboardService.materialGroupWeights),
//                       ),
//                       _buildExpansionPanel(
//                         context: context,
//                         title: "Others",
//                         icon: Icons.miscellaneous_services,
//                         percentage: _calculatePercentage('Others', adminDashboardService.materialGroupWeights),
//                         materials: _getMaterialList('Others', adminDashboardService.materialGroupWeights),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   double _calculatePercentage(String group, Map<String, double> weights) {
//     double totalWeight = weights.values.fold(0, (sum, weight) => sum + weight);
//     return totalWeight > 0 ? (weights[group] ?? 0) / totalWeight * 100 : 0;
//   }

//   List<Widget> _getMaterialList(String group, Map<String, double> weights) {
//     final materialWeight = weights[group] ?? 0.0;
//     return [
//       ListTile(
//         title: Text('$group: ${materialWeight.toStringAsFixed(2)} Kg'),
//       ),
//     ];
//   }

//   Widget _buildExpansionPanel({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required double percentage,
//     required List<Widget> materials,
//   }) {
//     return ExpansionPanelList(
//       elevation: 0,
//       expandedHeaderPadding: EdgeInsets.all(0),
//       dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
//       children: [
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) {
//             return ListTile(
//               title: Text(
//                 '$title: ${percentage.toStringAsFixed(2)}%',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               leading: Icon(icon, color: Theme.of(context).iconTheme.color),
//             );
//           },
//           body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: materials,
//           ),
//           isExpanded: true,
//           canTapOnHeader: true,
//         ),
//       ],
//     );
//   }
// }
