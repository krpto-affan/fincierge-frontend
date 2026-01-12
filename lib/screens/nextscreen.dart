import 'package:flutter/material.dart';
import 'login.dart';
import 'create_account.dart';
import 'chat_screen.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo and AppName centered
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/3.png', width: 32, height: 32),
                  const SizedBox(width: 0),
                  const Text(
                    'FinCierge',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Headline and tagline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 65,
                        height: 1.15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Secure\nAccess to\nYour\n',
                        ), // simple text
                        TextSpan(
                          text: 'Banking\nAssistant', // bolded part
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login to get personalized support and accurate information, anytime you need it.',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Buttons and guest link section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(isGuest: true),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Just Exploring? ',
                          style: TextStyle(color: Colors.black38, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Continue as Guest',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
