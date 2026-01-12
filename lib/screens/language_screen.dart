import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = "System Default";

  final List<Map<String, String>> languages = [
    {"name": "System Default", "icon": ""},
    {"name": "English", "icon": "🌐"},
    {"name": "हिन्दी (Hindi)", "icon": "🌐"},
    {"name": "বাংলা (Bangla)", "icon": "🌐"},
    {"name": "తెలుగు (Telugu)", "icon": "🌐"},
    {"name": "मराठी (Marathi)", "icon": "🌐"},
    {"name": "தமிழ் (Tamil)", "icon": "🌐"},
    {"name": "ગુજરાતી (Gujarati)", "icon": "🌐"},
    {"name": "ಕನ್ನಡ (Kannada)", "icon": "🌐"},
    {"name": "اردو (Urdu)", "icon": "🌐"},
    {"name": "മലയാളം (Malayalam)", "icon": "🌐"},
    {"name": "ਪੰਜਾਬੀ (Punjabi)", "icon": "🌐"},
    {"name": "ଓଡ଼ିଆ (Odia)", "icon": "🌐"},
    {"name": "ଅসামীয়া (Assamese)", "icon": "🌐"},
    {"name": "संस्कृतम् (Sanskrit)", "icon": "🌐"},
    {"name": "Español (Spanish)", "icon": "🌐"},
    {"name": "Français (French)", "icon": "🌐"},
    {"name": "Deutsch (German)", "icon": "🌐"},
    {"name": "中文 (Chinese)", "icon": "🌐"},
    {"name": "日本語 (Japanese)", "icon": "🌐"},
    {"name": "العربية (Arabic)", "icon": "🌐"},
    {"name": "Русский (Russian)", "icon": "🌐"},
    {"name": "Português (Portuguese)", "icon": "🌐"},
    {"name": "Italiano (Italian)", "icon": "🌐"},
    {"name": "Türkçe (Turkish)", "icon": "🌐"},
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
          "Language",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(24),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildLanguageOption(
              name: language["name"]!,
              showIcon: language["icon"]!.isNotEmpty,
              isDarkMode: isDarkMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required String name,
    required bool showIcon,
    required bool isDarkMode,
  }) {
    bool isSelected = selectedLanguage == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = name;
        });
        print("Language changed to: $name");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            if (showIcon)
              Icon(
                Icons.language,
                color: isDarkMode ? Colors.white : Colors.black87,
                size: 24,
              ),
            if (showIcon) SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.blue
                      : (isDarkMode ? Colors.grey[400]! : Colors.grey[400]!),
                  width: 2,
                ),
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
