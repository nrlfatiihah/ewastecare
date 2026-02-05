import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ewastecare/screens/welcome_screen.dart';
import 'package:ewastecare/widgets/onbording_page_widget.dart';
import 'package:ewastecare/constants/text_strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  // Navigate to Welcome Screen after skipping or finishing onboarding
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF66BB6A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: const [
            OnboardPage(
              image: 'assets/images/onboard1.png',
              title: WasteText.onboardTitle1,
              description: WasteText.onboardDesc1,
            ),
            OnboardPage(
              image: 'assets/images/onboard2.png',
              title: WasteText.onboardTitle2,
              description: WasteText.onboardDesc2,
            ),
            OnboardPage(
              image: 'assets/images/onboard3.png',
              title: WasteText.onboardTitle3,
              description: WasteText.onboardDesc3,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isLastPage)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  WasteText.back,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            else
              GestureDetector(
                onTap: _completeOnboarding,
                child: const Text(
                  WasteText.skip,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),

            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: const WormEffect(
                  activeDotColor: primaryGreen,
                  dotColor: Color(0xFFE8F5E9),
                  spacing: 6.0,
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                ),
              ),
            ),

            if (isLastPage)
              Container(
                width: 140,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    WasteText.getStarted,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
