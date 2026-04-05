import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widget/custome_buttombar.dart';
import '../OrderScreen/quotation_screen.dart';
import '../OrderScreen/view_order_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF26A69A),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Order',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: const Color(0xFFF0F2FF),
              child: TabBar(
                labelColor: const Color(0xFF26A69A),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                indicatorWeight: 4.h,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                tabs: const [
                  Tab(text: 'Order'),
                  Tab(text: 'Quotation'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [OrderTabContent(), QuotationTabContent()],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
      ),
    );
  }
}

class OrderTabContent extends StatefulWidget {
  const OrderTabContent({super.key});

  @override
  State<OrderTabContent> createState() => _OrderTabContentState();
}

class _OrderTabContentState extends State<OrderTabContent> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> allOrders = [
    {
      'id': '#ORD-1234',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'items': '3 items',
      'price': '₹12,500',
      'status': 'Completed',
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': '#ORD-1234',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'items': '3 items',
      'price': '₹12,500',
      'status': 'Pending',
      'color': const Color(0xFFA1887F),
    },
    {
      'id': '#ORD-1234',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'items': '3 items',
      'price': '₹12,500',
      'status': 'Processing',
      'color': const Color(0xFF3F51B5),
    },
    {
      'id': '#ORD-1234',
      'name': 'Sowmiya',
      'date': '2026-03-01',
      'items': '3 items',
      'price': '₹12,500',
      'status': 'Cancelled',
      'color': Colors.redAccent,
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter == 'All') return allOrders;
    return allOrders.where((o) => o['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        // Status Cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              _buildStatusSumCard('3', 'Completed', const Color(0xFF4CAF50)),
              SizedBox(width: 8.w),
              _buildStatusSumCard('2', 'Process', const Color(0xFF3F51B5)),
              SizedBox(width: 8.w),
              _buildStatusSumCard('1', 'Pending', const Color(0xFFA1887F)),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Recent Header with Dropdown
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(
                selectedFilter == 'All' ? Icons.access_time : Icons.label_outline,
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
                  _buildPopupMenuItem('Completed'),
                  _buildPopupMenuItem('Pending'),
                  _buildPopupMenuItem('Processing'),
                  _buildPopupMenuItem('Cancelled'),
                ],
                offset: Offset(0, 30.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),

        // Order List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final o = filteredOrders[index];
              return _buildOrderCard(
                context,
                o['id'],
                o['name'],
                o['date'],
                o['items'],
                o['price'],
                o['status'],
                o['color'],
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
            fontWeight: selectedFilter == value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSumCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    String id,
    String name,
    String date,
    String items,
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
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
              Text(
                items,
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
                  color: Colors.black,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewOrderDetailsScreen(
                        orderId: id,
                        status: status,
                        customerName: name,
                        date: date,
                      ),
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
