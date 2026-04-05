import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widget/custome_buttombar.dart';
import 'add_customer_screen.dart';
import '../CustomerScreen/edit_customer_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        toolbarHeight: 50.h,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.r),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18.sp),
                contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: Color(0xFF26A69A)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: Color(0xFF26A69A)),
                ),
              ),
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16.sp, color: Colors.grey[700]),
                SizedBox(width: 6.w),
                Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                _buildCustomerCard('Sowmiya'),
                _buildCustomerCard('Tamil'),
                _buildCustomerCard('Sowmiya'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddCustomerPopup(context),
        backgroundColor: const Color(0xFF26A69A),
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 24.sp),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }

  Widget _buildCustomerCard(String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF26A69A).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF26A69A),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => showEditCustomerPopup(
                  context,
                  name: name,
                  email: 'Sowmiya@gmail.com',
                  phone: '+91 9876543210',
                  location: 'Irugur',
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.edit_note,
                  color: const Color(0xFF26A69A),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.delete_outline, color: Colors.redAccent, size: 18.sp),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Order',
                      style: TextStyle(color: Colors.black87, fontSize: 11.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '15',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total spend',
                      style: TextStyle(color: Colors.black87, fontSize: 11.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '₹45,000',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call_outlined, size: 16.sp),
                  label: Text('Call', style: TextStyle(fontSize: 12.sp)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF26A69A),
                    side: const BorderSide(color: Color(0xFF26A69A)),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.email_outlined, size: 16.sp),
                  label: Text('Email', style: TextStyle(fontSize: 12.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
