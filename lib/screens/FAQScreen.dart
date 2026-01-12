import 'package:flutter/material.dart';
 
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Maintain the expanded state for each question
  final Map<String, bool> _expandedMap = {};

  final List<Map<String, dynamic>> faqSections = [
    {
      'title': 'App Account FAQs',
      'data': [
        {
          'q': 'How do I create an account in the app?',
          'a':
              'Open the app, tap on “Sign Up,” and enter your mobile number, email, and a password. You may also verify your identity by entering a one-time password sent to your phone or email.',
        },
        {
          'q': 'What should I do if I forget my app password?',
          'a':
              'Tap “Forgot Password” on the login screen, enter your registered email or phone number, and follow instructions to reset your password securely.',
        },
        {
          'q': 'Can I log in with Google or other single sign-on methods?',
          'a':
              'Yes, select “Login with Google” (or other available options) on the login page for a quick and secure sign-in.',
        },
        {
          'q': 'How do I update my mobile number or email in the app?',
          'a':
              'Go to Profile > Settings, then choose “Update Contact Info.” Follow app prompts to change your details.',
        },
        {
          'q': 'Is my app account linked with my main bank account?',
          'a':
              'Your app account serves as your profile for using chatbot features. Banking queries are for informational purposes only and do not require linking or verification through your bank’s secure system.',
        },
      ],
    },
    {
      'title': 'Technical Issues FAQs',
      'data': [
        {
          'q': 'The app is not loading or crashes. What should I do?',
          'a':
              'Restart your device and check your internet connection. If the app still crashes, update it to the latest version or reinstall from the app store.',
        },
        {
          'q': 'Why can’t I log in to the app?',
          'a':
              'Make sure you’re using the correct login credentials. If you’ve forgotten your password, use the “Forgot Password” feature. For further help, contact support.',
        },
        {
          'q': 'How do I reset my password or recover my account?',
          'a':
              'Use the “Forgot Password” link on the login page and follow the recovery instructions sent to your registered email or phone.',
        },
        {
          'q': 'How do I update the app to the latest version?',
          'a':
              'Go to the Google Play Store or Apple App Store and tap “Update” next to your banking app.',
        },
        {
          'q': 'Why is the app showing an error when I try to ask a question?',
          'a':
              'Check your internet connection first. If the problem continues, restart the app or contact support for assistance.',
        },
      ],
    },
    {
      'title': 'Security FAQs',
      'data': [
        {
          'q': 'Is my data secure when using the app?',
          'a':
              'Yes, all your data is encrypted and stored securely according to banking standards. The app uses strong authentication to protect your account.',
        },
        {
          'q': 'How can I enable two-factor authentication for my app account?',
          'a':
              'Go to Profile > Security Settings in the app and follow prompts to enable two-factor authentication, usually by linking your phone or email.',
        },
        {
          'q': 'What should I do if my device is lost or stolen?',
          'a':
              'Contact your bank and app support immediately to block access to your account and reset your password from another trusted device.',
        },
        {
          'q': 'Does the app store any sensitive account information locally?',
          'a':
              'No, sensitive information is stored securely on encrypted servers, not directly on your device.',
        },
      ],
    },
    {
      'title': 'App Settings & Features FAQs',
      'data': [
        {
          'q': 'How do I change the app theme or appearance?',
          'a':
              'Go to Profile > Settings, find the “Theme” option, and select your preference (Light or Dark mode).',
        },
        {
          'q': 'How can I log out of the app?',
          'a':
              'Tap the Profile or Menu icon and select “Logout” from the options.',
        },
        {
          'q': 'Where can I view my previous chat history with the bot?',
          'a':
              'Open the chat screen and tap “History” to see all your past queries and answers.',
        },
        {
          'q': 'How do I contact support directly through the app?',
          'a':
              'Use the “Contact Support” button found in the menu or help section for assistance.',
        },
        {
          'q': 'Can I set up notifications or alerts within the app?',
          'a':
              'Go to Settings > Notifications to enable or customize alerts for account activity and important responses.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQs',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    setState(() => _searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: faqSections.map((section) {
                final List sectionData = section['data']
                    .where(
                      (item) =>
                          _searchQuery.isEmpty ||
                          item['q'].toLowerCase().contains(_searchQuery) ||
                          item['a'].toLowerCase().contains(_searchQuery),
                    )
                    .toList();

                if (sectionData.isEmpty) return SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Material(
                    elevation: isDarkMode ? 0 : 2,
                    borderRadius: BorderRadius.circular(18),
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          ...sectionData.map((item) {
                            final isExpanded = _expandedMap[item['q']] ?? false;
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor:
                                    Colors.transparent, // No inner divider
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                collapsedIconColor: Colors.blue,
                                iconColor: Colors.blue,
                                maintainState: true,
                                initiallyExpanded: isExpanded,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _expandedMap[item['q']] = expanded;
                                  });
                                },
                                title: Text(
                                  item['q'],
                                  style: TextStyle(
                                    color: Color(0xFF3686F6),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.fromLTRB(
                                      24,
                                      12,
                                      24,
                                      16,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.grey[800]
                                          : Colors
                                                .grey[200], // grey for light mode
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item['a'],
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Text.rich(
              TextSpan(
                text: "Still need help? ",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        // Implement contact support logic
                      },
                      child: Text(
                        "Contact Support",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
