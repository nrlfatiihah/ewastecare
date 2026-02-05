import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  final String image, title, description;
  final Color titleColor;
  final Color descriptionColor;

  const OnboardPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.titleColor = Colors.black,
    this.descriptionColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 100, left: 40, right: 40, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.35,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: descriptionColor,
            ),
          ),
        ],
      ),
    );
  }
}
