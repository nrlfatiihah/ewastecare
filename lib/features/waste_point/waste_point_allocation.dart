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
              // Header with gradient and title
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
              // Main content padding
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WasteSizes.defaultSpace,
                  vertical: WasteSizes.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      WasteTexts.pointTitle,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      key: controller.addPointFormKey,
                      child: Column(
                        children: [
                          // User ID + QR Scanner
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
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
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Iconsax.user_edit),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () async {
                                      final scannedData = await Get.to(
                                        () => const QRScannerScreen(),
                                      );
                                      if (scannedData != null) {
                                        controller.userID.text = scannedData;
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: WasteColors.buttonPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Iconsax.scan_barcode,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Materials Panel
                          Obx(() {
                            return Column(
                              children: [
                                _buildMaterialCard(
                                  context,
                                  'Plastic Materials',
                                  Icons.recycling,
                                  controller.plasticMaterials,
                                  controller.isPlasticExpanded,
                                ),
                                _buildMaterialCard(
                                  context,
                                  'Paper Materials',
                                  Icons.article,
                                  controller.paperMaterials,
                                  controller.isPaperExpanded,
                                ),
                                _buildMaterialCard(
                                  context,
                                  'Can Materials',
                                  Icons.coffee,
                                  controller.canMaterials,
                                  controller.isCanExpanded,
                                ),
                                _buildMaterialCard(
                                  context,
                                  'Used Oil Materials',
                                  Icons.oil_barrel,
                                  controller.oilMaterials,
                                  controller.isCookingOilExpanded,
                                ),
                                _buildMaterialCard(
                                  context,
                                  'Others Materials',
                                  Icons.other_houses,
                                  controller.othersMaterials,
                                  controller.isOthersExpanded,
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 25),

                          // Add Point Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller.addUserPoints();
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: WasteColors.buttonPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: BorderSide.none,
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                  ),
                              child: const Text(
                                WasteTexts.addPoint,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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

  Widget _buildMaterialCard(
    BuildContext context,
    String title,
    IconData icon,
    List<MaterialModel> materials,
    RxBool isExpanded,
  ) {
    final controller = Get.find<AllocateWastePointController>();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        initiallyExpanded: isExpanded.value,
        onExpansionChanged: (val) => isExpanded.value = val,
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        // ignore: sort_child_properties_last
        children: materials.map((material) {
          final weightController =
              controller.weightControllers[material.name] ??
              TextEditingController();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: '${material.name} weight (Kg)',
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  WasteValidator.validateDoubleWithTwoDecimalPlaces(
                    "Weight",
                    value,
                  ),
            ),
          );
        }).toList(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        childrenPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
