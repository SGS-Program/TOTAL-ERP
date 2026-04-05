import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CashBankManagementScreen extends StatelessWidget {
  const CashBankManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        title: Text(
          "Cash & Bank Management",
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceOverview(),
            const SizedBox(height: 24),
            Text(
              "Recent Bank Transactions",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildBankTransactionItem("HDFC Bank", "Client Payment", "₹45,000", "Credit", Colors.green),
            _buildBankTransactionItem("ICICI Bank", "Vendor Payout", "₹12,400", "Debit", Colors.redAccent),
            _buildBankTransactionItem("Cash", "Office Maintenance", "₹2,500", "Debit", Colors.redAccent),
            _buildBankTransactionItem("HDFC Bank", "Interest Received", "₹450", "Credit", Colors.green),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tealColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBalanceOverview() {
    return Column(
      children: [
        _buildBalanceCard("Total Cash Balance", "₹12,450", Icons.account_balance_wallet, Colors.teal),
        const SizedBox(height: 12),
        _buildBalanceCard("Total Bank Balance", "₹458,200", Icons.account_balance, Colors.blue),
      ],
    );
  }

  Widget _buildBalanceCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(amount, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildBankTransactionItem(String bank, String title, String amount, String type, Color typeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 4),
              Text(bank, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: typeColor)),
              Text(type, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
