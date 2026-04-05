import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_lead.dart';
import 'lead_details.dart';

class LeadManagementScreen extends StatelessWidget {
  const LeadManagementScreen({super.key});

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
          'Lead Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leads',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            _buildSearchBar(),
            SizedBox(height: 20.h),
            _buildLeadCard(
              context,
              name: 'Sowmiya',
              company: 'Smart Global Solutions',
              phone: '+91 9876543210',
              email: 'Sowmi@gmail.com',
              status: 'New',
              statusColor: const Color(0xFF6C7CFF),
              source: 'Website',
            ),
            _buildLeadCard(
              context,
              name: 'Tamil',
              company: 'Smart Global Solutions',
              phone: '+91 9876543210',
              email: 'Sowmi@gmail.com',
              status: 'Contacted',
              statusColor: const Color(0xFFFFB74D),
              source: 'call',
            ),
            _buildLeadCard(
              context,
              name: 'Kalai',
              company: 'Smart Global Solutions',
              phone: '+91 9876543210',
              email: 'Sowmi@gmail.com',
              status: 'Qualified',
              statusColor: const Color(0xFF4CAF50),
              source: 'Instagram',
            ),
            SizedBox(height: 24.h),
            Text(
              'Lead Summary',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLeadSummaryGrid(),
            SizedBox(height: 80.h), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLeadScreen()),
          );
        },
        backgroundColor: const Color(0xFF26A69A),
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFF26A69A).withOpacity(0.5)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildLeadCard(
    BuildContext context, {
    required String name,
    required String company,
    required String phone,
    required String email,
    required String status,
    required Color statusColor,
    required String source,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF26A69A),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(Icons.business, company),
                SizedBox(height: 4.h),
                _buildInfoRow(Icons.phone_outlined, phone),
                SizedBox(height: 4.h),
                _buildInfoRow(Icons.mail_outline, email),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  source,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeadDetailsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 18.sp,
                        color: const Color(0xFF26A69A),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'View Detail',
                        style: TextStyle(
                          color: const Color(0xFF26A69A),
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: const Color(0xFF26A69A).withOpacity(0.7),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLeadSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard('Total Leads', '3'),
        _buildSummaryCard('New', '1'),
        _buildSummaryCard('Qualified', '1'),
        _buildSummaryCard('Lost', '1'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String count) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF26A69A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
