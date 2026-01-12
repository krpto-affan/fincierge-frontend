import 'package:flutter/material.dart';

class GuestSettingsScreen extends StatefulWidget {
  const GuestSettingsScreen({super.key});

  @override
  State<GuestSettingsScreen> createState() => _GuestSettingsScreenState();
}

class _GuestSettingsScreenState extends State<GuestSettingsScreen> {
  bool pushNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        children: [
          // Notifications Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Notifications",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
            child: PhysicalModel(
              color: Colors.white,
              elevation: 6,
              borderRadius: BorderRadius.circular(14),
              shadowColor: Colors.black12,
              child: ListTile(
                leading: Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                  color: Colors.black87,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 0,
                ),
                title: Text(
                  "Push Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Switch(
                  value: pushNotifications,
                  onChanged: (v) {
                    setState(() => pushNotifications = v);
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.blue,
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Security Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Security",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PhysicalModel(
              color: Colors.white,
              elevation: 6,
              borderRadius: BorderRadius.circular(14),
              shadowColor: Colors.black12,
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  size: 28,
                  color: Colors.black87,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 0,
                ),
                title: Text(
                  "Clear Cache",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  "487 MB",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Add your clear cache logic here
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          // About Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "About",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PhysicalModel(
              color: Colors.white,
              elevation: 6,
              borderRadius: BorderRadius.circular(14),
              shadowColor: Colors.black12,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      size: 28,
                      color: Colors.black87,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 0,
                    ),
                    title: Text(
                      "App Version",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      "0.0.1",
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider(height: 2),
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      size: 30,
                      color: Colors.black87,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 0,
                    ),
                    title: Text(
                      "Rate Our App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      // Add your rate app logic here
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
