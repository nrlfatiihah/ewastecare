import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ewastecare/screens/onboarding_screen.dart';
import 'package:ewastecare/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnbordingStatusAndNavigate();
  }

  Future<void> _checkOnbordingStatusAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    await Future.delayed(const Duration(seconds: 2)); // Simulate a splash delay

    if (context.mounted) {
      if (seenOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color splashBackgroundColor = Color(0xFF9CCC65);

    return Scaffold(
      backgroundColor: splashBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ewastecare_logo.png',
              width: 500,
              height: 500,
            ),
            const SizedBox(height: 20),
            const Text(
              'eWasteCare',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
