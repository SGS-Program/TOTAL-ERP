import 'package:flutter/material.dart';

class QuotationComparisonScreen extends StatefulWidget {
  const QuotationComparisonScreen({super.key});

  @override
  State<QuotationComparisonScreen> createState() =>
      _QuotationComparisonScreenState();
}

class _QuotationComparisonScreenState extends State<QuotationComparisonScreen> {
  String? selectedQuotation;
  bool showTable = false;

  final List<Map<String, dynamic>> comparisonData = [
    {
      "supplier": "Ravi Industries",
      "qty": "200",
      "sku": "Nos.",
      "rate": "0.00",
      "tax": "0.00",
      "taxAmt": "0.00",
      "dis": "0.00",
      "other": "0.00",
      "netRate": "0.00",
      "paymentTerm": "-",
      "price": "HIGHER",
    },
    {
      "supplier": "Ravi Industries",
      "qty": "150",
      "sku": "Nos.",
      "rate": "0.00",
      "tax": "0.00",
      "taxAmt": "0.00",
      "dis": "0.00",
      "other": "0.00",
      "netRate": "0.00",
      "paymentTerm": "-",
      "price": "LOWEST",
    },
    {
      "supplier": "Ravi Industries",
      "qty": "600",
      "sku": "Nos.",
      "rate": "0.00",
      "tax": "0.00",
      "taxAmt": "0.00",
      "dis": "0.00",
      "other": "0.00",
      "netRate": "0.00",
      "paymentTerm": "-",
      "price": "HIGHER",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quotation Comparison",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff26A69A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Quotation No",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      "Select Quotation No",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    value: selectedQuotation,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    items: ["QUOT - 2401", "QUOT - 2402", "QUOT - 2403"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedQuotation = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  setState(() {
                    showTable = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xff26A69A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Load Comparision",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (showTable)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff26A69A)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: const Color(0xff26A69A),
                              ),
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.all(
                                  const Color(0xff26A69A),
                                ),
                                columnSpacing: screenWidth > 800 ? 32 : 16,
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                dataTextStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                                border: TableBorder.all(
                                  color: const Color(0xff26A69A),
                                  width: 1,
                                ),
                                columns: const [
                                  DataColumn(label: Text("Supplier")),
                                  DataColumn(label: Text("QTY")),
                                  DataColumn(label: Text("SKU")),
                                  DataColumn(label: Text("Rate(₹)")),
                                  DataColumn(label: Text("Tax %")),
                                  DataColumn(label: Text("Tax Amt (₹)")),
                                  DataColumn(label: Text("Dis %")),
                                  DataColumn(label: Text("Other")),
                                  DataColumn(label: Text("Net Rate (₹)")),
                                  DataColumn(label: Text("Payment Term")),
                                  DataColumn(label: Text("Price")),
                                ],
                                rows: comparisonData.map((data) {
                                  final priceText = data['price'] as String;
                                  final isHigher = priceText == "HIGHER";
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data['supplier'])),
                                      DataCell(Text(data['qty'])),
                                      DataCell(Text(data['sku'])),
                                      DataCell(Text(data['rate'])),
                                      DataCell(Text(data['tax'])),
                                      DataCell(Text(data['taxAmt'])),
                                      DataCell(Text(data['dis'])),
                                      DataCell(Text(data['other'])),
                                      DataCell(Text(data['netRate'])),
                                      DataCell(Text(data['paymentTerm'])),
                                      DataCell(
                                        Text(
                                          priceText,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isHigher
                                                ? const Color(0xffB93A2D) // Dark red
                                                : const Color(0xff2A8C3B), // Green
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
