import 'package:flutter/material.dart';

class PPScreen extends StatefulWidget {
  const PPScreen({super.key});

  @override
  State<PPScreen> createState() => _PPScreenState();
}

class _PPScreenState extends State<PPScreen> {
  // Maintain the expanded state for each question
  final Map<String, bool> _expandedMap = {};

  final List<Map<String, dynamic>> ppSections = [
    {
      'title': 'Privacy Policy',
      'data': [
        {
          'q': 'Privacy Policy',
          'a': '''Last updated: October 27, 2025

This Privacy Policy describes how your information is collected, used, and protected when you use our GENAI Banking Chatbot App (“the App”).

1. Information We Collect
Personal Information: When you create an account or interact with the chatbot, we may collect your name, email address, bank account details, and phone number only if you provide them.

Usage Data: We collect information about your device type, operating system, and usage behavior (e.g., questions asked, features used).

App Permissions: The app may request access to the internet, notifications, and secure storage for proper functionality.

2. How We Use Information
To provide accurate answers to your banking queries.

To improve and personalize user experience.

To maintain security and protect users against fraudulent activity.

For research and analytics to make the app better.

3. Data Security
We use industry-standard encryption and secure authentication to protect your personal information. Data stored on our servers is accessible only to authorized personnel.

4. Sharing of Information
We do not sell, rent, or share your personal information with third parties except:

As required by law, regulation, or court order.

To improve features using anonymized/question data only.

5. User Rights
You may request to access, update, or delete your personal data by contacting support at [support-email@example.com]. You can also delete your app account from the Profile > Settings menu.

6. Third Party Services
This app may use APIs or third-party services (for banking info retrieval or analytics). These providers have their own privacy policies, and we recommend reviewing them separately.

7. Children’s Privacy
This app is intended for users aged 18 and above. We do not knowingly collect information from children.

8. Changes to Policy
We may update this policy and will notify users via an app update or notification.

Contact Us:
If you have questions about this policy or your data, please contact us at [support-email@example.com].'''

        },
      ],
    },
    {
      'title': 'Terms of Service',
      'data': [
        {
          'q': 'Terms of Service',
          'a':
              '''Last updated: October 27, 2025

Welcome to the GENAI Banking Chatbot App (“the App”). By using this app, you agree to these Terms of Service. Please read them carefully.

1. Acceptance of Terms
By using the App, you acknowledge and agree to these Terms. If you do not agree, do not use the App.

2. Use of the App
You must be at least 18 years old to use this app.

You are responsible for maintaining the confidentiality of your login credentials.

The app is for informational and support purposes; it is not a substitute for direct banking services.

3. User Responsibilities
Do not use the App for any fraudulent, illegal, or harmful activity.

You agree not to attempt unauthorized access to any bank systems through the App.

You will provide accurate information when asked by the App.

4. Intellectual Property
All app content, including text, graphics, code, and trademarks, is owned by the app creators or assigned licensors. You may not copy, modify, or distribute any materials from the App without permission.

5. Privacy
Use of the App is also governed by our [Privacy Policy]. We recommend reviewing it to understand how your data is collected and protected.

6. Disclaimer
The App provides information based on publicly available and user-provided banking data but does not perform financial transactions.

The creators are not liable for any incorrect information, system unavailability, or user error.

The App may include links or interfaces to third-party services, and we are not responsible for their content or practices.

7. Limitation of Liability
To the fullest extent allowed by law, the creators are not responsible for any damages resulting from the use or inability to use the App, including any incidental, indirect, or consequential losses.

8. Changes to Terms
We may update these Terms occasionally. Material changes will be notified within the App or by email. Continued use after changes means you accept the revised Terms.

9. Termination
We reserve the right to suspend or terminate your access to the App at any time for violation of these Terms or for maintenance.

10. Contact Information
For questions about these Terms, please contact us at [support-email@example.com].

''',
        },
      ],
    },
    {
      'title': 'Cookie Policy',
      'data': [
        {
          'q': 'Cookie Policy',
          'a':
              '''Last updated: October 28, 2025

This Cookie Policy explains how the GENAI Banking Chatbot App (“the App”) uses cookies and similar technologies to enhance your experience.

1. What Are Cookies?
Cookies are small text files stored on your device that help the App remember information and improve how features work. Cookies can be set by us (“first-party cookies”) or by third parties providing services (“third-party cookies”).

2. How We Use Cookies
Essential Cookies: Help the app function properly, including logging in, saving settings, and ensuring security.

Performance and Analytics Cookies (if used): Help us understand app usage, which features are popular, and improve performance.

Functionality Cookies: Remember your preferences (language, theme, etc.) to personalize your experience.

3. Managing Cookies
You can usually manage cookies by adjusting settings on your device or app. Disabling certain cookies may affect how the app works.

4. Third-Party Cookies
Some features (like analytics or external links) may use cookies set by third-party providers. Please review their policies as well.

5. Consent
By using the App, you consent to our use of cookies as described in this policy.

6. Changes to Cookie Policy
We may update this policy. Any changes will be posted in the app or on our website.

Contact Us:
For questions about our cookie policy, email [support-email@example.com].

''',
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
          'Privacy Policy',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      // FIX: The Expanded widget was incorrectly placed here.
      // ListView naturally fills the body of a Scaffold.
      body: ListView( 
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        children: ppSections.map((section) {
          final List sectionData = section['data'];

          if (sectionData.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: Material(
              elevation: isDarkMode ? 0 : 2,
              borderRadius: BorderRadius.circular(18),
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          collapsedIconColor: const Color.fromARGB(255, 0, 0, 0),
                          iconColor: const Color.fromARGB(255, 0, 0, 0),
                          maintainState: true,
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedMap[item['q']] = expanded;
                            });
                          },
                          title: Text(
                            item['q'],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                12,
                                24,
                                16,
                              ),
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200], // grey for light mode
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
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}