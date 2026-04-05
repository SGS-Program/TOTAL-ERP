import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class EcommerceDashboard extends StatefulWidget {
  final bool isEmbedded;
  const EcommerceDashboard({super.key, this.isEmbedded = false});

  @override
  State<EcommerceDashboard> createState() => _EcommerceDashboardState();
}

class _EcommerceDashboardState extends State<EcommerceDashboard> {
  final Color primaryColor = const Color(0xFF26A69A);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAF9);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: widget.isEmbedded ? null : _buildDrawer(context),
      appBar: widget.isEmbedded ? null : _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingSection(context, isDark),
            _buildSummaryRow(context, isDark),
            _buildSectionTitle('E-COMMERCE Overview'),
            _buildOverviewGrid(context, isDark),
            _buildSectionTitle('E-COMMERCE Modules'),
            _buildModulesGrid(context, isDark),
            _buildSectionTitle('Sales Analytics'),
            _buildAnalyticsCharts(context, isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: const Color(0xFF26A69A),
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(
        'E-COMMERCE',
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildGreetingSection(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome to E-COMMERCE, ',
                  style: GoogleFonts.outfit(color: isDark ? Colors.grey : Colors.grey.shade600, fontSize: 14.sp),
                ),
                TextSpan(
                  text: 'Alex Morgan',
                  style: GoogleFonts.outfit(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Saturday, April 4, 2026 at 04:25 PM • Live E COMMERCE Dashboard',
            style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 11.sp),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildSummaryRow(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _buildSummaryItem('24hr', 'Live Sales', isDark),
          _buildSummaryItem('7 Days', 'Sales Period', isDark),
          _buildSummaryItem('30 Min', 'Avg Response', isDark),
          _buildSummaryItem('99.2%', 'Uptime', isDark),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, bool isDark) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.outfit(color: const Color(0xFF673AB7), fontWeight: FontWeight.w900, fontSize: 20.sp)),
          SizedBox(height: 4.h),
          Text(label, style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 10.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    ).animate().scale(delay: 200.ms, begin: const Offset(0.95, 0.95));
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 15.h),
      child: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.w800, color: Colors.grey.shade800),
      ),
    );
  }

  Widget _buildOverviewGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 1.1,
      children: [
        _buildMetricCard("Today's Sales", "\$24,850", "+18.5%", Icons.monetization_on_rounded, Colors.orange, isDark),
        _buildMetricCard("Total Orders", "156", "+12.3%", Icons.inventory_2_rounded, Colors.blue, isDark),
        _buildMetricCard("Conversion Rate", "4.8%", "+0.3%", Icons.query_stats_rounded, Colors.purple, isDark),
        _buildMetricCard("Avg. Order Value", "\$159", "+5.2%", Icons.payment_rounded, Colors.cyan, isDark),
        _buildMetricCard("Abandoned Carts", "24", "-8.0%", Icons.shopping_cart_checkout_rounded, Colors.red, isDark),
        _buildMetricCard("New Customers", "89", "+2.3%", Icons.people_alt_rounded, Colors.indigo, isDark),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String trend, IconData icon, Color color, bool isDark) {
    final isPositive = !trend.startsWith('-');
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border(left: BorderSide(color: color, width: 4.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color.withOpacity(0.7), size: 18.w),
              Text(title, style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 10.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.outfit(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w900, fontSize: 20.sp)),
              SizedBox(height: 2.h),
              Text(
                trend,
                style: GoogleFonts.outfit(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildModulesGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 0.8,
      children: [
        _buildModuleItem("Orders\nManagement", Icons.shopping_cart_rounded, Colors.orange.shade50, Colors.orange, "12 pending", isDark),
        _buildModuleItem("Product\nCatalog", Icons.category_rounded, Colors.yellow.shade50, Colors.orange, null, isDark),
        _buildModuleItem("Customer\nManagement", Icons.people_alt_rounded, Colors.purple.shade50, Colors.purple, null, isDark),
        _buildModuleItem("Marketing &\nPromotions", Icons.campaign_rounded, Colors.pink.shade50, Colors.pink, null, isDark),
        _buildModuleItem("Inventory\nManagement", Icons.analytics_rounded, Colors.blue.shade50, Colors.blue, "3 pending", isDark),
        _buildModuleItem("Shipping &\nDelivery", Icons.local_shipping_rounded, Colors.green.shade50, Colors.green, null, isDark),
      ],
    );
  }

  Widget _buildModuleItem(String title, IconData icon, Color bgColor, Color iconColor, String? badge, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isDark ? iconColor.withOpacity(0.1) : bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22.w),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: isDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold, fontSize: 10.sp),
          ),
          if (badge != null) ...[
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4.r)),
              child: Text(badge, style: GoogleFonts.outfit(color: Colors.red, fontSize: 8.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildAnalyticsCharts(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildChartSection(context, "Sales Performance", SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1)),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3), const FlSpot(1, 4), const FlSpot(2, 3.5), const FlSpot(3, 5),
                      const FlSpot(4, 4.5), const FlSpot(5, 6), const FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ), isDark),
          SizedBox(height: 24.h),
          _buildChartSection(context, "Traffic Sources", SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(color: Colors.purple, value: 40, title: 'Direct', radius: 40, showTitle: false),
                  PieChartSectionData(color: Colors.orange, value: 30, title: 'Search', radius: 40, showTitle: false),
                  PieChartSectionData(color: primaryColor, value: 20, title: 'Social', radius: 40, showTitle: false),
                  PieChartSectionData(color: Colors.blue, value: 10, title: 'Email', radius: 40, showTitle: false),
                ],
              ),
            ),
          ), isDark),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, String title, Widget chart, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black87)),
          SizedBox(height: 24.h),
          chart,
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
                  _buildDrawerItem(Icons.dashboard_rounded, 'Dashboard', true),
                  _buildDrawerItem(Icons.image_rounded, 'Banner Image', false),
                  _buildDrawerItem(Icons.info_outline_rounded, 'About Us', false),
                  _buildDrawerItem(Icons.verified_user_rounded, 'Our Certificates', false),
                  _buildDrawerExpandableItem(Icons.shopping_cart_rounded, 'Orders'),
                  _buildDrawerExpandableItem(Icons.people_rounded, 'Customers'),
                  _buildDrawerItem(Icons.local_shipping_rounded, 'Shipping & Delivery', false),
                  _buildDrawerItem(Icons.category_rounded, 'Category', false),
                  _buildDrawerItem(Icons.headset_mic_rounded, 'Customer Care', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool selected) {
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

  Widget _buildDrawerExpandableItem(IconData icon, String title) {
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
