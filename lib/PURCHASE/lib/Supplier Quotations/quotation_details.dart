import 'package:flutter/material.dart';
import 'quotation_comparison.dart';

class QuotationDetailsScreen extends StatelessWidget {
  const QuotationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          "Quotation Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. TOP HEADER BOX
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff22A79A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "QUOT - 2401",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Supplier Quotation - Dec 5, 2025",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffC09624),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "Received",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 2. INFO GRID
            Row(
              children: [
                Expanded(child: infoBox("SUPPLIER ID", "Ravi Industries")),
                const SizedBox(width: 12),
                Expanded(child: infoBox("DELIVERY", "7 Days")),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: infoBox("VALID TILL", "2024-12-20")),
                const SizedBox(width: 12),
                Expanded(child: infoBox("RFQ REF", "RFQ - 2401")),
              ],
            ),

            const SizedBox(height: 24),

            /// 3. SECTION TITLE
            const Text(
              "PRODUCT RATES",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            /// 4. RATES TABLE
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff22A79A)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  /// Table Header
                  Container(
                    color: const Color(0xff22A79A),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: centerText("PRODUCT", isHeader: true),
                        ),
                        Expanded(child: centerText("RATE", isHeader: true)),
                        Expanded(child: centerText("QTY", isHeader: true)),
                        Expanded(child: centerText("DIS %", isHeader: true)),
                        Expanded(child: centerText("GST %", isHeader: true)),
                        Expanded(
                          flex: 2,
                          child: centerText("TOTAL", isHeader: true),
                        ),
                      ],
                    ),
                  ),

                  /// Table Rows
                  tableRow(
                    "Stainless Steel",
                    "₹820",
                    "50",
                    "2%",
                    "18%",
                    "₹47,412",
                  ),
                  const Divider(height: 1, color: Color(0xff22A79A)),
                  tableRow(
                    "Welding Rods",
                    "₹115",
                    "200",
                    "0%",
                    "12%",
                    "₹25,760",
                  ),
                  const Divider(height: 1, color: Color(0xff22A79A)),
                  tableRow(
                    "Stainless Steel",
                    "₹820",
                    "50",
                    "2%",
                    "18%",
                    "₹47,412",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 5. GRAND TOTAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffE6FFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Grand Total (incl. GST)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    "₹ 73,172",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff097A1C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 6. ACTIONS
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xff046259), width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Color(0xff046259), size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Select this Supplier & Create PO",
                      style: TextStyle(
                        color: Color(0xff046259),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff22A79A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Export PDF",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuotationComparisonScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xff22A79A)),
                      ),
                      child: const Text(
                        "Compare All",
                        style: TextStyle(
                          color: Color(0xff22A79A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static Widget centerText(String text, {bool isHeader = false}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isHeader ? Colors.white : Colors.black87,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        fontSize: isHeader ? 12 : 11,
      ),
    );
  }

  Widget tableRow(String p, String r, String q, String d, String g, String t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 2, child: centerText(p)),
          Expanded(child: centerText(r)),
          Expanded(child: centerText(q)),
          Expanded(child: centerText(d)),
          Expanded(child: centerText(g)),
          Expanded(flex: 2, child: centerText(t)),
        ],
      ),
    );
  }
}
