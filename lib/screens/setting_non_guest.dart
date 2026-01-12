import 'package:flutter/material.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = false;
  bool emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Section
          Card(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      'Push Notifications',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    value: pushNotifications,
                    onChanged: (val) {
                      setState(() {
                        pushNotifications = val;
                      });
                    },
                    activeColor: Colors.white, // Blue thumb when ON
                    activeTrackColor: Colors.blue, // Blue track when ON
                    inactiveThumbColor: isDarkMode
                        ? Colors.grey[700]
                        : Colors.grey,
                    inactiveTrackColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    secondary: Icon(
                      Icons.notifications,
                      color: isDarkMode ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  SwitchListTile(
                    title: Text(
                      'Email Notifications',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    value: emailNotifications,
                    onChanged: (val) {
                      setState(() {
                        emailNotifications = val;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue,
                    inactiveThumbColor: isDarkMode
                        ? Colors.grey[700]
                        : Colors.grey,
                    inactiveTrackColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    secondary: Icon(
                      Icons.email,
                      color: isDarkMode ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Security Section
          Card(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.lock_outline,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: isDarkMode ? Colors.white54 : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                    // Navigate to change password screen
                  },
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                  title: Text(
                    'Clear Cache',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Text(
                    '487 MB',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                  ),
                  onTap: () {
                    // Implement cache clearing
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // About Section
          Card(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                  title: Text(
                    'App Version',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Text(
                    '0.0.1',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                ),
                ListTile(
                  leading: Icon(
                    Icons.star_border,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                  title: Text(
                    'Rate Our App',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    // Link to app store or rating dialog
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
