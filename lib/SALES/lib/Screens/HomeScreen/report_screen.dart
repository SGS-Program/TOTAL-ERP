import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedFilter = 'Weekly';

  // Comprehensive data for different filters
  final Map<String, dynamic> reportData = {
    'Weekly': {
      'revenue': '₹2,45,000',
      'orders': '145',
      'sold': '1,250',
      'customers': '45',
      'sales': [30, 45, 25, 60, 40, 50, 45],
      'productSlices': [35, 15, 25, 25],
    },
    'Monthly': {
      'revenue': '₹12,80,000',
      'orders': '850',
      'sold': '5,400',
      'customers': '320',
      'sales': [40, 55, 30, 70, 50, 60, 55, 65, 45, 80, 50, 60],
      'productSlices': [40, 20, 20, 20],
    },
    'Yearly': {
      'revenue': '₹1,45,00,000',
      'orders': '9,200',
      'sold': '62,000',
      'customers': '4,500',
      'sales': [300, 450, 350, 600, 500, 700],
      'productSlices': [30, 25, 25, 20],
    },
  };

  @override
  Widget build(BuildContext context) {
    final double padding = 20.w;
    final double availableWidth = 1.sw - (padding * 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        toolbarHeight: 46.h,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.black87,
                    size: 24.sp,
                  ),
                  onSelected: (String value) {
                    setState(() {
                      selectedFilter = value;
                    });
                  },
                  offset: Offset(0, 45.h),
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    side: BorderSide(color: Colors.black12, width: 0.5.w),
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Weekly',
                          height: 40.h,
                          child: Center(
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuDivider(height: 0.h),
                        PopupMenuItem<String>(
                          value: 'Monthly',
                          height: 40.h,
                          child: Center(
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuDivider(height: 0.h),
                        PopupMenuItem<String>(
                          value: 'Yearly',
                          height: 40.h,
                          child: Center(
                            child: Text(
                              'Yearly',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Summary Cards ──────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: (availableWidth / 2) / 85.h,
              children: [
                _buildSummaryCard(
                  'Total Revenue',
                  reportData[selectedFilter]!['revenue'],
                  Icons.account_balance_wallet_outlined,
                  const Color(0xFF6F2FC4),
                ),
                _buildSummaryCard(
                  'Total Orders',
                  reportData[selectedFilter]!['orders'],
                  Icons.shopping_bag_outlined,
                  const Color(0xFFFFB30F),
                ),
                _buildSummaryCard(
                  'Products Sold',
                  reportData[selectedFilter]!['sold'],
                  Icons.inventory_2_outlined,
                  const Color(0xFF29BC00),
                ),
                _buildSummaryCard(
                  'New Customers',
                  reportData[selectedFilter]!['customers'],
                  Icons.people_outline,
                  const Color(0xFFBC1000),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── Sales Trend (Line Chart) ─────────────────────
            _buildChartContainer(
              title: 'Sales Trend',
              child: SizedBox(
                height: 220.h,
                child: _SalesLineChart(
                  data: (reportData[selectedFilter]!['sales'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList(),
                  filter: selectedFilter,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // ── Product Trend (3D Pie Chart) ──────
            _buildChartContainer(
              title: 'Product Trend',
              child: SizedBox(
                height: 220.h,
                child: _Product3DPieChart(
                  data: (reportData[selectedFilter]!['productSlices'] as List)
                      .map((e) => (e as num).toDouble())
                      .toList(),
                  availableWidth: availableWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(80),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 22.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF26A69A).withAlpha(20),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  selectedFilter,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF26A69A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}

// ─── Sales Line Chart ─────────────────────────────────────────
class _SalesLineChart extends StatelessWidget {
  final List<double> data;
  final String filter;
  const _SalesLineChart({required this.data, required this.filter});

  @override
  Widget build(BuildContext context) {
    final dotColors = [
      const Color(0xFFFACC15),
      const Color(0xFF22D3EE),
      const Color(0xFFF472B6),
      const Color(0xFF4ADE80),
      const Color(0xFF94A3B8),
    ];

    final List<FlSpot> spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -12.w,
            top: 8.h,
            bottom: 24.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDot(const Color(0xFF94A3B8)),
                _buildDot(const Color(0xFFF472B6)),
                _buildDot(const Color(0xFFFACC15)),
                _buildDot(const Color(0xFF4ADE80)),
                _buildDot(const Color(0xFF22D3EE)),
                _buildDot(const Color(0xFF94A3B8)),
              ],
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                const Spacer(flex: 3),
                Container(
                  width: 30.w,
                  color: const Color(0xFFF1F5F9).withAlpha(150),
                ),
                const Spacer(flex: 7),
                Container(
                  width: 30.w,
                  color: const Color(0xFFF1F5F9).withAlpha(150),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
          LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: const Color(0xFFE2E8F0), strokeWidth: 1.w),
              ),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: const Color(0xFF94A3B8), width: 2.w),
                  bottom: BorderSide(
                    color: const Color(0xFF94A3B8),
                    width: 2.w,
                  ),
                ),
              ),
              minX: 0,
              maxX: (data.length - 1).toDouble(),
              minY: 0,
              maxY: data.reduce((a, b) => a > b ? a : b) * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: const Color(0xFF94A3B8).withAlpha(180),
                  barWidth: 2.w,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 4.r,
                          color: dotColors[index % dotColors.length],
                          strokeWidth: 0,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF94A3B8).withAlpha(30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6.r,
      height: 6.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Product3DPieChart extends StatefulWidget {
  final List<double> data;
  final double availableWidth;

  const _Product3DPieChart({required this.data, required this.availableWidth});

  @override
  State<_Product3DPieChart> createState() => _Product3DPieChartState();
}

class _Product3DPieChartState extends State<_Product3DPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const _colors = [
    Color(0xFFC42DB1), // Electronics — pink/magenta
    Color(0xFF1CBBC4), // Clothing    — teal
    Color(0xFF263AB6), // Food        — dark blue
    Color(0xFF7B39FD), // Others      — purple
  ];

  static const _labels = ['Electronics', 'Clothing', 'Food', 'Others'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_Product3DPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          height: 220.h,
          child: Stack(
            children: [
              // ── 3D Pie ──────────────────────────────────────
              Center(
                child: CustomPaint(
                  size: Size(widget.availableWidth * 0.65, 180.h),
                  painter: _Pie3DPainter(
                    data: widget.data,
                    colors: _colors,
                    progress: _animation.value,
                    depthPx: 20.h,
                    tiltFactor: 0.45,
                  ),
                ),
              ),

              // ── Callout Labels ──────────────────────────────
              ..._buildCallouts(),

              // ── Legend ──────────────────────────────────────
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_labels.length, (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              color: _colors[i],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _labels[i],
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Callout boxes with connector lines — matches screenshot positions
  List<Widget> _buildCallouts() {
    final percentages = _computePercentages();
    return [
      // Electronics — top left
      _callout(
        top: 24.h,
        left: 0,
        label: '${percentages[0].toInt()}%',
        color: _colors[0],
        lineRight: true,
      ),
      // Clothing — top right area
      _callout(
        top: 8.h,
        left: widget.availableWidth * 0.42,
        label: '${percentages[1].toInt()}%',
        color: _colors[1],
        lineRight: false,
      ),
      // Food — bottom right (empty box like screenshot)
      _callout(
        top: 110.h,
        right: 50.w,
        label: '',
        color: _colors[2],
        lineRight: false,
      ),
      // Others — bottom left (empty box like screenshot)
      _callout(
        bottom: 50.h,
        left: widget.availableWidth * 0.25,
        label: '',
        color: _colors[3],
        lineRight: true,
      ),
    ];
  }

  List<double> _computePercentages() {
    final total = widget.data.fold(0.0, (a, b) => a + b);
    return widget.data.map((v) => (v / total) * 100).toList();
  }

  Widget _callout({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required String label,
    required Color color,
    required bool lineRight,
  }) {
    final box = Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color, width: 1.2.w),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: label.isEmpty
          ? SizedBox(width: 18.w, height: 12.h)
          : Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
    );

    final connector = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(width: 16.w, height: 1.2.h, color: color.withOpacity(0.7)),
        Container(
          width: 1.2.w,
          height: 10.h,
          color: color.withOpacity(0.7),
          margin: const EdgeInsets.only(bottom: 0),
        ),
      ],
    );

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: lineRight ? [box, connector] : [connector, box],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CustomPainter — draws a true 3D tilted pie chart
// ─────────────────────────────────────────────────────────────
class _Pie3DPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;
  final double progress; // 0→1 animation progress
  final double depthPx; // vertical depth thickness in px
  final double tiltFactor; // 0=flat circle, 1=very tilted (0.3–0.5 looks good)

  const _Pie3DPainter({
    required this.data,
    required this.colors,
    required this.progress,
    required this.depthPx,
    required this.tiltFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold(0.0, (a, b) => a + b);
    final cx = size.width / 2;
    final topY = size.height * 0.28;
    final rx = size.width * 0.48;
    final ry = rx * tiltFactor;

    // Animate: sweep from 0 to full
    final sweepTotal = 2 * pi * progress;

    // ── Compute sweep angles ──────────────────────────────────
    final sweeps = data.map((v) => (v / total) * sweepTotal).toList();
    final starts = <double>[];
    double cursor = -pi / 2; // start at top
    for (final s in sweeps) {
      starts.add(cursor);
      cursor += s;
    }

    // ── Draw SIDE faces (depth) — only for bottom-half sectors ─
    // Bottom half = sectors whose midpoint angle is between 0 and pi
    for (int i = 0; i < data.length; i++) {
      final start = starts[i];
      final sweep = sweeps[i];
      final mid = start + sweep / 2;

      // Only render depth for sectors facing "downward" in 3D view
      if (sin(mid) > -0.1) {
        _drawSideFace(canvas, cx, topY, rx, ry, start, sweep, colors[i]);
      }
    }

    // ── Draw TOP faces ────────────────────────────────────────
    for (int i = 0; i < data.length; i++) {
      _drawTopFace(canvas, cx, topY, rx, ry, starts[i], sweeps[i], colors[i]);
    }

    // ── Draw sector divider lines on top ─────────────────────
    for (int i = 0; i < data.length; i++) {
      _drawDivider(canvas, cx, topY, rx, ry, starts[i]);
      _drawDivider(canvas, cx, topY, rx, ry, starts[i] + sweeps[i]);
    }
  }

  void _drawSideFace(
    Canvas canvas,
    double cx,
    double topY,
    double rx,
    double ry,
    double start,
    double sweep,
    Color color,
  ) {
    final sidePaint = Paint()
      ..color = _darken(color, 0.30)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Walk the arc outline at the bottom, offset by depthPx
    const steps = 40;
    bool first = true;
    for (int s = 0; s <= steps; s++) {
      final angle = start + (sweep * s / steps);
      final x = cx + rx * cos(angle);
      final y = topY + ry * sin(angle);
      if (first) {
        path.moveTo(x, y + depthPx);
        first = false;
      } else {
        path.lineTo(x, y + depthPx);
      }
    }
    // Walk back along the top arc
    for (int s = steps; s >= 0; s--) {
      final angle = start + (sweep * s / steps);
      final x = cx + rx * cos(angle);
      final y = topY + ry * sin(angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, sidePaint);

    // Center side faces (left and right edges of slice)
    // Left edge
    final lx1 = cx + rx * cos(start);
    final ly1 = topY + ry * sin(start);
    final edgePath1 = Path()
      ..moveTo(cx, topY)
      ..lineTo(lx1, ly1)
      ..lineTo(lx1, ly1 + depthPx)
      ..lineTo(cx, topY + depthPx)
      ..close();
    canvas.drawPath(edgePath1, sidePaint);

    // Right edge
    final rx2 = cx + rx * cos(start + sweep);
    final ry2 = topY + ry * sin(start + sweep);
    final edgePath2 = Path()
      ..moveTo(cx, topY)
      ..lineTo(rx2, ry2)
      ..lineTo(rx2, ry2 + depthPx)
      ..lineTo(cx, topY + depthPx)
      ..close();
    canvas.drawPath(edgePath2, sidePaint);
  }

  void _drawTopFace(
    Canvas canvas,
    double cx,
    double topY,
    double rx,
    double ry,
    double start,
    double sweep,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
      center: Offset(cx, topY),
      width: rx * 2,
      height: ry * 2,
    );

    final path = Path()
      ..moveTo(cx, topY)
      ..arcTo(rect, start, sweep, false)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawDivider(
    Canvas canvas,
    double cx,
    double topY,
    double rx,
    double ry,
    double angle,
  ) {
    final x = cx + rx * cos(angle);
    final y = topY + ry * sin(angle);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, topY), Offset(x, y), paint);
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(_Pie3DPainter old) =>
      old.progress != progress || old.data != data;
}
                      