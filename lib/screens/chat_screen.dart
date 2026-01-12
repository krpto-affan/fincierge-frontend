import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'create_account.dart';
import 'chat_drawer.dart';
import 'profile.dart';
import 'package:fincierge/services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final bool isGuest;
  const ChatScreen({super.key, this.isGuest = false});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool isTyping = false;
  String? _userName; // ✅ dynamically fetched user name

  @override
  void initState() {
    super.initState();
    debugPrint("✅ ChatScreen initState triggered");
    _verifyUserWithBackend();
    _fetchUserName(); // ✅ Fetch user name from Firestore
  }

  /// ✅ Verify Firebase token with backend
  Future<void> _verifyUserWithBackend() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final idToken = await user.getIdToken(true);
      debugPrint("🪪 Firebase ID Token: $idToken");

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/auth/verify"),
        headers: {
          "Authorization": "Bearer $idToken",
          "Content-Type": "application/json",
        },
        body: "{}",
      );

      debugPrint("📡 Backend response status: ${response.statusCode}");
      debugPrint("📡 Backend response body: ${response.body}");
    } catch (e) {
      debugPrint("Verification failed: $e");
    }
  }

  /// ✅ Fetch user's display name from Firestore
  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        setState(() {
          _userName = doc.data()?['name'] ?? user.displayName ?? "User";
        });
        debugPrint("👤 User name loaded: $_userName");
      } else {
        setState(() {
          _userName = user.displayName ?? "User";
        });
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
      setState(() {
        _userName = "User";
      });
    }
  }

  /// 🧠 Streaming chat message logic
  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': text});
      messages.add({'role': 'bot', 'content': ''});
      isTyping = true;
    });

    final userInput = text;
    _controller.clear();
    final botIndex = messages.length - 1;

    await ApiService().streamChatResponse(
      query: userInput,
      onChunk: (chunk) async {
        setState(() {
          messages[botIndex]['content'] += chunk;
        });
        await Future.delayed(Duration(milliseconds: 10)); // 👈 slowed down slightly
      },
      onComplete: () {
        setState(() => isTyping = false);
      },
      onError: (error) {
        debugPrint("Stream error: $error");
        setState(() {
          messages[botIndex]['content'] =
              "⚠️ Sorry, something went wrong. Please try again.";
          isTyping = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ✅ Chat Drawer with dynamic user name
      drawer: _userName == null
          ? const Drawer(
              child: Center(child: CircularProgressIndicator()),
            )
          : ChatDrawer(
              pastQueries: [],
              userName: _userName!,
              isGuest: widget.isGuest,
            ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/Mascot.png', width: 45, height: 45),
                      const SizedBox(width: 0),
                      const Text(
                        "FinBot",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 33,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                if (!widget.isGuest)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        ).then((_) => _fetchUserName()); // 🔁 Refresh name when returning
                      },
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                if (widget.isGuest)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccountScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Divider(
              height: 1,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    child: Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.85,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF3686F6)
                                : Colors.grey.shade300,
                            borderRadius: isUser
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomLeft: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  ),
                          ),
                          child: isUser
                              ? Text(
                                  msg['content'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              : MarkdownBody(
                                  data: msg['content'] ?? '',
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet.fromTheme(
                                    Theme.of(context),
                                  ).copyWith(
                                    p: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isTyping)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("FinBot is typing...",
                    style: TextStyle(color: Colors.grey)),
              ),
            Container(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          if (!isDarkMode)
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                        ],
                        border: isDarkMode
                            ? Border.all(color: Colors.grey[700]!, width: 1)
                            : null,
                      ),
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ask Anything...",
                          hintStyle: TextStyle(
                            color:
                                isDarkMode ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: isTyping
                          ? null
                          : () {
                              final text = _controller.text.trim();
                              if (text.isNotEmpty) {
                                _sendMessage(text);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
