import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_edit.dart';
import 'theme_screen.dart';
import 'language_screen.dart';
import 'FAQScreen.dart';
import 'login.dart';
import 'Privacy Policy Screen.dart';
import 'setting_non_guest.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? profilePic;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          name = data['name'] ?? 'User';
          email = data['email'] ?? 'No email';
          profilePic = data['profile_pic'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('⚠️ Error fetching user data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                      if (updated == true) fetchUserData();
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: profilePic != null && profilePic!.isNotEmpty
                              ? NetworkImage(profilePic!)
                              : null,
                              // Use the child property for a placeholder icon when there's no image
                              child: profilePic == null || profilePic!.isEmpty
                                  ? const Icon(
                                      Icons.person, // The blank profile icon
                                      size: 70, // Make the icon large enough to fill the circle
                                      color: Colors.white,
                                    )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name ?? 'User Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email ?? 'user@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileEditScreen()),
                        );
                        if (updated == true) fetchUserData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildMenuItem(context, Icons.brightness_4, "Theme"),
                  _buildMenuItem(context, Icons.translate, "Language"),
                  _buildMenuItem(context, Icons.chat_bubble_outline, "FAQs"),
                  _buildMenuItem(context, Icons.settings_outlined, "Settings"),
                  _buildMenuItem(context, Icons.privacy_tip_outlined, "Privacy Policy"),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: Icon(
                        Icons.logout,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                      label: Text(
                        "Logout",
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black87),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        onTap: () {
          if (title == "Theme") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ThemeScreen()));
          } else if (title == "Language") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LanguageScreen()));
          } else if (title == "FAQs") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const FAQScreen()));
          } else if (title == "Settings") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()));
          } else if (title == "Privacy Policy") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const PPScreen()));
          }
        },
      ),
    );
  }
}
