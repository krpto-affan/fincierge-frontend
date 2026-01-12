import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'profile.dart';
import 'FAQScreen.dart';
import 'Privacy Policy Screen.dart';
import 'guest_setting.dart';

class ChatDrawer extends StatefulWidget {
  final List<String> pastQueries;
  final String userName;
  final bool isGuest;

  const ChatDrawer({
    super.key,
    required this.pastQueries,
    required this.userName,
    this.isGuest = false,
  });

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  String? _userName;
  String? _email;
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _userName = data['name'] ?? user.displayName ?? 'User';
          _email = data['email'] ?? user.email ?? '';
          _photoUrl = data['profile_pic'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = user.displayName ?? 'User';
          _email = user.email ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user info: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGuest) {
      // 🟣 Guest Drawer
      return Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Image.asset('assets/New_chat.png', width: 26, height: 26),
                    const SizedBox(width: 10),
                    const Text(
                      "New Chat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _drawerItem(context, "FAQs", FAQScreen()),
                    const SizedBox(height: 20),
                    _drawerItem(context, "Privacy", PPScreen()),
                    const SizedBox(height: 20),
                    _drawerItem(context, "Settings", GuestSettingsScreen()),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Save your chat history, share chats, and personalize your experience.",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3686F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Log in or Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      );
    }

    // 🟢 Authenticated User Drawer
    return Drawer(
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ✅ User Info Header
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF3686F6)),
                    accountName: Text(
                      _userName ?? widget.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    accountEmail: Text(_email ?? ""),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : null,
                      child: _photoUrl == null
                          ? const Icon(Icons.person,
                              size: 42, color: Colors.grey)
                          : null,
                    ),
                  ),

                  // ✅ Search + New Chat
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.asset(
                          'assets/New_chat.png',
                          width: 30,
                          height: 30,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),

                  // ✅ Past Queries
                  if (widget.pastQueries.isNotEmpty)
                    Expanded(
                      child: ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Past Queries",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          ...widget.pastQueries.map(
                            (query) => ListTile(
                              title: Text(query,
                                  style: const TextStyle(fontSize: 15)),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),

                  // ✅ Profile Footer
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF3686F6),
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName ?? widget.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _email ?? '',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color: Colors.black87,
        ),
      ),
    );
  }
}
