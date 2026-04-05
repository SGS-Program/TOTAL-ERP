import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login Section/Sign-In.dart';
import '../Profile/settings.dart';
import '../Profile/privacy_policy.dart';

class PurchaseDrawer extends StatelessWidget {
  const PurchaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return InkWell(
                            onTap: () {
                              Scaffold.of(context).closeDrawer();
                            },
                            child: const Icon(Icons.close, color: Colors.black),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Divider(color: Colors.grey.shade300, height: 1),

                /// Profile Tile
                _buildProfileTile(width, height),

                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                  indent: width * 0.05,
                  endIndent: width * 0.05,
                ),

                /// Settings Item
                _buildDrawerItem(
                  Icons.settings,
                  "Settings",
                  width,
                  height,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                  indent: width * 0.05,
                  endIndent: width * 0.05,
                ),

                /// Privacy Item
                _buildDrawerItem(
                  Icons.privacy_tip_outlined,
                  "Privacy & Security",
                  width,
                  height,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                  indent: width * 0.05,
                  endIndent: width * 0.05,
                ),

                /// Logout Item
                _buildDrawerItem(
                  Icons.logout,
                  "Logout",
                  width,
                  height,
                  onTap: () => _showLogoutDialog(context),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                  indent: width * 0.05,
                  endIndent: width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.02,
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(Icons.person, color: Colors.black, size: width * 0.06),
          ),
          SizedBox(width: width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Murali Prakash",
                style: TextStyle(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "+91 908079 51**",
                style: TextStyle(fontSize: width * 0.035, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    double width,
    double height, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.015,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: width * 0.055),
            SizedBox(width: width * 0.04),
            Text(
              title,
              style: TextStyle(
                fontSize: width * 0.038,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileLoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
