import 'package:flutter/material.dart';
import 'login.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController  = TextEditingController();

  bool agreedToTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm  = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final pattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    return RegExp(pattern).hasMatch(email);
  }

    Future<void> _createAccount() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (!_formKey.currentState!.validate()) return;

    if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Privacy Policy.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if email already registered
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account with this email already exists.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create user in Firebase Auth
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();

        // ✅ Store user info in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': username,
          'email': email,
          'phone': '',
          'dob': '',
          'gender': 'Male',
          'profile_pic': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Account created successfully for $username!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to ChatScreen
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to create account.';
      if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter a username';
    if (v.trim().length < 3) return 'Username should be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    if (!_isValidEmail(v.trim())) return 'Please enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter a password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    // add further checks here if required (uppercase, digit, etc.)
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 28),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Create Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create your account to unlock instant, secure, and personalized banking guidance',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 24),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      validator: _validateUsername,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Confirm Password',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmController,
                      validator: _validateConfirm,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Checkbox(
                          value: agreedToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              agreedToTerms = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms & Conditions and Privacy Policy',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (!_isLoading && agreedToTerms)
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  await _createAccount();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              agreedToTerms ? Colors.blue : Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: agreedToTerms ? Colors.white : Colors.grey,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
