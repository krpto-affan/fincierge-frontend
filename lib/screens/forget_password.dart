import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // ✅ Simple email format validation
  bool _isValidEmail(String email) {
    final pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+(?:\.[a-zA-Z0-9-]+)*$";
    return RegExp(pattern).hasMatch(email);
  }

  // ✅ Main function to send reset link
  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email.")),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Check if user exists for this email
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (methods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No account found with this email."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Step 2: Email exists — send reset link
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Reset link sent to $email"),
          backgroundColor: Colors.green,
        ),
      );

      // Step 3: Go back to login after short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong.";
      if (e.code == 'invalid-email') {
        message = "Invalid email address.";
      } else if (e.code == 'too-many-requests') {
        message =
            "Too many requests. Please try again later or contact support.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 37,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // this makes sure the view scrolls when the keyboard opens
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30, // adjusts for keyboard
              top: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 7),
                const Text(
                  "Enter your email address\nto reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 75),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We'll send you a link to reset password",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3686F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.2,
                            ),
                          )
                        : const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Color(0xFF3686F6),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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
