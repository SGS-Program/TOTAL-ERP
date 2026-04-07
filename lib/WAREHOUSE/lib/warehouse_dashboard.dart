import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class WarehouseDashboard extends StatefulWidget {
  final bool isEmbedded;
  const WarehouseDashboard({super.key, this.isEmbedded = false});

  @override
  State<WarehouseDashboard> createState() => _WarehouseDashboardState();
}

class _WarehouseDashboardState extends State<WarehouseDashboard> {
  final Color primaryColor = const Color(0xFF26A69A); // ERP Teal
  final Color infoBlue = const Color(0xFF2196F3);
  final Color successGreen = const Color(0xFF4CAF50);
  final Color warningOrange = const Color(0xFFFFA726);
  final Color errorRed = const Color(0xFFEF5350);
  final Color bgColor = const Color(0xFFF8FAF9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: widget.isEmbedded ? null : _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildMainStats(),
            SizedBox(height: 30.h),
            _buildAccuracySection(),
            SizedBox(height: 30.h),
            _buildOperationsSection(),
            SizedBox(height: 30.h),
            _buildQuickActions(),
            SizedBox(height: 100.h), // Extra space for bottom padding
          ],
        ),
      ).animate().fadeIn(duration: 600.ms),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {"title": "Configuration", "icon": Icons.settings_outlined, "color": Colors.blueGrey},
      {"title": "Inbound", "icon": Icons.login_outlined, "color": Colors.blue},
      {"title": "Raw Material", "icon": Icons.category_outlined, "color": Colors.green},
      {"title": "Stock Transfer", "icon": Icons.swap_horiz_outlined, "color": Colors.orange},
      {"title": "Picking & Packing", "icon": Icons.inventory_2_outlined, "color": Colors.purple},
      {"title": "Stock Audit", "icon": Icons.assignment_turned_in_outlined, "color": Colors.teal},
      {"title": "Reorder", "icon": Icons.reorder_outlined, "color": Colors.red},
      {"title": "Returns", "icon": Icons.keyboard_return_outlined, "color": Colors.indigo},
      {"title": "Finished Goods", "icon": Icons.done_all_outlined, "color": Colors.amber.shade800},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "QUICK ACTIONS",
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28.sp),
                  SizedBox(height: 8.h),
                  Text(
                    action['title'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ).animate().scale(delay: (index * 40).ms, duration: 300.ms);
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        "Warehouse Control",
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.qr_code_scanner, color: Colors.grey.shade700, size: 24.sp),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.grey.shade700, size: 24.sp),
          onPressed: () {},
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Warehouse Management Dashboard",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Real-time operational control • Jan 22, 2025",
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _headerButton("Reports", Colors.blue.shade50, Colors.blue.shade700),
            _headerButton("Refresh", Colors.blue, Colors.white),
            _headerButton("Stock Adjustment", successGreen, Colors.white),
          ],
        ),
      ],
    );
  }

  Widget _headerButton(String label, Color bg, Color text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: bg == Colors.blue.shade50 ? Border.all(color: Colors.blue.shade100) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  Widget _buildMainStats() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _statCard("Total Stock On Hand", "45,678", "Units across all locations", Icons.inventory_2, Colors.grey.shade200, Colors.brown),
          SizedBox(width: 12.w),
          _statCard("Inbound Quantity", "2,456", "Today: 456 | Month: 12,345", Icons.arrow_downward, Colors.blue.shade50, Colors.blue),
          SizedBox(width: 12.w),
          _statCard("Outbound Quantity", "1,892", "Today: 342 | Month: 18,920", Icons.arrow_upward, Colors.purple.shade50, Colors.purple),
          SizedBox(width: 12.w),
          _statCard("Pending Dispatch", "67", "Requires immediate action", Icons.timer, Colors.orange.shade50, Colors.orange),
          SizedBox(width: 12.w),
          _statCard("Low Stock Items", "23", "Below reorder level", Icons.warning_amber, Colors.orange.shade50, Colors.deepOrange),
          SizedBox(width: 12.w),
          _statCard("Out-of-Stock", "8", "Immediate procurement needed", Icons.close, Colors.red.shade50, Colors.red),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, String sub, IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            sub,
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              color: iconColor.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracySection() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _accuracyTile("STOCK ACCURACY", 88, [
            {"label": "Total SKUs", "value": "2,456", "color": Colors.grey},
            {"label": "Verified Stock", "value": "2,161", "color": Colors.green},
            {"label": "Pending", "value": "295", "color": Colors.orange},
          ]),
        ),
        SizedBox(width: 16.w),
        Expanded(
          flex: 1,
          child: _accuracyTile("PICKING ACCURACY", 96.5, [
            {"label": "Current Performance", "value": "High", "color": Colors.blue},
            {"label": "Orders Today", "value": "342", "color": Colors.deepPurple},
            {"label": "Avg Time", "value": "12 mins", "color": Colors.grey},
          ], isPicking: true),
        ),
      ],
    );
  }

  Widget _accuracyTile(String title, double percentage, List<Map<String, dynamic>> items, {bool isPicking = false}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: SizedBox(
              height: 120.h,
              width: 120.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: isPicking ? successGreen : primaryColor,
                          value: percentage,
                          title: '',
                          radius: 12.r,
                        ),
                        PieChartSectionData(
                          color: Colors.grey.shade100,
                          value: 100 - percentage,
                          title: '',
                          radius: 12.r,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${percentage.toString().replaceAll('.0', '')}%",
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: isPicking ? successGreen : primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['label'],
                    style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  item['value'],
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: item['color'] == Colors.green ? successGreen : (item['color'] == Colors.orange ? warningOrange : const Color(0xFF1A1A1A)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOperationsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WAREHOUSE OPERATIONS",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 20.h),
          _operationItem("Goods Received", "Completed Today", "456", Colors.blue, Icons.check_circle),
          _operationItem("GRN Completed", "Processing Done", "34", successGreen, Icons.check_circle_outline),
          _operationItem("Picking/Packing", "In Progress", "45", Colors.purple, Icons.hourglass_empty),
          _operationItem("Ready for Dispatch", "Awaiting Courier", "89", Colors.orange, Icons.local_shipping),
        ],
      ),
    );
  }

  Widget _operationItem(String title, String sub, String count, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            count,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
