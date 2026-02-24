import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/features/waste_point/controller/waste_point_controller.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/features/waste_point/widget/eco_point_qr_scan.dart';
import 'package:ewastecare/features/home/screens/admin/widgets/drawer_admin.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PointAllocationScreen extends StatelessWidget {
  const PointAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllocateWastePointController());
    return Scaffold(
      endDrawer: AdminEndDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchMaterialsAllocateScreen();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    WasteAppBar(
                      title: Text(
                        WasteTexts.allocationPage,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .apply(color: WasteColors.white),
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
                                    width:
                                        2, // Adjust the border width as needed
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
                                  await controller.addUserPoints();
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
      ),
    );
  }

  ExpansionPanel _buildMaterialPanel(
    BuildContext context,
    String title,
    IconData icon,
    List<MaterialModel> materials,
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
                Get.find<AllocateWastePointController>()
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
                // validator: (value) {
                //   final weight = double.tryParse(value ?? '');
                //   if (weight == null || weight < 0) {
                //     return 'Please enter a valid weight';
                //   }
                //   return null;
                // },
                // validator: WasteValidator.validateDoubleWithTwoDecimalPlaces,
                validator: (value) =>
                    WasteValidator.validateDoubleWithTwoDecimalPlaces(
                      "Weight",
                      value,
                    ),
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
