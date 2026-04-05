import 'package:flutter/material.dart';

class CreateGRNScreen extends StatefulWidget {
  const CreateGRNScreen({super.key});

  @override
  State<CreateGRNScreen> createState() => _CreateGRNScreenState();
}

class _CreateGRNScreenState extends State<CreateGRNScreen> {
  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _buildTextField(String hint, {bool isPlaceholder = true}) {
    return SizedBox(
      height: 36,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12,
            color: isPlaceholder ? Colors.grey.shade400 : Colors.black87,
            fontWeight: isPlaceholder ? FontWeight.normal : FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 16),
        ],
      ),
    );
  }

  Widget _buildGrnNoDate() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "SMM/GRN/001",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
          Text(
            "23-03-2026",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildPoNoDate() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Search PO No..",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
          Text(
            "dd-mm-yyyy",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexibleGrid({
    required BoxConstraints constraints,
    required List<Widget> children,
    bool allowHalfWidthOnMobile = false,
    List<int>? halfWidthIndicesMobile,
  }) {
    double w = constraints.maxWidth;
    bool isMobile = w <= 600;
    bool isTablet = w > 600 && w <= 900;

    double spacing = 12.0;

    double w1 = w;
    double w2 = (w - spacing) / 2;
    double w3 = (w - spacing * 2) / 3;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children.asMap().entries.map((entry) {
        int idx = entry.key;
        Widget child = entry.value;

        double finalWidth;
        if (isMobile) {
          if (allowHalfWidthOnMobile &&
              halfWidthIndicesMobile != null &&
              halfWidthIndicesMobile.contains(idx)) {
            finalWidth = w2;
          } else {
            finalWidth = w1;
          }
        } else if (isTablet) {
          finalWidth = w2;
        } else {
          finalWidth = w3;
        }

        return SizedBox(
          width: (finalWidth - 0.1).clamp(0, double.infinity),
          child: child,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> headerFields = [
      _buildLabeledField("GRN NO & DATE", _buildGrnNoDate()),
      _buildLabeledField("SUPPLIER NAME", _buildDropdown("-Select Supplier-")),
      _buildLabeledField("PO NO & DATE", _buildPoNoDate()),
      _buildLabeledField("PURCHASE TYPE", _buildDropdown("-Select Purchase Type-")),
      _buildLabeledField("INVOICE NO", _buildTextField("Invoice No", isPlaceholder: false)),
      _buildLabeledField("DRIVER NAME", _buildTextField("Driver Name", isPlaceholder: false)),
      _buildLabeledField("VEHICLE NO", _buildTextField("Vehicle No", isPlaceholder: false)),
      _buildLabeledField("SUPPLIER DC NO", _buildTextField("Supplier DC No", isPlaceholder: false)),
      _buildLabeledField("TRANSPORT TYPE", _buildDropdown("-Select Transport-")),
    ];

    List<Widget> item1Fields = [
      _buildLabeledField("Item Code", _buildTextField("Enter Item Code")),
      _buildLabeledField("Item Name", _buildTextField("Enter Item Name")),
      _buildLabeledField("HSN Code", _buildTextField("Enter Quantity")),
      _buildLabeledField("PO Ordered QTY", _buildTextField("0")),
      _buildLabeledField("Received QTY", _buildTextField("0")),
      _buildLabeledField("Rejected QTY", _buildTextField("0")),
      _buildLabeledField("Remarks", _buildTextField("Remarks")),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Create GRN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xff22A79A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "HEADER INFORMATION",
              style: TextStyle(
                color: Color(0xff22A79A), // Teal
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return _buildFlexibleGrid(
                  constraints: constraints,
                  children: headerFields,
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                          color: Color(0xff4C3B8A), // Indigo
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff22A79A), // Teal
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white, size: 16),
                        label: const Text(
                          "Add Item",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Item 1",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return _buildFlexibleGrid(
                              constraints: constraints,
                              children: item1Fields,
                              allowHalfWidthOnMobile: true,
                              halfWidthIndicesMobile: [3, 4], // PO Ordered QTY and Received QTY
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff22A79A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                "SAVE GRN",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
