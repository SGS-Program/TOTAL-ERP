import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool emailNotifications = true;
  bool orderUpdates = true;
  bool paymentAlerts = true;
  bool lowStockAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your notification settings',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            _buildNotificationItem(
              Icons.mail_outline,
              'Email Notifications',
              'Receive notifications via email',
              emailNotifications,
              (val) => setState(() => emailNotifications = val),
            ),
            _buildNotificationItem(
              Icons.shopping_cart_outlined,
              'Order Updates',
              'Get notified about order status changes',
              orderUpdates,
              (val) => setState(() => orderUpdates = val),
            ),
            _buildNotificationItem(
              Icons.payment_outlined,
              'Payment Alerts',
              'Receive alerts for new payments',
              paymentAlerts,
              (val) => setState(() => paymentAlerts = val),
            ),
            _buildNotificationItem(
              Icons.inventory_2_outlined,
              'Low Stock Alerts',
              'Get notified when stock is low',
              lowStockAlerts,
              (val) => setState(() => lowStockAlerts = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    IconData icon,
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF26A69A), size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF26A69A),
          ),
        ],
      ),
    );
  }
}
