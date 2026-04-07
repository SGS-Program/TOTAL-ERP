import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchase_erp/Request%20Approvals/approvals.dart';
import 'package:purchase_erp/Supplier%20Quotations/quotation_comparison.dart';
import 'package:purchase_erp/widgets/bottom_nav.dart';
import 'package:purchase_erp/create_pr.dart';
import 'package:purchase_erp/purchase_orders/purchase_orders.dart';
import 'package:purchase_erp/notification.dart';
import 'package:purchase_erp/RFQ/request_for_quotation.dart';
import 'package:purchase_erp/Reports/reports_analytics.dart';
import 'package:purchase_erp/GRN/grn_screen.dart';
import 'package:purchase_erp/Supplier%20Quotations/supplier_quotations.dart';
import 'package:purchase_erp/QC/qc_inspections_screen.dart';
import 'package:purchase_erp/widgets/drawer_screen.dart';

class Dashboard extends StatefulWidget {
  final bool isEmbedded;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const Dashboard({super.key, this.isEmbedded = false, this.scaffoldKey});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final effectiveKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      key: effectiveKey,
      backgroundColor: Colors.grey[100],
      drawer: const PurchaseDrawer(),
      drawerEnableOpenDragGesture: !widget.isEmbedded,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF26A69A),
              elevation: 0,
              centerTitle: false,
              title: Text(
                "Purchase Management",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white24,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 0),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// ROW 1 CARDS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: gradientCard(
                      "Total Purchase",
                      "₹ 2,48,500",
                      "+12%",
                      const [Color(0xffF70E37), Color(0xffFF869B)],
                      Icons.receipt,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: gradientCard("Pending Approvals", "12", "", const [
                      Color(0xff3A00CA),
                      Color(0xff8E60FF),
                    ], Icons.access_time_filled),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// TOTAL PR + TOTAL PO
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: gradientCard("Total PR", "28", "", const [
                      Color(0xff018477),
                      Color(0xff15F3DD),
                    ], Icons.campaign),
                  ),

                  SizedBox(width: width * 0.03),

                  Expanded(
                    child: gradientCard("Total PO", "16", "", const [
                      Color(0xffA8076A),
                      Color(0xffFF7CCD),
                    ], Icons.list_alt),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),

            /// QUICK ACTIONS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      childAspectRatio: 0.8,
                      children: [
                        ActionItem(
                          Icons.add,
                          "Create PR",
                          const [Color(0xffF70E37), Color(0xffFF869B)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreatePurchaseRequestScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.replay,
                          "SQ",
                          const [Color(0xff3A00CA), Color(0xff8E60FF)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SupplierQuotationsScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.article_outlined,
                          "RFQ",
                          const [Color(0xff018477), Color(0xff15F3DD)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RFQScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.local_offer_outlined,
                          "PO",
                          const [Color(0xffA8076A), Color(0xffFF7CCD)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PurchaseOrdersScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.inventory_rounded,
                          "GRN",
                          const [Color(0xff017A15), Color(0xff30C549)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GRNScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.verified_user_outlined,
                          "QC",
                          const [Color(0xff05988E), Color(0xff7FE2F8)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const QCInspectionsScreen(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.description_outlined,
                          "Approval",
                          const [Color(0xff8C6803), Color(0xffD2C31B)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestApprovals(),
                              ),
                            );
                          },
                        ),
                        ActionItem(
                          Icons.compare_arrows,
                          "Compare",
                          const [Color(0xffF70E37), Color(0xffFF869B)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const QuotationComparisonScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.02),

            /// REPORTS & ANALYTICS BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportsAnalyticsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff26A69A),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Reports & Analytics",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.03),

            /// ANALYTICS CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Purchase Analytics",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A1A1A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF0F0FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "This Month",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF26A69A),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Color(0xFF26A69A),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Builder(
                      builder: (context) {
                        // Define the spots once so showingTooltipIndicators references the same data
                        final spots = const [
                          FlSpot(0, 0.4),
                          FlSpot(1, 1.3),
                          FlSpot(2, 0.9),
                          FlSpot(3, 1.9),
                          FlSpot(4, 1.1),
                          FlSpot(5, 2.48),
                        ];
                        final barData = LineChartBarData(
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: const Color(0xFF26A69A),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              // Highlight the last dot
                              if (index == spots.length - 1) {
                                return FlDotCirclePainter(
                                  radius: 5,
                                  color: const Color(0xFF26A69A),
                                  strokeWidth: 2.5,
                                  strokeColor: Colors.white,
                                );
                              }
                              return FlDotCirclePainter(
                                radius: 3.5,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF26A69A),
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF26A69A).withOpacity(0.35),
                                const Color(0xFF26A69A).withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          spots: spots,
                        );

                        return SizedBox(
                          height: 190,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 3,
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: const Color(
                                      0xffE0E0E0,
                                    ).withOpacity(0.5),
                                    strokeWidth: 1,
                                    dashArray: [5, 5],
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      if (value > 3 || value < 0)
                                        return const SizedBox();
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: Text(
                                          value == 0
                                              ? "0"
                                              : "${value.toInt()}L",
                                          style: const TextStyle(
                                            color: Color(0xff9E9E9E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      const style = TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF26A69A),
                                      );
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text(
                                            "Jan",
                                            style: style,
                                          );
                                        case 1:
                                          return const Text(
                                            "Feb",
                                            style: style,
                                          );
                                        case 2:
                                          return const Text(
                                            "Mar",
                                            style: style,
                                          );
                                        case 3:
                                          return const Text(
                                            "Apr",
                                            style: style,
                                          );
                                        case 4:
                                          return const Text(
                                            "May",
                                            style: style,
                                          );
                                        case 5:
                                          return const Text(
                                            "Jun",
                                            style: style,
                                          );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (spot) =>
                                      const Color(0xff2D237A),
                                  tooltipBorderRadius: BorderRadius.circular(8),
                                  tooltipPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        "₹2.48L",
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              // Always show tooltip at the Jun (index 5) data point
                              showingTooltipIndicators: [
                                ShowingTooltipIndicators([
                                  LineBarSpot(barData, 0, spots[5]),
                                ]),
                              ],
                              lineBarsData: [barData],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.03),

            /// ORDER STATUS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Status",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffDE318A), // Outer Pink
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff2A4FD3),
                                  ),
                                ),
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff9139ED),
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffD3A422),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                LegendItem("Rejected", Color(0xffDE318A)),
                                SizedBox(height: 12),
                                LegendItem("Completed", Color(0xff2A4FD3)),
                                SizedBox(height: 12),
                                LegendItem("Pending", Color(0xffD3A422)),
                                SizedBox(height: 12),
                                LegendItem("Process", Color(0xff9139ED)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }

  Widget gradientCard(
    String title,
    String value,
    String percent,
    List<Color> colors,
    IconData icon,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final titleFontSize = cardWidth * 0.11 > 17 ? 17.0 : cardWidth * 0.11;
        final valueFontSize = cardWidth * 0.18 > 30 ? 30.0 : cardWidth * 0.18;

        return Container(
          height: 125,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: valueFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Icon Positioning: Top-right if percentage exists, otherwise bottom-right
              Positioned(
                top: percent.isNotEmpty ? 12 : null,
                bottom: percent.isEmpty ? 35 : null,
                right: 8,
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 26, color: Colors.white),
                ),
              ),

              // Percent at bottom-right (only for Total Purchase)
              if (percent.isNotEmpty)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Text(
                    percent,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Color> gradient;
  final VoidCallback? onTap;

  const ActionItem(
    this.icon,
    this.text,
    this.gradient, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Container(
              width: width * 0.14,
              height: width * 0.14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const LegendItem(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
