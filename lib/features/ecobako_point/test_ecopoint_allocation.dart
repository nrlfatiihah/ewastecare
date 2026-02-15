// // import 'package:ewastecare/features/Waste_point/controller/test_controller.dart';
// // import 'package:ewastecare/features/Waste_point/model/rate_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class AdminPointAllocationScreen extends StatelessWidget {
// //   const AdminPointAllocationScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = Get.put(AdminPointControllerTest());

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Allocate Points'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               // User ID input
// //               Form(
// //                 key: controller.addPointFormKey,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     TextFormField(
// //                       controller: controller.userID,
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter User ID';
// //                         }
// //                         return null;
// //                       },
// //                       decoration: const InputDecoration(
// //                         labelText: 'User ID',
// //                         prefixIcon: Icon(Icons.person),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16.0),

// //                     // Material lists
// //                     _buildMaterialExpansionPanel(
// //                       context,
// //                       'Plastic',
// //                       controller.plasticMaterials,
// //                       controller.isPlasticExpanded,
// //                     ),
// //                     _buildMaterialExpansionPanel(
// //                       context,
// //                       'Paper',
// //                       controller.paperMaterials,
// //                       controller.isPaperExpanded,
// //                     ),
// //                     _buildMaterialExpansionPanel(
// //                       context,
// //                       'Can',
// //                       controller.canMaterials,
// //                       controller.isCanExpanded,
// //                     ),
// //                     _buildMaterialExpansionPanel(
// //                       context,
// //                       'Used Oil',
// //                       controller.oilMaterials,
// //                       controller.isCookingOilExpanded,
// //                     ),
// //                     _buildMaterialExpansionPanel(
// //                       context,
// //                       'Others',
// //                       controller.othersMaterials,
// //                       controller.isOthersExpanded,
// //                     ),

// //                     const SizedBox(height: 16.0),

// //                     // Allocate button
// //                     ElevatedButton(
// //                       onPressed: controller.allocatePoints,
// //                       child: const Text('Allocate Points'),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMaterialExpansionPanel(
// //     BuildContext context,
// //     String type,
// //     List<MaterialModel> materials,
// //     RxBool isExpanded,
// //   ) {
// //     return Obx(
// //       () => ExpansionPanelList(
// //         elevation: 1,
// //         expandedHeaderPadding: EdgeInsets.zero,
// //         dividerColor: Theme.of(context).dividerColor,
// //         expansionCallback: (_, isExpandedValue) {
// //           isExpanded.value = !isExpandedValue;
// //         },
// //         children: [
// //           ExpansionPanel(
// //             headerBuilder: (context, isExpandedValue) {
// //               return ListTile(
// //                 title: Text(
// //                   type,
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //               );
// //             },
// //             body: Column(
// //               children: materials.map((material) {
// //                 final controller = Get.find<AdminPointControllerTest>().weightControllers[material.id]!;
// //                 return ListTile(
// //                   title: Text(material.name),
// //                   subtitle: TextFormField(
// //                     controller: controller,
// //                     keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                     decoration: InputDecoration(
// //                       labelText: 'Weight (Kg)',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter weight';
// //                       }
// //                       final weight = double.tryParse(value);
// //                       if (weight == null || weight <= 0) {
// //                         return 'Enter a valid weight';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //             isExpanded: isExpanded.value,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // import 'package:ewastecare/features/Waste_point/controller/test_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:ewastecare/features/Waste_point/model/rate_model.dart';

// // class AdminPointAllocationScreenTest extends StatelessWidget {
// //   const AdminPointAllocationScreenTest({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = Get.put(AdminPointControllerTest());

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Point Allocation'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text('Allocate Points to User', style: Theme.of(context).textTheme.headline6),
// //               SizedBox(height: 16.0),
// //               TextFormField(
// //                 controller: controller.userID,
// //                 decoration: InputDecoration(
// //                   labelText: 'User ID',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               SizedBox(height: 16.0),
// //               Obx(() {
// //                 List<Widget> materialsWidgets = [];

// //                 // Combine all material lists
// //                 final allMaterials = [
// //                   ...controller.plasticMaterials,
// //                   ...controller.paperMaterials,
// //                   ...controller.canMaterials,
// //                   ...controller.oilMaterials,
// //                   ...controller.othersMaterials,
// //                 ];

// //                 for (var material in allMaterials) {
// //                   materialsWidgets.add(_buildMaterialInput(material, controller));
// //                 }

// //                 return Column(children: materialsWidgets);
// //               }),
// //               SizedBox(height: 16.0),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   controller.allocatePoints();
// //                 },
// //                 child: Text('Allocate Points'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMaterialInput(MaterialModel material, AdminPointControllerTest controller) {
// //     final weightController = controller.weightControllers[material.name] ?? TextEditingController();

// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8.0),
// //       child: TextFormField(
// //         controller: weightController,
// //         keyboardType: TextInputType.numberWithOptions(decimal: true),
// //         decoration: InputDecoration(
// //           labelText: '${material.name} Weight (Kg)',
// //           border: OutlineInputBorder(),
// //         ),
// //         validator: (value) {
// //           final weight = double.tryParse(value ?? '');
// //           if (weight == null || weight < 0) {
// //             return 'Please enter a valid weight';
// //           }
// //           return null;
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:ewastecare/common/widget/appbar/appbar.dart';
// import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
// import 'package:ewastecare/features/Waste_point/controller/test_controller.dart';
// import 'package:ewastecare/features/Waste_point/model/rate_model.dart';
// import 'package:ewastecare/features/Waste_point/widget/eco_point_qr_scan.dart';
// import 'package:ewastecare/features/home/screens/admin/widgets/drawer_admin.dart';
// import 'package:ewastecare/utils/constants/colors.dart';
// import 'package:ewastecare/utils/constants/sizes.dart';
// import 'package:ewastecare/utils/constants/texts.dart';
// import 'package:ewastecare/utils/validators/validation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class AdminPointAllocationScreenTest extends StatelessWidget {
//   const AdminPointAllocationScreenTest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AdminPointControllerTest());
//     return Scaffold(
//       endDrawer: AdminEndDrawer(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             WastePrimaryHeaderContainer(
//               child: Column(
//                 children: [
//                   WasteAppBar(
//                     title: Text(
//                       WasteTexts.allocationPage,
//                       style: Theme.of(context).textTheme.headlineMedium!.apply(color: WasteColors.white),
//                     ),
//                   ),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//               ],
//             )
//             ),
//             // Your header and other widgets here...
//             Padding(
//               padding: const EdgeInsets.all(WasteSizes.defaultSpace),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                        Text(WasteTexts.pointTitle,
//                       style: Theme.of(context).textTheme.headlineMedium),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   Form(
//                       key: controller.addPointFormKey,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: controller.userID,
//                                   validator: (value) =>
//                                       WasteValidator.validateEmptyText(
//                                           "User ID", value),
//                                   decoration: const InputDecoration(
//                                       labelText: WasteTexts.userID,
//                                       prefixIcon: Icon(Iconsax.user_edit)),
//                                 ),
//                               ),
//                               const SizedBox(width: WasteSizes.spaceBtwInputFields),
//                               GestureDetector(
//                                 onTap: () async {
//                                   final scannedData = await Get.to(
//                                       () => const QRScannerScreen());
//                                   if (scannedData != null) {
//                                     controller.userID.text = scannedData;
//                                   }
//                                 },
//                                 child: const Icon(Iconsax.scan_barcode, size: 35,),
//                               )
//                             ],
//                           ),
//                           const SizedBox(height: WasteSizes.spaceBtwInputFields),
//                           Obx(() {
//                             return ExpansionPanelList(
//                               elevation: 0,
//                               expandedHeaderPadding: EdgeInsets.all(0),
//                               expansionCallback: (index, isExpanded) {
//                                 switch (index) {
//                                   case 0:
//                                     controller.isPlasticExpanded.value = !controller.isPlasticExpanded.value;
//                                     break;
//                                   case 1:
//                                     controller.isPaperExpanded.value = !controller.isPaperExpanded.value;
//                                     break;
//                                   case 2:
//                                     controller.isCanExpanded.value = !controller.isCanExpanded.value;
//                                     break;
//                                   case 3:
//                                     controller.isCookingOilExpanded.value = !controller.isCookingOilExpanded.value;
//                                     break;
//                                 }
//                               },
//                               children: [
//                                 _buildMaterialPanel(
//                                   context,
//                                   controller,
//                                   'Plastic Materials',
//                                   Icons.recycling,
//                                   controller.plasticMaterials,
//                                   controller.isPlasticExpanded.value,
//                                 ),
//                                 _buildMaterialPanel(
//                                   context,
//                                   controller,
//                                   'Paper Materials',
//                                   Icons.article,
//                                   controller.paperMaterials,
//                                   controller.isPaperExpanded.value,
//                                 ),
//                                 _buildMaterialPanel(
//                                   context,
//                                   controller,
//                                   'Can Materials',
//                                   Icons.coffee,
//                                   controller.canMaterials,
//                                   controller.isCanExpanded.value,
//                                 ),
//                                 _buildMaterialPanel(
//                                   context,
//                                   controller,
//                                   'Used Oil Materials',
//                                   Icons.oil_barrel,
//                                   controller.oilMaterials,
//                                   controller.isCookingOilExpanded.value,
//                                 ),
//                               ],
//                             );
//                           }),
//                           ],

//                         ),
//                       ),
//           ],
//         ),
//       ),
//     );
//   }

