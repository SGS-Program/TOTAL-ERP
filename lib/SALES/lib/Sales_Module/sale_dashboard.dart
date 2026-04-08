import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_theme.dart';
import '../widgets/app_drawer.dart';
import 'notification_screen.dart';
import '../sales_order_module/all_products_screen.dart';
import '../profile module/profile_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const _navItems = [
    _BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    _BottomNavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Orders',
    ),
    _BottomNavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
      label: 'Products',
    ),
    _BottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  static const _tabPages = [
    _DashboardBody(),
    InvoiceCatalogScreen(),
    InvoiceCatalogScreen(isReadOnly: true),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.statusBarTeal,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabPages,
        ),
        bottomNavigationBar: _BottomNavBar(
          selectedIndex: _selectedIndex,
          items: _navItems,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  BOTTOM NAV BAR
// ═══════════════════════════════════════════════════════════════════════════════
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<_BottomNavItem> items;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE8EDF2), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive
                              ? AppColors.primary
                              : const Color(0xFFB0BEC5),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : const Color(0xFFB0BEC5),
                          fontFamily: 'Poppins',
                        ),
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TAB 0 — DASHBOARD BODY
// ═══════════════════════════════════════════════════════════════════════════════
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context),
        _buildQuickActions(),
        _buildSectionLabel('Key Metrics'),
        _buildStatsGrid(),
        _buildSectionLabel('Monthly Revenue Trend'),
        _buildRevenueChart(),
        _buildSectionLabel('Top Products', showMore: true),
        _buildTopProducts(),
        _buildSectionLabel('Recent Orders', showMore: true),
        _buildRecentOrders(),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A2332), size: 18),
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Sales',
            style: TextStyle(
              color: Color(0xFF1A1C1E),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            'Workplace Dashboard',
            style: TextStyle(
              color: Color(0xFF78909C),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
      actions: [
        _NotificationBell(),
        const SizedBox(width: 8),
        _UserAvatar(),
        const SizedBox(width: 16),
      ],
    );
  }

  SliverToBoxAdapter _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          children: [
            _QuickActionButton(
              icon: Icons.analytics_rounded,
              label: 'Analytics Reports',
              color: AppColors.primary,
              bgColor: const Color(0xFFE0F7F4),
            ),
            const SizedBox(width: 10),
            _QuickActionButton(
              icon: Icons.add_circle_outline_rounded,
              label: 'New\nQuotation',
              color: AppColors.purple,
              bgColor: const Color(0xFFF3E5F5),
            ),
            const SizedBox(width: 10),
            _QuickActionButton(
              icon: Icons.flash_on_rounded,
              label: 'Direct\nInvoice',
              color: AppColors.amber,
              bgColor: const Color(0xFFFFF8E1),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionLabel(String title,
      {bool showMore = false}) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1A2332),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            if (showMore) ...[
              const Spacer(),
              Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.primary, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  // ── Stats Grid — childAspectRatio loosened so cards never clip ──────────────
  SliverToBoxAdapter _buildStatsGrid() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate exact card width to size content properly
            final cardWidth = (constraints.maxWidth - 10) / 2;
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: cardWidth / 100, // fixed 100px height per card
              children: const [
                StatCard(
                  icon: Icons.currency_rupee_rounded,
                  title: 'Total Revenue',
                  value: '₹2.85M',
                  change: '+15.2%',
                  isPositive: true,
                  accentColor: AppColors.primary,
                  cardColor: Color(0xFFE8F8F6),
                ),
                StatCard(
                  icon: Icons.shopping_cart_rounded,
                  title: 'Sales Orders',
                  value: '248',
                  change: '+8.3%',
                  isPositive: true,
                  accentColor: AppColors.blue,
                  cardColor: Color(0xFFE3F2FD),
                ),
                StatCard(
                  icon: Icons.format_quote_rounded,
                  title: 'Quotations',
                  value: '92',
                  change: '-2.1%',
                  isPositive: false,
                  accentColor: AppColors.purple,
                  cardColor: Color(0xFFF3E5F5),
                ),
                StatCard(
                  icon: Icons.receipt_long_rounded,
                  title: 'Invoices Issued',
                  value: '186',
                  change: '+5.7%',
                  isPositive: true,
                  accentColor: AppColors.amber,
                  cardColor: Color(0xFFFFF8E1),
                ),
                // StatCard(
                //   icon: Icons.local_shipping_rounded,
                //   title: 'Deliveries',
                //   value: '134',
                //   change: '+11.4%',
                //   isPositive: true,
                //   accentColor: AppColors.green,
                //   cardColor: Color(0xFFE8F5E9),
                // ),
                StatCard(
                  icon: Icons.payments_rounded,
                  title: 'Collections',
                  value: '₹1.92M',
                  change: '+8.0%',
                  isPositive: true,
                  accentColor: Color(0xFF00897B),
                  cardColor: Color(0xFFE0F2F1),
                ),
                 MiniStatCard(
                  icon: Icons.assignment_return_rounded,
                  label: 'Sales Returns',
                  value: '18',
                  color: AppColors.red,
                  bgColor: const Color(0xFFFFEBEE),
                ),
              ],
            );
          },
        ),
      ),
    );
  }



  SliverToBoxAdapter _buildRevenueChart() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: RevenueChartCard(),
      ),
    );
  }

  SliverToBoxAdapter _buildTopProducts() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            TopProductRow(
              rank: 1,
              name: 'Product Alpha X200',
              amount: '₹4,28,500',
              progress: 0.88,
              color: AppColors.primary,
              bgColor: Color(0xFFE0F7F4),
            ),
            SizedBox(height: 8),
            TopProductRow(
              rank: 2,
              name: 'Beta Series 500',
              amount: '₹3,12,000',
              progress: 0.65,
              color: AppColors.blue,
              bgColor: Color(0xFFE3F2FD),
            ),
            SizedBox(height: 8),
            TopProductRow(
              rank: 3,
              name: 'Gamma Pro Max',
              amount: '₹2,85,750',
              progress: 0.54,
              color: AppColors.amber,
              bgColor: Color(0xFFFFF8E1),
            ),
            SizedBox(height: 8),
            TopProductRow(
              rank: 4,
              name: 'Delta Compact V3',
              amount: '₹1,96,200',
              progress: 0.40,
              color: AppColors.purple,
              bgColor: Color(0xFFF3E5F5),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRecentOrders() {
    final orders = [
      OrderData('SO-2026-248', 'Acme Corp Ltd', '₹85,000', 'Delivered',
          AppColors.green),
      OrderData('SO-2026-247', 'TechStar Industries', '₹1,24,500',
          'Processing', AppColors.amber),
      OrderData('SO-2026-246', 'Global Traders', '₹67,200', 'Invoiced',
          AppColors.blue),
      OrderData('SO-2026-245', 'Sunrise Pvt Ltd', '₹2,18,000', 'Pending',
          AppColors.red),
    ];
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: orders
              .map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OrderTile(order: o),
          ))
              .toList(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ),
            );
          },
          icon: const Icon(Icons.notifications_rounded,
              color: Color(0xFF1A1C1E), size: 24),
        ),
        Positioned(
          right: 12,
          top: 14,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xFF26A69A),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => GestureDetector(
        onTap: () => Scaffold.of(ctx).openDrawer(),
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFFE0F2F1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFF26A69A),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today_rounded,
              color: Colors.white70, size: 11),
          const SizedBox(width: 5),
          Text(
            'Jan 2026',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.20), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 17),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Card — overflow-proof ───────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final Color accentColor;
  final Color cardColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.accentColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = isPositive ? AppColors.green : AppColors.red;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 13),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: changeColor,
                        size: 7,
                      ),
                      const SizedBox(width: 1),
                      Flexible(
                        child: Text(
                          change.replaceAll('+', '').replaceAll('-', ''),
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1A2332),
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: accentColor.withOpacity(0.80),
              fontSize: 9,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Mini Stat Card ───────────────────────────────────────────────────────────
class MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const MiniStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: const Color(0xFF1A2332),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.75),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Revenue Chart Card ───────────────────────────────────────────────────────
class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({super.key});

  static const _data = [
    0.45, 0.60, 0.52, 0.75, 0.68, 0.82,
    0.71, 0.90, 0.85, 0.78, 0.95, 0.88,
  ];
  static const _months = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F6),
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: AppColors.primary.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '₹2.85M',
                    style: TextStyle(
                      color: Color(0xFF1A2332),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Total Revenue FY 2025–26',
                    style: TextStyle(
                      color: AppColors.primary.withOpacity(0.75),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded,
                        color: AppColors.green, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+15.2% YoY',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (i) {
                final isHighlight = i == 11;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400 + i * 40),
                            curve: Curves.easeOut,
                            height: 66 * _data[i],
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isHighlight
                                    ? [
                                  AppColors.primaryDark,
                                  AppColors.primaryLight
                                ]
                                    : [
                                  AppColors.primary.withOpacity(0.25),
                                  AppColors.primary.withOpacity(0.55),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _months[i],
                          style: TextStyle(
                            color: isHighlight
                                ? AppColors.primary
                                : const Color(0xFF90A4AE),
                            fontSize: 9,
                            fontWeight: isHighlight
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Product Row ──────────────────────────────────────────────────────────
class TopProductRow extends StatelessWidget {
  final int rank;
  final String name;
  final String amount;
  final double progress;
  final Color color;
  final Color bgColor;

  const TopProductRow({
    super.key,
    required this.rank,
    required this.name,
    required this.amount,
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1A2332),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.14),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Data Model ─────────────────────────────────────────────────────────
class OrderData {
  final String id;
  final String customer;
  final String amount;
  final String status;
  final Color statusColor;
  const OrderData(
      this.id, this.customer, this.amount, this.status, this.statusColor);
}

// ─── Order Tile ───────────────────────────────────────────────────────────────
class OrderTile extends StatelessWidget {
  final OrderData order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: order.statusColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border:
        Border.all(color: order.statusColor.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: order.statusColor.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: order.statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(Icons.receipt_rounded,
                color: order.statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    color: Color(0xFF1A2332),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.customer,
                  style: const TextStyle(
                    color: Color(0xFF78909C),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                order.amount,
                style: const TextStyle(
                  color: Color(0xFF1A2332),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: order.statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
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