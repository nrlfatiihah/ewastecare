import 'package:ewastecare/common/widget/loaders/loaders.dart';
import 'package:ewastecare/data/repositories/product/product_repository.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:ewastecare/features/store/screens/user/product_details/user_product_redeem_summary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedeemItemController extends GetxController {
  static RedeemItemController get instance => Get.find();

  GlobalKey<FormState> redeemItemFormKey = GlobalKey<FormState>();
  final productIdController = TextEditingController();
  final quantityController = TextEditingController();
  final productRepository = ProductRepository();
  final userController = Get.put(UserController());
  final productId = ''.obs;
  final quantity = 1.obs;

  @override
  void onClose() {
    productIdController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  Future<void> validateAndProceed() async {
    if (redeemItemFormKey.currentState?.validate() ?? false) {
      final validationResult = await validateRedemption();
      if (validationResult['isValid']) {
        redeemItemFormKey.currentState?.save();

        Get.to(
          () => SummaryPage(
            productImage: validationResult["productImage"],
            productId: validationResult["productId"],
            quantity: validationResult["quantity"],
            totalCost: validationResult["totalCost"],
            userWastePointBalance: validationResult["userWastePointBalance"],
            productName: validationResult["productName"],
            productPrice: validationResult["productPrice"],
            userId: validationResult["userId"],
          ),
        );
      } else {
        final errorMessage =
            validationResult['errorMessage'] ?? 'Unknown error occurred';
        showErrorMessage(errorMessage);
      }
    }
  }

  Future<Map<String, dynamic>> validateRedemption() async {
    // Get product ID and quantity from text controllers
    // final String productId = productIdController.text;
    String productId = productIdController.text;
    final int quantity = int.tryParse(quantityController.text) ?? 0;

    // Get product data from Firebase using the retrieved product ID
    final productData = await productRepository.getProductData(productId);
    if (productData.isEmpty) {
      return {'isValid': false, 'errorMessage': 'Product not found'};
    }

    final productStock = productData['Stock'] as int;
    final productPrice = productData['WastePoint'] as int;
    final productName = productData['productName'] as String;
    final productImage = productData['Image'] ?? "";
    final userWastePointBalance = await productRepository.getUserWasteBalance();
    final userId = await userController.getCurrentUserId();
    final totalCost = productPrice * quantity;

    if (quantity > productStock) {
      return {'isValid': false, 'errorMessage': 'Insufficient stock'};
    }

    if (totalCost > userWastePointBalance) {
      return {
        'isValid': false,
        'errorMessage':
            'Insufficient WastePoints balance to redeem the product',
      };
    }

    // Return validation result with validated values
    return {
      'isValid': true,
      'productId': productId,
      'quantity': quantity,
      'totalCost': totalCost,
      'userWastePointBalance': userWastePointBalance,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      "userId": userId,
    };
  }

  void showErrorMessage(String errorMessage) {
    // Show error message to the user (e.g., using a snackbar)
    WasteLoaders.errorSnackBar(title: "Error", message: errorMessage);
  }

  void clearFields() {
    productIdController.clear();
    quantityController.clear();
  }
}
