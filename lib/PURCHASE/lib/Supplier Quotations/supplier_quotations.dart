import 'package:flutter/material.dart';
import 'quotation_details.dart';

class SupplierQuotationsScreen extends StatefulWidget {
  const SupplierQuotationsScreen({super.key});

  @override
  State<SupplierQuotationsScreen> createState() => _SupplierQuotationsScreenState();
}

class _SupplierQuotationsScreenState extends State<SupplierQuotationsScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Supplier Quotations",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// TOP FILTERS ROW
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                filterChip("All"),
                filterChip("Received"),
                filterChip("Compared"),
                filterChip("Selected"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// LIST OF QUOTATIONS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                quotationCard(
                  width,
                  supplierName: "Ravi Industries",
                  status: "Received",
                  quotNo: "QUOT - 2401",
                  validUntil: "2024-12-20",
                  itemName: "Welding Rods 3.5mm",
                  itemRate: "₹1200",
                  delivery: "7 Days delivery",
                  amount: "₹ 59,500",
                  isSelected: false,
                ),
                const SizedBox(height: 16),
                quotationCard(
                  width,
                  supplierName: "Global Metals",
                  status: "Selected",
                  quotNo: "QUOT - 2403",
                  validUntil: "2024-12-22",
                  itemName: "Stainless Steel Sheet 2mm",
                  itemRate: "₹1100",
                  delivery: "6 Days delivery",
                  amount: "₹ 59,500",
                  isSelected: true,
                ),
                const SizedBox(height: 16),
                quotationCard(
                  width,
                  supplierName: "Ravi Industries",
                  status: "Received",
                  quotNo: "QUOT - 2401",
                  validUntil: "2024-12-20",
                  itemName: "Welding Rods 3.5mm",
                  itemRate: "₹1200",
                  delivery: "7 Days delivery",
                  amount: "₹ 59,500",
                  isSelected: false,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget filterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff26A69A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget quotationCard(
    double width, {
    required String supplierName,
    required String status,
    required String quotNo,
    required String validUntil,
    required String itemName,
    required String itemRate,
    required String delivery,
    required String amount,
    required bool isSelected,
  }) {
    Color statusColor = const Color(0xffC09624); // Received (gold)
    if (status == "Selected") {
      statusColor = const Color(0xff188E24); // Selected (green)
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                supplierName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "$quotNo , Valid: $validUntil",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),

          /// ITEM GREY BOX
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemName,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  itemRate,
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// DELIVERY + AMOUNT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                delivery,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// BUTTON 1: SELECT SUPPLIER
          InkWell(
            onTap: () {},
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xffC6FFD0) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xff26A69A),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: const Color(0xff26A69A),
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Select this Supplier",
                    style: TextStyle(
                      color: const Color(0xff26A69A),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// BUTTON 2: VIEW DETAILS
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuotationDetailsScreen(),
                ),
              );
            },
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff26A69A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
