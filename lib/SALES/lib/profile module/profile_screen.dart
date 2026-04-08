import 'package:flutter/material.dart';
import '../widgets/app_theme.dart';
import 'select_language_screen.dart';
import 'notification_screen.dart';
import 'faq_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgCard,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Column(
              children: [
                SizedBox(height: h * 0.04),

                // Profile Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: w * 0.28,
                        height: w * 0.28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2.5,
                          ),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: w * 0.14,
                          color: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: w * 0.04,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.02),

                // Name & Email
                Text('Sowmiya', style: AppTextStyles.heading2),
                SizedBox(height: h * 0.005),
                Text('Sowmiya@gmail.com', style: AppTextStyles.label),

                SizedBox(height: h * 0.025),
                Divider(color: AppColors.divider),
                SizedBox(height: h * 0.02),

                // Menu Items
                _buildMenuItem(
                  context,
                  label: 'Edit Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()),
                  ),
                ),
                SizedBox(height: h * 0.015),
                _buildMenuItem(
                  context,
                  label: 'Notification',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationScreen()),
                  ),
                ),
                SizedBox(height: h * 0.015),
                _buildMenuItem(
                  context,
                  label: 'Language',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SelectLanguageScreen()),
                  ),
                ),
                SizedBox(height: h * 0.015),
                _buildMenuItem(
                  context,
                  label: 'FAQ',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaqScreen()),
                  ),
                ),
                SizedBox(height: h * 0.015),
                _buildMenuItem(
                  context,
                  label: 'Help & Support',
                  onTap: () {},
                ),

                SizedBox(height: h * 0.06),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: h * 0.065,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: AppColors.textWhite),
                    label: Text(
                      'LOGOUT',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textWhite,
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required String label,
        required VoidCallback onTap,
      }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.022,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textWhite,
            ),
          ],
        ),
      ),
    );
  }
}