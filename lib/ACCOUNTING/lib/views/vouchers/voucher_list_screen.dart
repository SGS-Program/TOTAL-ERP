import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherListScreen extends StatelessWidget {
  const VoucherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        title: Text(
          "Voucher List",
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return _buildVoucherItem(
            "SPS/27/SI000${index + 1}",
            index % 2 == 0 ? "Receipt Voucher" : "Payment Voucher",
            index % 2 == 0 ? "Client Payment" : "Vendor Payout",
            "₹${(index + 1) * 2500}",
            "04-04-2026",
            index % 2 == 0 ? Colors.green : Colors.orange,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tealColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVoucherItem(String id, String type, String party, String amount, String date, Color typeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.blue[800])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(type, style: GoogleFonts.outfit(color: typeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(party, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(date, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Text(amount, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
