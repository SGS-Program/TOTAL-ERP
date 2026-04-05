import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'What is Sales ERP?',
      'answer': 'Sales ERP is a comprehensive software solution designed to manage and optimize sales processes, including order tracking, customer relationship management, and sales reporting.'
    },
    {
      'question': 'How can I create a new order?',
      'answer': 'You can create a new order by navigating to the Order screen and clicking the "Add Order" button.'
    },
    {
      'question': 'How will I receive notifications?',
      'answer': 'Notifications are sent via push alerts and email based on your settings in the Notification screen.'
    },
    {
      'question': 'How do I track sales reports?',
      'answer': 'Sales reports can be accessed through the "Report" section on the dashboard, providing visualization of revenue and order trends.'
    },
    {
      'question': 'Can I update customer details?',
      'answer': 'Yes, customer details can be updated within the Lead management or Customer section of the app.'
    },
  ];

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
          'FAQ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            ...faqs.map((faq) => _buildFaqItem(faq['question']!, faq['answer']!)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        childrenPadding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