//   ExpansionPanel _buildMaterialPanel(
//     BuildContext context,
//     AdminPointControllerTest controller,
//     String title,
//     IconData icon,
//     List<MaterialModel> materials,
//     bool isExpanded,
//   ) {
//     return ExpansionPanel(
//       headerBuilder: (context, isExpanded) {
//         return ListTile(
//           leading: Icon(icon, color: Theme.of(context).iconTheme.color),
//           title: Text(title, style: Theme.of(context).textTheme.titleLarge),
//         );
//       },
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: materials.map((material) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: TextFormField(
//                 controller: controller.weightControllers[material.name],
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 validator: (value) {
//                   // Your validation logic here
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   labelText: '${material.name} Weight (Kg)',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//       isExpanded: isExpanded,
//       canTapOnHeader: true,
//     );
//   }
// }

import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/ecobako_point/controller/old_ecopoint_test_controller.dart';
import 'package:ewastecare/features/ecobako_point/model/rate_model.dart';
import 'package:ewastecare/features/ecobako_point/widget/eco_point_qr_scan.dart';
import 'package:ewastecare/features/home/screens/admin/widgets/drawer_admin.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminPointAllocationScreenTest extends StatelessWidget {
  const AdminPointAllocationScreenTest({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllocateEcoPointController());
    return Scaffold(
      endDrawer: AdminEndDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WastePrimaryHeaderContainer(
              child: Column(
                children: [
                  WasteAppBar(
                    title: Text(
                      WasteTexts.allocationPage,
                      style: Theme.of(context).textTheme.headlineMedium!.apply(
                        color: WasteColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(WasteSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WasteTexts.pointTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Form(
                    key: controller.addPointFormKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(WasteSizes.defaultSpace),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.userID,
                                  validator: (value) =>
                                      WasteValidator.validateEmptyText(
                                        "User ID",
                                        value,
                                      ),
                                  decoration: const InputDecoration(
                                    labelText: WasteTexts.userID,
                                    prefixIcon: Icon(Iconsax.user_edit),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: WasteSizes.spaceBtwInputFields,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final scannedData = await Get.to(
                                    () => const QRScannerScreen(),
                                  );
                                  if (scannedData != null) {
                                    controller.userID.text = scannedData;
                                  }
                                },
                                child: const Icon(
                                  Iconsax.scan_barcode,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              margin: EdgeInsets.all(WasteSizes.defaultSpace),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).cardColor, // Background color of the panel
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ), // Match border radius
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline, // Change this to your desired border color
                                  width: 2, // Adjust the border width as needed
                                ),
                              ),
                              child: ExpansionPanelList(
                                elevation: 0,
                                expandedHeaderPadding: EdgeInsets.zero,
                                expansionCallback: (index, isExpanded) {
                                  switch (index) {
                                    case 0:
                                      controller.isPlasticExpanded.value =
                                          !controller.isPlasticExpanded.value;
                                      break;
                                    case 1:
                                      controller.isPaperExpanded.value =
                                          !controller.isPaperExpanded.value;
                                      break;
                                    case 2:
                                      controller.isCanExpanded.value =
                                          !controller.isCanExpanded.value;
                                      break;
                                    case 3:
                                      controller.isCookingOilExpanded.value =
                                          !controller
                                              .isCookingOilExpanded
                                              .value;
                                      break;
                                    case 4:
                                      controller.isOthersExpanded.value =
                                          !controller.isOthersExpanded.value;
                                      break;
                                  }
                                },
                                children: [
                                  _buildMaterialPanel(
                                    context,
                                    'Plastic Materials',
                                    Icons.recycling,
                                    controller.plasticMaterials,
                                    controller.isPlasticExpanded.value,
                                  ),
                                  _buildMaterialPanel(
                                    context,
                                    'Paper Materials',
                                    Icons.article,
                                    controller.paperMaterials,
                                    controller.isPaperExpanded.value,
                                  ),
                                  _buildMaterialPanel(
                                    context,
                                    'Can Materials',
                                    Icons.coffee,
                                    controller.canMaterials,
                                    controller.isCanExpanded.value,
                                  ),
                                  _buildMaterialPanel(
                                    context,
                                    'Used Oil Materials',
                                    Icons.oil_barrel,
                                    controller.oilMaterials,
                                    controller.isCookingOilExpanded.value,
                                  ),
                                  _buildMaterialPanel(
                                    context,
                                    'Others Materials',
                                    Icons.other_houses,
                                    controller.othersMaterials,
                                    controller.isOthersExpanded.value,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Container(
                          margin: EdgeInsets.all(WasteSizes.defaultSpace),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                // await controller.addUserPoints();
                                // controller.clearFields();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WasteColors.buttonPrimary,
                                side: const BorderSide(
                                  color: WasteColors.buttonPrimary,
                                ),
                              ),
                              child: const Text(WasteTexts.addPoint),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanel _buildMaterialPanel(
    BuildContext context,
    String title,
    IconData icon,
    List<OldMaterialModel> materials,
    bool isExpanded,
  ) {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: materials.map((material) {
            final weightController =
                Get.find<AllocateEcoPointController>()
                    .weightControllers[material.name] ??
                TextEditingController();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: '${material.name} weight (Kg)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final weight = double.tryParse(value ?? '');
                  if (weight == null || weight < 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
            );
          }).toList(),
        ),
      ),
      isExpanded: isExpanded,
      canTapOnHeader: true,
    );
  }
}
