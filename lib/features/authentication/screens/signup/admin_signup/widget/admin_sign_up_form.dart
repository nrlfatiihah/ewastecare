// import 'package:ewastecare/features/authentication/controllers/signup/signup_controller.dart';
// import 'package:ewastecare/utils/constants/colors.dart';
// import 'package:ewastecare/utils/constants/sizes.dart';
// import 'package:ewastecare/utils/constants/texts.dart';
// import 'package:ewastecare/utils/validators/validation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class WasteAdminSignUpForm extends StatelessWidget {
//   const WasteAdminSignUpForm({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.put(AdminSignupController());
//     final controller = Get.put(SignupController());
//     return Form(
//         // key: controller.adminSignupFormKey,
//         key: controller.signupFormKey,
//         child: Column(
//           children: [      // Username
//             TextFormField(
//               validator: (value) =>
//                   WasteValidator.validateEmptyText("Username", value),
//               controller: controller.username,
//               expands: false,
//               decoration: const InputDecoration(
//                   labelText: WasteTexts.username.tr,
//                   prefixIcon: Icon(Iconsax.user_edit)),
//             ),
//             const SizedBox(height: WasteSizes.spaceBtwInputFields),
//             // Email
//             TextFormField(
//               controller: controller.email,
//               validator: (value) => WasteValidator.validateEmail(value),
//               expands: false,
//               decoration: const InputDecoration(
//                   labelText: WasteTexts.email.tr, prefixIcon: Icon(Iconsax.direct)),
//             ),
//             const SizedBox(height: WasteSizes.spaceBtwInputFields),
//             //Password
//             Obx(
//               () => TextFormField(
//                 controller: controller.password,
//                 validator: (value) => WasteValidator.validatePassword(value),
//                 obscureText: controller.hidePassword.value,
//                 decoration: InputDecoration(
//                   labelText: WasteTexts.password.tr,
//                   prefixIcon: const Icon(Iconsax.password_check),
//                   suffixIcon: IconButton(
//                       onPressed: () => controller.hidePassword.value =
//                           !controller.hidePassword.value,
//                       icon: Icon(controller.hidePassword.value
//                           ? Iconsax.eye_slash
//                           : Iconsax.eye)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: WasteSizes.spaceBtwInputFields),

//             const SizedBox(height: WasteSizes.spaceBtwSections),

//             // Sign up Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => controller.adminSignup(),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: WasteColors.buttonPrimary,
//                     side: const BorderSide(color: WasteColors.buttonPrimary)),
//                 child: Text(WasteTexts.createAccount.tr),
//               ),
//             ),
//             const SizedBox(height: WasteSizes.spaceBtwSections),
//           ],
//         ));
//   }
// }
