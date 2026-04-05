import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'views/vouchers/voucher_entry_screen.dart';
import 'widgets/drawer_screen.dart';

class AccountingRoot extends StatefulWidget {
  final bool isEmbedded;
  const AccountingRoot({super.key, this.isEmbedded = false});

  @override
  State<AccountingRoot> createState() => _AccountingRootState();
}

class _AccountingRootState extends State<AccountingRoot> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Accounting Overview",
    "General Ledger",
    "Inventory Status",
    "Profit & Loss",
  ];

  final List<Widget> _screens = [
    const AccountingDashboard(),
    const Center(child: Text("Ledger Screen")),
    const Center(child: Text("Inventory Screen")),
    const Center(child: Text("Profit & Loss Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: widget.isEmbedded ? null : const AccountingDrawer(),
      appBar: widget.isEmbedded ? null : AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
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
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: tealColor,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'General',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_outlined),
              activeIcon: Icon(Icons.account_balance_rounded),
              label: 'Ledger',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer_outlined),
              activeIcon: Icon(Icons.equalizer_rounded),
              label: 'P&L',
            ),
          ],
        ),
      ),
    );
  }
}

class AccountingDashboard extends StatelessWidget {
  const AccountingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryCard("Invoices", "₹125,000", Icons.description, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard("Payments", "₹84,200", Icons.payment, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSummaryCard("Expenses", "₹18,500", Icons.shopping_cart, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard("Overdue", "₹12,400", Icons.warning_amber, Colors.red)),
            ],
          ),
          
          const SizedBox(height: 24),
          Text(
            "Quick Actions",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickAction(context, "Receipt", Icons.add_circle_outline, Colors.green, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherEntryScreen(voucherType: "Receipt Voucher")));
              }),
              _buildQuickAction(context, "Payment", Icons.remove_circle_outline, Colors.redAccent, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherEntryScreen(voucherType: "Payment Voucher")));
              }),
              _buildQuickAction(context, "Journal", Icons.history_edu, Colors.blue, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherEntryScreen(voucherType: "Journal Voucher")));
              }),
              _buildQuickAction(context, "Contra", Icons.swap_horiz, Colors.orange, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherEntryScreen(voucherType: "Contra Voucher")));
              }),
            ],
          ),
          
          const SizedBox(height: 24),
          Text(
            "Recent Activities",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityTable(),
          
          const SizedBox(height: 24),
          Text(
            "Transaction Breakdown",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatCard("Total Revenue", "₹450,280", "+12.5%", tealColor),
          const SizedBox(height: 12),
          _buildStatCard("Operational Costs", "₹220,140", "+8.2%", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 4),
          Text(amount, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableRow("SPS/27/SI0001", "Rajesh A.K", "₹5,800", "Paid"),
          _buildTableRow("SPS/27/SI0002", "SS Enertech", "₹53,899", "Pending"),
          _buildTableRow("SPS/27/SI0003", "Manikandan", "₹5,000", "Paid"),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(child: Text("INVOICE", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]))),
          Expanded(child: Text("CUSTOMER", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]))),
          Text("AMOUNT", style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTableRow(String invoice, String customer, String amount, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(invoice, style: GoogleFonts.outfit(fontSize: 13, color: Colors.blue[800], fontWeight: FontWeight.w500))),
          Expanded(child: Text(customer, style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87))),
          Text(amount, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13)),
              const SizedBox(height: 4),
              Text(amount, style: GoogleFonts.outfit(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(change, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
