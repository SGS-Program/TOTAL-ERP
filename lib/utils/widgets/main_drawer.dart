import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(context, tealColor),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  label: 'Smart ERP Home',
                  isActive: true,
                  onTap: () => Navigator.pop(context),
                  tealColor: tealColor,
                ),
                _buildDrawerItem(
                  icon: Icons.account_circle_outlined,
                  label: 'My Profile',
                  onTap: () {},
                  tealColor: tealColor,
                ),
                _buildDrawerItem(
                  icon: Icons.business_outlined,
                  label: 'Company Information',
                  onTap: () {},
                  tealColor: tealColor,
                ),
                _buildDrawerItem(
                  icon: Icons.security_outlined,
                  label: 'Privacy & Security',
                  onTap: () {},
                  tealColor: tealColor,
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  label: 'Global Settings',
                  onTap: () {},
                  tealColor: tealColor,
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help Center',
                  onTap: () {},
                  tealColor: tealColor,
                ),
              ],
            ),
          ),
          _buildFooter(context, tealColor),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color tealColor) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: tealColor,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFE0F2F1),
              child: Icon(Icons.person_rounded, color: Color(0xFF26A69A), size: 36),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart ERP Admin',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'admin@sgs-erp.com',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
    required Color tealColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? tealColor : Colors.grey.shade600,
        size: 24,
      ),
      title: Text(
        label,
        style: GoogleFonts.outfit(
          color: isActive ? tealColor : Colors.grey.shade800,
          fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
          fontSize: 15,
        ),
      ),
      tileColor: isActive ? tealColor.withOpacity(0.05) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      onTap: onTap,
    );
  }

  Widget _buildFooter(BuildContext context, Color tealColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            label: 'Logout Session',
            onTap: () {},
            tealColor: Colors.redAccent,
          ),
          const SizedBox(height: 12),
          Text(
            'Smart ERP v1.0.2',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade400,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
