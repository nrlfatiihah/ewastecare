import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF9CCC65);

    return Scaffold(
      appBar: AppBar(
        title: const Text("e-Waste Care"),
        backgroundColor: primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAllNamed(
              '/login',
            ), // Returns to login and clears history
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 100, color: primaryGreen),
            const SizedBox(height: 20),
            const Text(
              "Welcome, Eco-Warrior!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Thank you for helping the environment. Start recycling your e-waste today.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: const Text(
                "Schedule a Pickup",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
