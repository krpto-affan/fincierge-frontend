import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Image.asset(
              'assets/change_password_key.png', // Use your asset path here
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 26),
          Center(
            child: Text(
              "Change Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              "Please enter your current password\nand new password below",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Current Password
          Text(
            "Current Password",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _currentController,
            obscureText: !showCurrentPassword,
            decoration: InputDecoration(
              hintText: "Enter your current password",
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showCurrentPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => showCurrentPassword = !showCurrentPassword),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // New Password
          Text(
            "Password",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _newController,
            obscureText: !showNewPassword,
            decoration: InputDecoration(
              hintText: "Enter new password",
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showNewPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => showNewPassword = !showNewPassword),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Confirm Password
          Text(
            "Confirm Password",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _confirmController,
            obscureText: !showConfirmPassword,
            decoration: InputDecoration(
              hintText: "Confirm new password",
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => showConfirmPassword = !showConfirmPassword),
              ),
            ),
          ),
          const SizedBox(height: 34),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                // Handle save password logic here
              },
              child: Text(
                "Save Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
