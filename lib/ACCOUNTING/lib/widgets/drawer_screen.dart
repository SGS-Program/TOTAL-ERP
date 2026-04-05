import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/vouchers/voucher_entry_screen.dart';
import '../views/vouchers/voucher_list_screen.dart';
import '../views/cash_bank/cash_bank_screen.dart';

class AccountingDrawer extends StatelessWidget {
  const AccountingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    final headerStyle = GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.grey[700],
    );

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: tealColor),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    "ACCOUNTING",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.dashboard_outlined, "Dashboard", true),
                _buildMenuItemWithNav(context, Icons.receipt_long_outlined, "Vouchers", const VoucherListScreen()),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text("MANAGEMENT", style: headerStyle),
                ),
                
                ExpansionTile(
                  leading: const Icon(Icons.edit_note, color: tealColor),
                  title: Text("Voucher Entry", style: GoogleFonts.outfit(fontSize: 15)),
                  childrenPadding: const EdgeInsets.only(left: 32),
                  children: [
                    _buildSubMenuItem(context, "Receipt Voucher"),
                    _buildSubMenuItem(context, "Payment Voucher"),
                    _buildSubMenuItem(context, "Journal Voucher"),
                    _buildSubMenuItem(context, "Contra Voucher"),
                    _buildSubMenuItem(context, "Credit Note"),
                    _buildSubMenuItem(context, "Debit Note"),
                  ],
                ),
                
                _buildMenuItemWithNav(context, Icons.account_balance_wallet_outlined, "Cash & Bank", const CashBankManagementScreen()),
                _buildExpansionMenuItem(context, Icons.trending_up_outlined, "Budget & Forecast"),
                _buildExpansionMenuItem(context, Icons.home_work_outlined, "Fixed Assets"),
                _buildExpansionMenuItem(context, Icons.gavel_outlined, "Tax Management"),
                _buildExpansionMenuItem(context, Icons.assessment_outlined, "Profit & Loss"),
                _buildExpansionMenuItem(context, Icons.fact_check_outlined, "Audit & Compliance"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, bool isSelected) {
    const tealColor = Color(0xFF26A69A);
    return ListTile(
      leading: Icon(icon, color: isSelected ? tealColor : Colors.grey[600]),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          color: isSelected ? tealColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildMenuItemWithNav(BuildContext context, IconData icon, String title, Widget target) {
    const tealColor = Color(0xFF26A69A);
    return ListTile(
      leading: Icon(icon, color: tealColor),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => target));
      },
    );
  }

  Widget _buildSubMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherEntryScreen(voucherType: title)));
      },
    );
  }

  Widget _buildExpansionMenuItem(BuildContext context, IconData icon, String title) {
    const tealColor = Color(0xFF26A69A);
    return ExpansionTile(
      leading: Icon(icon, color: tealColor),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 15)),
      children: const [],
    );
  }
}
