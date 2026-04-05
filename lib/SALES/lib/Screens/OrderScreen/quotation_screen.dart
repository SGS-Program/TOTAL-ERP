import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'view_quotation.dart';

class QuotationTabContent extends StatefulWidget {
  const QuotationTabContent({super.key});

  @override
  State<QuotationTabContent> createState() => _QuotationTabContentState();
}

class _QuotationTabContentState extends State<QuotationTabContent> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> allQuotations = [
    {
      'id': '#QUO-1001',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'validUntil': '2026-03-15',
      'price': '₹12,500',
      'status': 'Sent',
      'color': Colors.orange,
    },
    {
      'id': '#QUO-1001',
      'name': 'Tamil',
      'date': '2026-03-01',
      'validUntil': '2026-03-15',
      'price': '₹12,500',
      'status': 'Accepted',
      'color': Colors.green,
    },
    {
      'id': '#QUO-1001',
      'name': 'Kalai',
      'date': '2026-03-01',
      'validUntil': '2026-03-15',
      'price': '₹12,500',
      'status': 'Rejected',
      'color': Colors.red,
    },
    {
      'id': '#QUO-1001',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'validUntil': '2026-03-15',
      'price': '₹12,500',
      'status': 'Rejected',
      'color': Colors.red,
    },
  ];

  List<Map<String, dynamic>> get filteredQuotations {
    if (selectedFilter == 'All') return allQuotations;
    return allQuotations.where((q) => q['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Recent / Status Header with Dropdown
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(
                selectedFilter == 'All'
                    ? Icons.access_time
                    : Icons.label_outline,
                size: 20.sp,
                color: Colors.grey,
              ),
              SizedBox(width: 8.w),
              Text(
                selectedFilter == 'All' ? 'Recent' : '$selectedFilter Status',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.tune, color: Colors.grey, size: 20.sp),
                onSelected: (String value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  _buildPopupMenuItem('All'),
                  _buildPopupMenuItem('Sent'),
                  _buildPopupMenuItem('Accepted'),
                  _buildPopupMenuItem('Rejected'),
                ],
                offset: Offset(0, 30.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),

        // Quotation List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredQuotations.length,
            itemBuilder: (context, index) {
              final q = filteredQuotations[index];
              return _buildQuotationCard(
                context,
                q['id'],
                q['name'],
                q['date'],
                q['validUntil'],
                q['price'],
                q['status'],
                q['color'],
              );
            },
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF26A69A),
            fontWeight: selectedFilter == value
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildQuotationCard(
    BuildContext context,
    String id,
    String name,
    String date,
    String validUntil,
    String price,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: TextStyle(
                  color: const Color(0xFF26A69A),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valid Until',
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
              Text(
                validUntil,
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ],
          ),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ViewQuotationScreen(
                      quotationId: id,
                      customerName: name,
                      status: status,
                      date: date,
                      validUntil: validUntil,
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
                      'Preview',
                      style: TextStyle(
                        color: const Color(0xFF26A69A),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
