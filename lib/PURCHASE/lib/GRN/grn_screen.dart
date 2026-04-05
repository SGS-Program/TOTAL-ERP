import 'package:flutter/material.dart';
import 'create_grn_screen.dart';
import 'grn_details_screen.dart';

class GRNScreen extends StatefulWidget {
  const GRNScreen({super.key});

  @override
  State<GRNScreen> createState() => _GRNScreenState();
}

class _GRNScreenState extends State<GRNScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff22A79A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "GRN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff22A79A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGRNScreen()),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("New", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 1. TOP FILTERS ROW
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                filterChip("All"),
                filterChip("Pending QC"),
                filterChip("Inspecting"),
                filterChip("Accepted"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 2. GRN LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                grnCard(
                  id: "GRN - 3966",
                  supplier: "Global Metals Pvt Ltd. ",
                  date: "Mar 23,2026",
                  status: "Pending",
                  statusColor: const Color(0xffC09624),
                  items: [
                    GRNItemRow("Stainless Steel Sheet 2mm", "50/PO", "50 Nos"),
                    GRNItemRow("Welding Roads 3.5mm", "200/PO", "200 Kg"),
                  ],
                  dcNo: "3C25",
                  vehicleNo: "TN39BY5656",
                  totalItems: "2 Items",
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff22A79A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget grnCard({
    required String id,
    required String supplier,
    required String date,
    required String status,
    required Color statusColor,
    required List<GRNItemRow> items,
    required String dcNo,
    required String vehicleNo,
    required String totalItems,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                id,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(supplier, style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500)),
              Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),

          /// GREY BOX FOR ITEMS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Text(
                        "Rcvd: ${item.rcvd}/PO: ${item.po}",
                        style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          /// VEHICLE INFO ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "DC: $dcNo, Vechicle: $vehicleNo",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
              Text(
                totalItems,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ACTIONS BUTTONS
          InkWell(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xff22A79A)),
              ),
              child: const Text(
                "Start QC Inspection",
                style: TextStyle(color: Color(0xff22A79A), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 12),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GrnDetailsScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff22A79A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "View GRN / PDF",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GRNItemRow {
  final String title;
  final String rcvd;
  final String po;

  GRNItemRow(this.title, this.rcvd, this.po);
}
