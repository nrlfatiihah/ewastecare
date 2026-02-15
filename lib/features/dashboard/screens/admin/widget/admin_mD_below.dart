import 'package:ewastecare/features/dashboard/screens/admin/admin_new_dashboard.dart';
import 'package:ewastecare/features/ecobako_point/model/material_model.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedWeightsPanel extends StatelessWidget {
  // Ensure to properly initialize the controller.
  final controller = Get.put(AdminDashboardService());
  final Map<String, Map<String, double>> detailedWeights;

  DetailedWeightsPanel({super.key, required this.detailedWeights});

  @override
  Widget build(BuildContext context) {
    final dark = WasteHelperFunctions.isDarkMode(context);

    return Padding(
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
                color: Theme.of(context)
                    .colorScheme
                    .outline, // Change this to your desired border color
                width: 2, // Adjust the border width as needed
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
                // Others Panel
                _buildExpansionPanel(
                  context: context,
                  title: "Others",
                  icon: Icons.local_gas_station,
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
    );
  }

  Widget _buildExpansionPanel({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isExpanded,
    required void Function(bool) onExpansionChanged,
    required List<MaterialModel> materials,
    required AdminDashboardService controller,
  }) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.all(0),
      dividerColor: Theme.of(context).dividerColor.withOpacity(0.6),
      expansionCallback: (index, isExpanded) {
        onExpansionChanged(isExpanded);
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return Container(
              padding: EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                leading: Icon(icon, color: Theme.of(context).iconTheme.color),
              ),
            );
          },
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: materials.map((material) {
                final TextEditingController textController =
                    TextEditingController(
                      text: material.value.toStringAsFixed(2),
                    );

                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(material.name),
                        subtitle: Text('Value: RM ${textController.text}'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          isExpanded: isExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}
