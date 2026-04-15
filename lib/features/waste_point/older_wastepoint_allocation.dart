import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/features/waste_point/controller/older_waste_point_controller.dart';
import 'package:ewastecare/features/waste_point/widget/eco_point_qr_scan.dart';
import 'package:ewastecare/features/home/screens/admin/widgets/drawer_admin.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OlderAdminPointAllocationScreen extends StatelessWidget {
  const OlderAdminPointAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OlderAdminPointController());
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
                      WasteTexts.allocationPage.tr,
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
                    WasteTexts.pointTitle.tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  Form(
                    key: controller.addPointFormKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.userID,
                                validator: (value) =>
                                    WasteValidator.validateEmptyText(
                                      "User ID",
                                      value,
                                    ),
                                decoration: InputDecoration(
                                  labelText: WasteTexts.userID.tr,
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
                              child: const Icon(Iconsax.scan_barcode, size: 35),
                            ),
                          ],
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwInputFields),

                        Obx(
                          () => Container(
                            margin: EdgeInsets.all(
                              4,
                            ), // Adjust margin if needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline, // Use theme color for border
                                width: 1.0, // Border width
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ExpansionPanelList(
                                elevation: 0,
                                expandedHeaderPadding: EdgeInsets.all(0),
                                dividerColor: Theme.of(context).dividerColor
                                    .withOpacity(0.6), // Divider color
                                expansionCallback: (index, isExpanded) {
                                  if (index == 0) {
                                    controller.isPlasticExpanded.value =
                                        !controller.isPlasticExpanded.value;
                                  } else if (index == 1) {
                                    controller.isPaperExpanded.value =
                                        !controller.isPaperExpanded.value;
                                  } else if (index == 2) {
                                    controller.isCanExpanded.value =
                                        !controller.isCanExpanded.value;
                                  } else if (index == 3) {
                                    controller.isCookingOilExpanded.value =
                                        !controller.isCookingOilExpanded.value;
                                  }
                                },
                                children: [
                                  ExpansionPanel(
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                          title: Text(
                                            WasteTexts.plasticLabel.tr,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          leading: Icon(
                                            Icons.recycling,
                                            color: Theme.of(
                                              context,
                                            ).iconTheme.color,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: controller.petWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "PET Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  WasteTexts.weightPET.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                          TextFormField(
                                            controller: controller.hdpeWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "HDPE Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  WasteTexts.weightHDPE.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                          TextFormField(
                                            controller: controller.ppWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "PP Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText: WasteTexts.weightPP.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded:
                                        controller.isPlasticExpanded.value,
                                    canTapOnHeader: true,
                                  ),
                                  ExpansionPanel(
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                          title: Text(
                                            WasteTexts.paperLabel.tr,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          leading: Icon(
                                            Icons.description,
                                            color: Theme.of(
                                              context,
                                            ).iconTheme.color,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: controller.booksWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "Books Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  WasteTexts.weightPaper.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                          TextFormField(
                                            controller:
                                                controller.newspaperWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "Newspaper Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  WasteTexts.weightBox.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded:
                                        controller.isPaperExpanded.value,
                                    canTapOnHeader: true,
                                  ),
                                  ExpansionPanel(
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                          title: Text(
                                            WasteTexts.canLabel.tr,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          leading: Icon(
                                            Icons.recycling,
                                            color: Theme.of(
                                              context,
                                            ).iconTheme.color,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: controller.petWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "PET Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText: WasteTexts
                                                  .weightAluminiumCan
                                                  .tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                          TextFormField(
                                            controller: controller.hdpeWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "HDPE Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  WasteTexts.weightSteelCan.tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded: controller.isCanExpanded.value,
                                    canTapOnHeader: true,
                                  ),
                                  ExpansionPanel(
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                        padding: EdgeInsets.all(10),
                                        child: ListTile(
                                          title: Text(
                                            WasteTexts.oilLabel.tr,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          leading: Icon(
                                            Icons.recycling,
                                            color: Theme.of(
                                              context,
                                            ).iconTheme.color,
                                          ),
                                        ),
                                      );
                                    },
                                    body: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: controller.petWeight,
                                            validator: (value) =>
                                                WasteValidator.validateDecimalPlaces(
                                                  "PET Weight",
                                                  value,
                                                ),
                                            decoration: InputDecoration(
                                              labelText: WasteTexts
                                                  .weightCookingOil
                                                  .tr,
                                              labelStyle: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              prefixIcon: Icon(
                                                Iconsax.user_edit,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: WasteSizes.spaceBtwSections,
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded:
                                        controller.isCookingOilExpanded.value,
                                    canTapOnHeader: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwSections),
                        const SizedBox(height: WasteSizes.spaceBtwSections),

                        // Generate Voucher Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.addUserPoints();
                              controller.clearFields();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: WasteColors.buttonPrimary,
                              side: const BorderSide(
                                color: WasteColors.buttonPrimary,
                              ),
                            ),
                            child: Text(WasteTexts.addPoint.tr),
                          ),
                        ),
                        const SizedBox(height: WasteSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(height: WasteSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          AdminAuthenticationRepository.instance.logout(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: WasteColors.buttonPrimary,
                        ),
                      ),
                      child: Text(WasteTexts.logout.tr),
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
}

                          // ExpansionPanelList
//                              Obx(() => ClipRRect(
//    borderRadius: BorderRadius.circular(15),
//   child: Container(
//     // color: Colors.white, // Background color of the entire ExpansionPanelList
//     // color: Theme.of(context).primaryColor,
//     child: ExpansionPanelList(
//       elevation: 0,
//       expandedHeaderPadding: EdgeInsets.all(0),
//       dividerColor: Colors.transparent,
//       expansionCallback: (index, isExpanded) {
//         if (index == 0) {
//           controller.isPlasticExpanded.value =
//               !controller.isPlasticExpanded.value;
//         } else if (index == 1) {
//           controller.isPaperExpanded.value =
//               !controller.isPaperExpanded.value;
//         }
//       },
//       children: [
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) {
//             return Container(
//               color: Colors.blueAccent, // Background color of the header
//               padding: EdgeInsets.all(10),
//               child: Theme(
//                 data: Theme.of(context).copyWith(cardColor: Colors.red),
//                 child: ListTile(
//                   title: Text(
//                     "Plastic",
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   leading: Icon(Icons.recycling, color: Colors.white),
//                 ),
//               ),
//             );
//           },
//           body: Container(
//             // color: Colors.blueGrey[50], // Background color of the body
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: controller.petWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("PET Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: WasteTexts.weightPET.tr,
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//                 const SizedBox(height: WasteSizes.spaceBtwSections),
//                 TextFormField(
//                   controller: controller.hdpeWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("HDPE Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: WasteTexts.weightHDPE.tr,
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//                 const SizedBox(height: WasteSizes.spaceBtwSections),
//                 TextFormField(
//                   controller: controller.ppWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("PP Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: WasteTexts.weightPP.tr,
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//               ],
//             ),
//           ),
//           isExpanded: controller.isPlasticExpanded.value,
//           canTapOnHeader: true,
//         ),
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) {
//             return Container(
//               // color: Colors.greenAccent, // Background color of the header
//               padding: EdgeInsets.all(16),
//               child: ListTile(
//                 title: Text(
//                   "Paper",
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//                 leading: Icon(Icons.description, color: Colors.white),
//               ),
//             );
//           },
//           body: Container(
//             // color: Colors.green[50], // Background color of the body
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: controller.booksWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("Books Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: "weightBooks",
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//                 const SizedBox(height: WasteSizes.spaceBtwSections),
//                 TextFormField(
//                   controller: controller.newspaperWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("Newspaper Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: "weightNewspaper",
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//                 const SizedBox(height: WasteSizes.spaceBtwSections),
//                 TextFormField(
//                   controller: controller.cardboardWeight,
//                   validator: (value) =>
//                       WasteValidator.validateDecimalPlaces("Cardboard Weight", value),
//                   decoration: const InputDecoration(
//                       labelText: "weightCardboard",
//                       prefixIcon: Icon(Iconsax.user_edit)),
//                 ),
//               ],
//             ),
//           ),
//           isExpanded: controller.isPaperExpanded.value,
//           canTapOnHeader: true,
//         ),
//       ],
//     ),
//   ),
// )),

// Obx(() => ClipRRect(
//   borderRadius: BorderRadius.circular(15),
//    child: Container(
//     margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
//     decoration: BoxDecoration(
//       color: Theme.of(context).colorScheme.surface, // Background color
//       // borderRadius: BorderRadius.circular(30), // Match the borderRadius of ClipRRect
//       border: Border.all(
//         color: Theme.of(context).colorScheme.outline, // Border color from the theme
//         width: 1, // Border width
//       ),
//     ),
//     child: Theme(
//       // data: Theme.of(context).copyWith(cardColor: WasteColors.black),
//       data: Theme.of(context).copyWith(cardColor: Theme.of(context).colorScheme.surface),
//       child: ExpansionPanelList(
//         elevation: 0,
//         expandedHeaderPadding: EdgeInsets.all(0),
//         // dividerColor: Colors.transparent,
//         dividerColor: Colors.transparent,
//         expansionCallback: (index, isExpanded) {
//           if (index == 0) {
//             controller.isPlasticExpanded.value =
//                 !controller.isPlasticExpanded.value;
//           } else if (index == 1) {
//             controller.isPaperExpanded.value =
//                 !controller.isPaperExpanded.value;
//           }
//         },
//         children: [
//           ExpansionPanel(
//             headerBuilder: (context, isExpanded) {
//               return Container(
//                 // color: Colors.blueAccent, // Background color of the header
//                 padding: EdgeInsets.all(10),
//                 child: ListTile(
//                   title: Text(
//                     "Plastic",
//                     // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   leading: Icon(Icons.recycling, color: Colors.white),
//                 ),
//               );
//             },
//             body: Container(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: controller.petWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("PET Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: WasteTexts.weightPET.tr,
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   TextFormField(
//                     controller: controller.hdpeWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("HDPE Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: WasteTexts.weightHDPE.tr,
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   TextFormField(
//                     controller: controller.ppWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("PP Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: WasteTexts.weightPP.tr,
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
                  
//                 ],
//               ),
//             ),
//             isExpanded: controller.isPlasticExpanded.value,
//             canTapOnHeader: true,
//           ),
//           ExpansionPanel(
//             headerBuilder: (context, isExpanded) {
//               return Container(
//                 // color: Colors.greenAccent, // Background color of the header
//                 padding: EdgeInsets.all(16),
//                 child: ListTile(
//                   title: Text(
//                     "Paper",
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   leading: Icon(Icons.description, color: Colors.white),
//                 ),
//               );
//             },
//             body: Container(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: controller.booksWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("Books Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: "weightBooks",
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   TextFormField(
//                     controller: controller.newspaperWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("Newspaper Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: "weightNewspaper",
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
//                   const SizedBox(height: WasteSizes.spaceBtwSections),
//                   TextFormField(
//                     controller: controller.cardboardWeight,
//                     validator: (value) =>
//                         WasteValidator.validateDecimalPlaces("Cardboard Weight", value),
//                     decoration: const InputDecoration(
//                         labelText: "weightCardboard",
//                         prefixIcon: Icon(Iconsax.user_edit)),
//                   ),
//                 ],
//               ),
//             ),
//             isExpanded: controller.isPaperExpanded.value,
//             canTapOnHeader: true,
//           ),
//         ],
//       ),
//     ),
//   ),
// )),