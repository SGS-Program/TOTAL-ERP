import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HrmAdminDashboard extends StatefulWidget {
  const HrmAdminDashboard({super.key});

  @override
  State<HrmAdminDashboard> createState() => _HrmAdminDashboardState();
}

class _HrmAdminDashboardState extends State<HrmAdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2F5E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Admin Command Center",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatBanner(size),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Operational Modules",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E2F5E),
                ),
              ),
            ),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildQuickAction(
                  "Employees",
                  Icons.people_alt_rounded,
                  const Color(0xFF4C84FF),
                  "145 Active",
                ),
                _buildQuickAction(
                  "Attendance",
                  Icons.timer_rounded,
                  const Color(0xFF26A69A),
                  "92% Today",
                ),
                _buildQuickAction(
                  "Leave Control",
                  Icons.email_rounded,
                  const Color(0xFFFF9800),
                  "12 Pending",
                ),
                _buildQuickAction(
                  "Financials",
                  Icons.account_balance_wallet_rounded,
                  const Color(0xFFE91E63),
                  "Payroll Ready",
                ),
                _buildQuickAction(
                  "Analytics",
                  Icons.insights_rounded,
                  const Color(0xFF9C27B0),
                  "Week Report",
                ),
                _buildQuickAction(
                  "System Config",
                  Icons.settings_suggest_rounded,
                  const Color(0xFF607D8B),
                  "All systems go",
                ),
              ],
            ),
            
            _buildPendingApprovalSection(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBanner(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2F5E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Executive Overview",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSimpleStat("Active Staff", "145", Icons.group),
              _buildSimpleStat("Present", "128", Icons.check_circle_outline),
              _buildSimpleStat("Efficiency", "88%", Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color, String sub) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pending Approvals",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "View All",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildApprovalRow("Kavipriyan M", "Casual Leave", "2 Days"),
          const Divider(),
          _buildApprovalRow("Santhosh R", "Permission", "2 Hours"),
        ],
      ),
    );
  }

  Widget _buildApprovalRow(String name, String type, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFFF1F4F9),
            child: Icon(Icons.person, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "$type - $duration",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(60, 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              "Review",
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
