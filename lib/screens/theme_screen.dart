import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String selectedTheme = themeProvider.currentTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Theme",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildThemeOption(
              icon: Icons.wb_sunny_outlined,
              title: "Light",
              value: "Light",
              selectedTheme: selectedTheme,
              onTap: () {
                themeProvider.setThemeMode("Light");
              },
            ),
            SizedBox(height: 16),
            _buildThemeOption(
              icon: Icons.nightlight_round,
              title: "Dark",
              value: "Dark",
              selectedTheme: selectedTheme,
              onTap: () {
                themeProvider.setThemeMode("Dark");
              },
            ),
            SizedBox(height: 16),
            _buildThemeOption(
              icon: Icons.settings_outlined,
              title: "System Default",
              value: "System",
              selectedTheme: selectedTheme,
              onTap: () {
                themeProvider.setThemeMode("System");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String value,
    required String selectedTheme,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedTheme == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[400]!,
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
