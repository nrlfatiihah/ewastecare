import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WasteLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            color: WasteHelperFunctions.isDarkMode(Get.context!)
                ? WasteColors.darkGrey.withOpacity(0.95)
                : WasteColors.grey.withOpacity(0.95),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.notification, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = "", duration = 3}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      backgroundColor: WasteColors.primary,
      colorText: Colors.white,
      icon: const Icon(Iconsax.tick_circle, color: WasteColors.white),
      shouldIconPulse: true,
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: WasteColors.primary.withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static warningSnackBar({required title, message = ""}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      icon: const Icon(Iconsax.warning_2, color: WasteColors.white),
      shouldIconPulse: true,
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.4),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static errorSnackBar({required title, message = ""}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Iconsax.close_circle, color: WasteColors.white),
      shouldIconPulse: true,
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.red.withOpacity(0.35),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static cannotEdit({required title, message = ""}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      icon: const Icon(Iconsax.warning_2, color: WasteColors.white),
      shouldIconPulse: true,
      isDismissible: true,
    );
  }
}
