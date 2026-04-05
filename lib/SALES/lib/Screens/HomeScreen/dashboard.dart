import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widget/drawer_screen.dart';
import '../../Widget/custome_buttombar.dart';
import '../LeadScreen/lead_management.dart';
import 'product_screen.dart';
import '../InvoiceScreen/invoice_dashboard.dart';
import 'report_screen.dart';
import '../PaymentScreen/payment.dart';

class SalesDashboard extends StatefulWidget {
  final bool isEmbedded;
  const SalesDashboard({super.key, this.isEmbedded = false});

  @override
  State<SalesDashboard> createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF26A69A),
              elevation: 0,
              centerTitle: false,
              title: Text(
                'Sales Management',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              actions: [
                IconButton(
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.white),
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
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Total Sales',
                  '₹50,000',
                  '+12.5%',
                  Icons.trending_up,
                  const Color(0xFF00BFA5),
                ),
                _buildStatCard(
                  'Orders',
                  '160',
                  '+8.5%',
                  Icons.shopping_cart,
                  const Color(0xFF673AB7),
                ),
                _buildStatCard(
                  'Customers',
                  '80',
                  '+14.5%',
                  Icons.people,
                  const Color(0xFF3F51B5),
                ),
                _buildStatCard(
                  'Invoices',
                  '4',
                  '-2.5%',
                  Icons.description,
                  const Color(0xFFFF9800),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    Icons.bar_chart,
                    'Lead',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeadManagementScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    Icons.inventory_2,
                    'Product',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    Icons.description,
                    'Invoice',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvoiceDashboardScreen(),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    Icons.account_balance_wallet,
                    'Payment',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Report Bar
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportScreen()),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Sales Overview
            _buildSectionContainer(
              'Sales Overview',
              const _SalesOverviewChart(),
            ),
            SizedBox(height: 24.h),

            // Order Status
            _buildSectionContainer(
              'Order Status',
              const _OrderStatusChart(),
            ),

            SizedBox(height: 80.h), // Space for bottom bar
          ],
        ),
      ),
      drawer: widget.isEmbedded ? null : const SalesDrawer(),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percent,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              Row(
                children: [
                  Icon(
                    percent.startsWith('+')
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                  Text(
                    percent,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(String title, Widget child) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.r),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

// ── Sales Overview Chart ────────────────────────────────────

class _SalesBarData {
  final String label;
  final double value;
  final String percent;
  final Color color;
  const _SalesBarData({
    required this.label,
    required this.value,
    required this.percent,
    required this.color,
  });
}

class _SalesOverviewChart extends StatelessWidget {
  const _SalesOverviewChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
      child: const SizedBox(
        height: 220,
        child: CustomPaint(
          painter: _SalesChartPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  const _SalesChartPainter();

  static const List<_SalesBarData> _data = [
    _SalesBarData(
        label: 'Mon', value: 155, percent: '+12.5%', color: Color(0xFF00BFA5)),
    _SalesBarData(
        label: 'Tue', value: 100, percent: '+14.5%', color: Color(0xFF3F51B5)),
    _SalesBarData(
        label: 'Wed', value: 135, percent: '+8.5%', color: Color(0xFF673AB7)),
    _SalesBarData(
        label: 'Thurs', value: 195, percent: '195', color: Color(0xFFFF6D00)),
    _SalesBarData(
        label: 'Fri', value: 155, percent: '-2.5%', color: Color(0xFFFF9800)),
  ];

  static const double _maxValue = 240;
  static const List<int> _yLabels = [240, 200, 160, 120, 80, 40, 0];

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 40.0;
    const bottomPad = 22.0;
    const topPad = 30.0;
    const rightPad = 8.0;
    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - bottomPad - topPad;

    // ── Horizontal grid lines + Y-axis labels ──
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.0;

    for (int i = 0; i < _yLabels.length; i++) {
      final y = topPad + chartH * i / (_yLabels.length - 1);
      canvas.drawLine(
          Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(
          text: '${_yLabels[i]}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPad - tp.width - 4, y - tp.height / 2));
    }

    // ── Axes ──
    final axisPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Y axis
    canvas.drawLine(
      Offset(leftPad, topPad - 10),
      Offset(leftPad, topPad + chartH),
      axisPaint,
    );
    // Y arrowhead
    canvas.drawPath(
      Path()
        ..moveTo(leftPad - 4, topPad - 6)
        ..lineTo(leftPad, topPad - 15)
        ..lineTo(leftPad + 4, topPad - 6),
      Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill,
    );

    // X axis
    canvas.drawLine(
      Offset(leftPad, topPad + chartH),
      Offset(size.width - rightPad + 6, topPad + chartH),
      axisPaint,
    );
    // X arrowhead
    canvas.drawPath(
      Path()
        ..moveTo(size.width - rightPad + 2, topPad + chartH - 4)
        ..lineTo(size.width - rightPad + 11, topPad + chartH)
        ..lineTo(size.width - rightPad + 2, topPad + chartH + 4),
      Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill,
    );

    // ── Bars ──
    final slotW = chartW / _data.length;
    final barW = slotW * 0.44;
    final barCenters = <Offset>[];

    for (int i = 0; i < _data.length; i++) {
      final bar = _data[i];
      final cx = leftPad + slotW * i + slotW / 2;
      final barH = chartH * bar.value / _maxValue;
      final top = topPad + chartH - barH;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(cx - barW / 2, top, barW, barH),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        ),
        Paint()..color = bar.color,
      );

      // X-axis label
      final xt = TextPainter(
        text: TextSpan(
          text: bar.label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      xt.paint(canvas, Offset(cx - xt.width / 2, topPad + chartH + 6));

      barCenters.add(Offset(cx, top));
    }

    // ── Connecting line ──
    final linePath = Path();
    for (int i = 0; i < barCenters.length; i++) {
      if (i == 0) {
        linePath.moveTo(barCenters[i].dx, barCenters[i].dy);
      } else {
        linePath.lineTo(barCenters[i].dx, barCenters[i].dy);
      }
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = Colors.black54
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // ── Dashed connectors, dots, percent labels ──
    final dashPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;

    for (int i = 0; i < barCenters.length; i++) {
      final dot = barCenters[i];

      // Dashed vertical line from dot downward
      double dashY = dot.dy + 10;
      while (dashY < topPad + chartH - 4) {
        canvas.drawLine(
          Offset(dot.dx, dashY),
          Offset(dot.dx, dashY + 4),
          dashPaint,
        );
        dashY += 8;
      }

      // Dot (white fill, dark border)
      canvas.drawCircle(
          dot,
          4.5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill);
      canvas.drawCircle(
        dot,
        4.5,
        Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Percent/value label above dot
      final pt = TextPainter(
        text: TextSpan(
          text: _data[i].percent,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 8),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      pt.paint(canvas, Offset(dot.dx - pt.width / 2, dot.dy - pt.height - 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Order Status Chart ─────────────────────────────────────

class _OrderStatusChart extends StatelessWidget {
  const _OrderStatusChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: const SizedBox(
        height: 210,
        child: CustomPaint(
          painter: _OrderStatusPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _OrderStatusPainter extends CustomPainter {
  const _OrderStatusPainter();

  // Rings: outer → inner
  static const _rings = [
    _Ring(
        radius: 84,
        color: Color(0xFF00BCD4),
        label: 'Completed',
        labelColor: Color(0xFF00BCD4)),
    _Ring(
        radius: 62,
        color: Color(0xFF8BC34A),
        label: 'Process',
        labelColor: Color(0xFF8BC34A)),
    _Ring(
        radius: 44,
        color: Color(0xFFFF5722),
        label: 'Pending',
        labelColor: Color(0xFFFF9800)),
    _Ring(
        radius: 28,
        color: Color(0xFFFFC107),
        label: 'Reject',
        labelColor: Color(0xFFFF5722)),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Circle center: left-ish so callout lines fit on the right
    final cx = size.height * 0.48;
    final cy = size.height / 2;

    // Draw rings outer → inner (so inner paints on top)
    for (final ring in _rings) {
      canvas.drawCircle(
        Offset(cx, cy),
        ring.radius.toDouble(),
        Paint()..color = ring.color,
      );
    }

    // Callout lines (skip innermost yellow — it's just a filled dot)
    // Callout offsets from centre vertically so lines don't overlap
    const callouts = [
      _Callout(ringIndex: 0, dy: -30), // Completed — top
      _Callout(ringIndex: 1, dy: -10), // Process
      _Callout(ringIndex: 2, dy: 10), // Pending
      _Callout(ringIndex: 3, dy: 30), // Reject — bottom
    ];

    for (final c in callouts) {
      final ring = _rings[c.ringIndex];
      final startX = cx + ring.radius;
      final startY = cy + c.dy;
      final endX = size.width - 8;
      final endY = startY;
      final color = ring.labelColor;

      // Horizontal callout line
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX - 6, endY),
        Paint()
          ..color = color
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round,
      );

      // Hollow circle at end
      canvas.drawCircle(
        Offset(endX - 6, endY),
        3.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(endX - 6, endY),
        3.5,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Text label — right-aligned, directly above the hollow-circle endpoint
      final tp = TextPainter(
        text: TextSpan(
          text: ring.label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(endX - 6 - tp.width, endY - tp.height - 3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Ring {
  final int radius;
  final Color color;
  final String label;
  final Color labelColor;
  const _Ring({
    required this.radius,
    required this.color,
    required this.label,
    required this.labelColor,
  });
}

class _Callout {
  final int ringIndex;
  final double dy;
  const _Callout({required this.ringIndex, required this.dy});
}
