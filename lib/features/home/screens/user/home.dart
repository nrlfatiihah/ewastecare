import 'package:ewastecare/common/widget/custom_shape/containers/primary_header_container.dart';
import 'package:ewastecare/common/widget/custom_shape/containers/serach_container.dart';
import 'package:ewastecare/common/widget/texts/section_heading.dart';
import 'package:ewastecare/features/home/screens/user/widgets/home_appbar.dart';
import 'package:ewastecare/features/home/screens/user/widgets/home_transaction_history.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/features/transaction/screens/transaction_history.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.resetDataFetched(); // Reset dataFetched flag
          await controller.fetchUserRecord();
          await controller.fetchTransactions(); // Fetch user record again
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const WastePrimaryHeaderContainer(
                child: Column(
                  children: [
                    // Appbar
                    WasteHomeAppBar(),
                    SizedBox(height: WasteSizes.spaceBtwSections),

                    // Waste Point
                    WastePointContainer(),
                    SizedBox(height: WasteSizes.spaceBtwSections * 2),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(WasteSizes.defaultSpace),
                child: Column(
                  children: [
                    // Waste point section
                    // const WasteSectionHeading(
                    //   title: "WastePoint Section",
                    //   showActionButton: false,
                    // ),
                    // const SizedBox(height: WasteSizes.spaceBtwItems / 1.5),

                    // const WastePointSection(),

                    // const SizedBox(height: WasteSizes.spaceBtwSections),
                    WasteSectionHeading(
                      title: WasteTexts.transactionHistory.tr,
                      onPressed: () {
                        Get.to(() => const TransactionHistoryScreen());
                      },
                      icon: Iconsax.maximize_3,
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwItems / 1.5),

                    // Waste Transaction History
                    UserHomeTransactionHistory(
                      transactions: controller.transactions,
                    ),
                    const SizedBox(height: WasteSizes.spaceBtwItems / 1.5),
                    const Divider(),
                    Center(
                      child: Text(
                        WasteTexts.showingLatestTransactions.tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
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
    // );
  }
}
