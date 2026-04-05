import 'package:flutter/material.dart';

class GrnDetailsScreen extends StatelessWidget {
  const GrnDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff2AA897);
    const Color borderColor = Color(0xffE2E2E2);

    Widget buildDetailRow(
      String label,
      String value, {
      bool isRed = false,
      bool isLast = false,
    }) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isRed ? const Color(0xffD32F2F) : Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) Divider(color: borderColor, height: 1, thickness: 1),
        ],
      );
    }

    Widget buildTableHeader(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget buildTableCell(
      String text, {
      bool isBold = false,
      TextAlign align = TextAlign.center,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "GRN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Top Green Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "GRN -2026-0102",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Good Receipt Note",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  buildDetailRow("GRN No/Date", "GRN-2026-0102"),
                  buildDetailRow("GRN Date", "2026-03-23"),
                  buildDetailRow("PO No.", "PO - 2402", isRed: true),
                  buildDetailRow("PO Date", "2026-03-23"),
                  buildDetailRow("Supplier Name.", "SMV"),
                  buildDetailRow("Invoice No.", "2504"),
                  buildDetailRow("Purchase Type", "Import Purchase"),
                  buildDetailRow("Transport Type", "Vehicle"),
                  buildDetailRow("Vehicle No.", "2402"),
                  buildDetailRow("Driver Name", "Akil"),
                  buildDetailRow("Supplier DC No.", "1529", isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Items Table
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth:
                          MediaQuery.of(context).size.width -
                          32, // Full width minus padding
                    ),
                    child: Table(
                      border: TableBorder.all(
                        color: primaryColor,
                        width: 1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(), // S.No
                        1: IntrinsicColumnWidth(), // Product Name
                        2: IntrinsicColumnWidth(), // Order QTY
                        3: IntrinsicColumnWidth(), // REC QTY
                        4: IntrinsicColumnWidth(), // HSN code
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: primaryColor),
                          children: [
                            buildTableHeader("S.No"),
                            buildTableHeader("Product Name"),
                            buildTableHeader("Order QTY"),
                            buildTableHeader("REC QTY"),
                            buildTableHeader("HSN code"),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTableCell("1"),
                            buildTableCell(
                              "XL 6009 DC-DC\nBoost Convertor",
                              align: TextAlign.left,
                            ),
                            buildTableCell("400"),
                            buildTableCell("0"),
                            buildTableCell(""),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTableCell("2"),
                            buildTableCell(
                              "White Arm\n(Z16-40D)",
                              align: TextAlign.left,
                            ),
                            buildTableCell("300"),
                            buildTableCell("0"),
                            buildTableCell(""),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTableCell("3"),
                            buildTableCell(
                              "VIKRANT -90",
                              align: TextAlign.left,
                            ),
                            buildTableCell("450"),
                            buildTableCell("0"),
                            buildTableCell(""),
                          ],
                        ),
                        TableRow(
                          children: [
                            buildTableCell(""),
                            buildTableCell(
                              "TOTAL",
                              isBold: true,
                              align: TextAlign.left,
                            ),
                            buildTableCell("1150", isBold: true),
                            buildTableCell("0"),
                            buildTableCell(""),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Remarks
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffD6FCF6), // Extremely light blue/teal
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Remarks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "noo",
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Prepared / Checked By Table
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth:
                          MediaQuery.of(context).size.width -
                          32, // Full width minus padding
                    ),
                    child: Table(
                      border: TableBorder.all(
                        color: primaryColor,
                        width: 1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: primaryColor),
                          children: [
                            buildTableHeader("Prepared By"),
                            buildTableHeader("Checked By"),
                            buildTableHeader("Approved By"),
                            buildTableHeader("Received By"),
                          ],
                        ),
                        TableRow(
                          children: [
                            SizedBox(height: 60, child: buildTableCell("")),
                            SizedBox(height: 60, child: buildTableCell("")),
                            SizedBox(height: 60, child: buildTableCell("")),
                            SizedBox(height: 60, child: buildTableCell("")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Print GRN Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                "Print GRN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
