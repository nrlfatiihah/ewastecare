// use and checked
import 'package:ewastecare/features/authentication/screens/login/login_admin/admin_login.dart';
import 'package:ewastecare/features/authentication/screens/login/login_user/login.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/signup.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),

            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: double.infinity,
                color: WasteColors.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 150,
                      image: AssetImage(
                        dark
                            ? WasteImages.lightAppLogo
                            : WasteImages.darkAppLogo,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      WasteTexts.appName,
                      style: TextStyle(
                        color: Color(0xFF388E3C),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),

          // title and subtitle
          Text(
            WasteTexts.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: WasteSizes.spaceBtwItems),

          Text(
            WasteTexts.subTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections * 2),

          // button for login for User
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const LoginScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasteColors.buttonPrimary,
                side: const BorderSide(color: WasteColors.buttonPrimary),
              ),
              child: const Text(WasteTexts.loginUser),
            ),
          ),
          const SizedBox(height: 13),

          // button for login for Admin
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const AdminLoginScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasteColors.buttonPrimary,
                side: const BorderSide(color: WasteColors.buttonPrimary),
              ),
              child: const Text(WasteTexts.loginAdmin),
            ),
          ),
          const SizedBox(height: 13),

          // button for create account
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const SignupScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: WasteColors.buttonPrimary,
                side: const BorderSide(color: WasteColors.buttonPrimary),
              ),
              child: const Text(WasteTexts.createAccount),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    final secondEndPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
