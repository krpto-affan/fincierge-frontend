import 'package:flutter/material.dart';
import 'nextscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/3.png', width: 175, height: 175),
              const SizedBox(height: 5),
              // App Name
              const Text(
                'FinCierge',
                style: TextStyle(
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              // Subtitle
              const Text(
                'Your Smart Banking\nAssistant',
                style: TextStyle(fontSize: 27, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 120),
              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NextScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3686F6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
