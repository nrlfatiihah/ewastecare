// use and checked
import 'package:ewastecare/features/authentication/screens/login/login_user/login.dart';
import 'package:ewastecare/features/authentication/screens/signup/user_signup/signup.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/constants/image_strings.dart';
import 'package:ewastecare/utils/constants/sizes.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ewastecare/translations/app_translations.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with gradient background
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      WasteColors.primary,
                      WasteColors.primary.withOpacity(0.85),
                    ],
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    // Language selector at top-right
                    Positioned(
                      right: 12,
                      top: 12,
                      child: PopupMenuButton<String>(
                        tooltip: 'language'.tr,
                        onSelected: (value) {
                          if (value == 'en') {
                            AppTranslations.changeLocale(
                              const Locale('en', 'US'),
                            );
                          } else if (value == 'ms') {
                            AppTranslations.changeLocale(
                              const Locale('ms', 'MY'),
                            );
                          }
                        },
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'en',
                            child: Text('english'.tr),
                          ),
                          PopupMenuItem<String>(
                            value: 'ms',
                            child: Text('bahasa_malaysia'.tr),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'language'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Centered header content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with shadow effect
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image(
                              height: 140,
                              image: AssetImage(
                                dark
                                    ? WasteImages.lightAppLogo
                                    : WasteImages.darkAppLogo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // App name with enhanced styling
                          Text(
                            WasteTexts.appName.tr,
                            style: const TextStyle(
                              color: Color(0xFF388E3C),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Decorative line
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF388E3C).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections),

          // Title and subtitle section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  WasteTexts.title.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: dark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  WasteTexts.subTitle.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: dark ? Colors.grey[300] : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections * 1.5),

          // Single Login Button with Create Account below
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildGetStartedButton(context),
                const SizedBox(height: 16),
                _buildCreateAccountButton(context),
              ],
            ),
          ),
          const SizedBox(height: WasteSizes.spaceBtwSections),
        ],
      ),
    );
  }

  // Build the main "Login" button
  Widget _buildGetStartedButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: WasteColors.buttonPrimary.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.to(() => const LoginScreen()),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  WasteColors.buttonPrimary,
                  WasteColors.buttonPrimary.withOpacity(0.85),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.user, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  WasteTexts.signIn.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the "Create Account" button
  Widget _buildCreateAccountButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: WasteColors.buttonPrimary.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => Get.to(() => const SignupScreen()),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: WasteColors.buttonPrimary.withOpacity(0.4),
                width: 2,
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.user_add,
                  color: WasteColors.buttonPrimary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  WasteTexts.createAccount.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: WasteColors.buttonPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
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
