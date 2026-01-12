import 'package:flutter/material.dart';
import 'create_account.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sign in to continue where you left off and get real-time help with your banking needs',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black38, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      debugPrint('login: continue button pressed');
                      try {
                        debugPrint('login: attempting Firebase signIn');
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                        debugPrint(
                          'login: signIn success, uid=${credential.user?.uid}',
                        );

                        // ✅ Get Firebase ID Token
                        final idToken = await credential.user?.getIdToken();

                        // ✅ For now just print it (later we'll call backend)
                        debugPrint('ID TOKEN: $idToken');

                        // ✅ Navigate forward
                        // If successful → navigate to ChatScreen
                        debugPrint('login: navigating to ChatScreen');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                        debugPrint('login: navigation called');
                      } on FirebaseAuthException catch (e) {
                        debugPrint('login: signIn exception: ${e.message}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message ?? 'Login failed')),
                        );
                      } catch (e) {
                        debugPrint('login: unexpected error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty
                          ? Colors.blue
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17,
                        color:
                            _emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Image.asset('assets/google_logo.jpeg', height: 22),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Image.asset('assets/facebook_logo.jpeg', height: 22),
                    label: const Text(
                      'Login with Facebook',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Haven't registered yet? ",
                      style: TextStyle(color: Colors.black38),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
