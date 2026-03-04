import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/features/waste_point/controller/material_controller.dart';
import 'package:ewastecare/features/waste_point/model/material_model.dart';
import 'package:ewastecare/features/waste_point/widget/test_add_rate_action_button.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecycleRate extends StatelessWidget {
  const RecycleRate({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaterialController());

    return Scaffold(
      appBar: WasteAppBar(
        showBackArrow: true,
        title: Text(
          "Recycle Rate",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched();
          await controller.fetchRateMaterials();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(WasteSizes.defaultSpace),
            child: Obx(() {
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
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plastic Materials Panel
                      _buildExpansionPanel(
                        context: context,
                        title: "Plastic Materials",
                        icon: Icons.recycling,
                        isExpanded: controller.isPlasticExpanded.value,
                        onExpansionChanged: (isExpanded) =>
                            controller.isPlasticExpanded.value = isExpanded,
                        materials: controller.plasticMaterials,
                        controller: controller,
                      ),

                      // Paper Materials Panel
                      _buildExpansionPanel(
                        context: context,
                        title: "Paper Materials",
                        icon: Icons.description,
                        isExpanded: controller.isPaperExpanded.value,
                        onExpansionChanged: (isExpanded) =>
                            controller.isPaperExpanded.value = isExpanded,
                        materials: controller.paperMaterials,
                        controller: controller,
                      ),

                      // Can Materials Panel
                      _buildExpansionPanel(
                        context: context,
                        title: "Can Materials",
                        icon: Icons.directions_car,
                        isExpanded: controller.isCanExpanded.value,
                        onExpansionChanged: (isExpanded) =>
                            controller.isCanExpanded.value = isExpanded,
                        materials: controller.canMaterials,
                        controller: controller,
                      ),

                      // Used Oil Materials Panel
                      _buildExpansionPanel(
                        context: context,
                        title: "Used Oil Materials",
                        icon: Icons.local_gas_station,
                        isExpanded: controller.isCookingOilExpanded.value,
                        onExpansionChanged: (isExpanded) =>
                            controller.isCookingOilExpanded.value = isExpanded,
                        materials: controller.oilMaterials,
                        controller: controller,
                      ),

                      _buildExpansionPanel(
                        context: context,
                        title: "Others",
                        icon: Icons.more,
                        isExpanded: controller.isOthersExpanded.value,
                        onExpansionChanged: (isExpanded) =>
                            controller.isOthersExpanded.value = isExpanded,
                        materials: controller.othersMaterials,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: const TestRateActionbutton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildExpansionPanel({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isExpanded,
    required void Function(bool) onExpansionChanged,
    required List<MaterialModel> materials,
    required MaterialController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        expansionCallback: (index, isExpanded) {
          onExpansionChanged(isExpanded);
        },
        children: [
          ExpansionPanel(
            backgroundColor: Theme.of(context).cardColor,
            headerBuilder: (context, isExpanded) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: materials.map((material) {
                  final TextEditingController textController =
                      TextEditingController(
                        text: material.value.toStringAsFixed(2),
                      );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                material.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "RM ${textController.text}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      'Edit ${material.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: TextField(
                                      controller: textController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        labelText: 'Enter new value',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actionsPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          final newValue =
                                              double.tryParse(
                                                textController.text,
                                              ) ??
                                              material.value;
                                          material.value = newValue;
                                          controller.updateMaterial(material);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            isExpanded: isExpanded,
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }
}
