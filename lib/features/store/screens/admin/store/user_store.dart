import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/common/widget/items_cards/user_item_card_verticle.dart';
import 'package:ewastecare/common/widget/layouts/grid_layout.dart';
import 'package:ewastecare/common/widget/shimmers/vertical_product_shimmer.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/store/controllers/product_controller.dart';
import 'package:ewastecare/user_navigation_menu.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/popups/exit_ecobako_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserStoreScreen extends StatelessWidget {
  const UserStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) async {
        if (didPop) {
          // If the user tries to navigate back from the Redeem Item screen
          return;
        }
        bool shouldCancel = await DialogUtils.showExitStoreConfirmation(
          context,
        );
        if (shouldCancel) {
          // You can perform any additional actions if needed
          Get.off(UserNavigationMenu());
        }
      }),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            controller.resetProductDataFetched();
            await controller.fetchStoreProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                WastePrimaryHeaderContainer(
                  child: Column(
                    children: [
                      // appBar
                      WasteAppBar(
                        showBackArrow: true,
                        title: Text(
                          "Waste Store",
                          style: Theme.of(context).textTheme.headlineMedium!
                              .apply(color: WasteColors.white),
                        ),
                      ),
                      const SizedBox(height: WasteSizes.spaceBtwSections),
                    ],
                  ),
                ),

                //body
                Padding(
                  padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                  child: Column(
                    children: [
                      const WasteSectionHeading(
                        title: "Redeemable Items",
                        showActionButton: false,
                      ),
                      const SizedBox(height: WasteSizes.spaceBtwSections),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const WasteVerticalProductShimmer();
                        }
                        if (controller.storeProducts.isEmpty) {
                          return Center(
                            child: Text(
                              "No Data Found!",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }

                        return WasteGridLayout(
                          itemCount: controller.storeProducts.length,
                          itemBuilder: (_, index) => WasteUserItemCardVertical(
                            product: controller.storeProducts[index],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton:  UserProductDetailsActionButton(product:product),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
