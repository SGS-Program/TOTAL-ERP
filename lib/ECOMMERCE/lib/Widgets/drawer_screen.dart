import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EcommerceDrawer extends StatelessWidget {
  final Color primaryColor = const Color(0xFF26A69A);
  const EcommerceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              color: primaryColor.withOpacity(0.05),
              child: Row(
                children: [
                   Icon(Icons.shopping_bag_rounded, color: primaryColor, size: 30.w),
                  SizedBox(width: 15.w),
                  Text('E-COMMERCE', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18.sp, color: primaryColor)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                children: [
                  _buildDrawerItem(context, Icons.dashboard_rounded, 'Dashboard', true),
                  _buildDrawerItem(context, Icons.image_rounded, 'Banner Image', false),
                  _buildDrawerItem(context, Icons.info_outline_rounded, 'About Us', false),
                  _buildDrawerItem(context, Icons.verified_user_rounded, 'Our Certificates', false),
                  _buildDrawerExpandableItem(context, Icons.shopping_cart_rounded, 'Orders'),
                  _buildDrawerExpandableItem(context, Icons.people_rounded, 'Customers'),
                  _buildDrawerItem(context, Icons.local_shipping_rounded, 'Shipping & Delivery', false),
                  _buildDrawerItem(context, Icons.category_rounded, 'Category', false),
                  _buildDrawerItem(context, Icons.headset_mic_rounded, 'Customer Care', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, bool selected) {
    return ListTile(
      leading: Icon(icon, color: selected ? primaryColor : Colors.grey, size: 22.w),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          color: selected ? primaryColor : Colors.grey.shade600,
          fontWeight: selected ? FontWeight.bold : FontWeight.w600,
          fontSize: 15.sp,
        ),
      ),
      onTap: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildDrawerExpandableItem(BuildContext context, IconData icon, String title) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.grey, size: 22.w),
      title: Text(title, style: GoogleFonts.outfit(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 15.sp)),
      iconColor: Colors.grey,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 70.w),
          title: Text('View All', style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.grey)),
          onTap: () {},
        ),
      ],
    );
  }
}
