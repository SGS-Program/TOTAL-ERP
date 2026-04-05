import 'package:flutter/material.dart';

class CreateQCInspectionScreen extends StatefulWidget {
  const CreateQCInspectionScreen({super.key});

  @override
  State<CreateQCInspectionScreen> createState() => _CreateQCInspectionScreenState();
}

class _CreateQCInspectionScreenState extends State<CreateQCInspectionScreen> {
  List<int> itemsList = [1];
  int _nextId = 2;
  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12, // Larger as per Image
            color: Colors.black, // Dark black text for labels
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
      height: 38,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12,
            color: isPlaceholder ? Colors.grey.shade400 : Colors.black87,
            fontWeight: isPlaceholder ? FontWeight.normal : FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
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
          const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
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

    double spacing = 16.0;

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
          finalWidth = w3; // Or whatever design needs
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
    const Color primaryColor = Color(0xff2AAA98); // Matches the teal

    List<Widget> headerFields = [
      _buildLabeledField("Inspection ID", _buildTextField("Inspection ID")),
      _buildLabeledField("GRN No", _buildTextField("GRN No")),
      _buildLabeledField("Inspector Name", _buildTextField("Inspector Name")),
      _buildLabeledField("Inspector Date", _buildTextField("24-03-2026", isPlaceholder: false)),
    ];

    // item fields moved to inside the builder

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "QC Inspections",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
            /// Header Block
            LayoutBuilder(
              builder: (context, constraints) {
                return _buildFlexibleGrid(
                  constraints: constraints,
                  children: headerFields,
                );
              },
            ),
            const SizedBox(height: 24),

            /// Items Container Background
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Items",
                    style: TextStyle(
                      color: Color(0xff3B187B), // Indigo from image
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...itemsList.map((itemId) {
                    int index = itemsList.indexOf(itemId) + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item $index",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      itemsList.remove(itemId);
                                    });
                                  },
                                  child: const Icon(Icons.close, color: Color(0xffD32F2F), size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return _buildFlexibleGrid(
                                  constraints: constraints,
                                  children: [
                                    _buildLabeledField("Item Code", _buildTextField("Enter Item Code")),
                                    _buildLabeledField("QC Test Result", _buildTextField("QC Test Result")),
                                    _buildLabeledField("QC Status", _buildDropdown("Select")),
                                    _buildLabeledField("Rejected QTY", _buildTextField("0")),
                                    _buildLabeledField("Remarks", _buildTextField("Remarks")),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  /// Add Item Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          itemsList.add(_nextId++);
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      label: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Save Changes Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Changes Saved Successfully!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: primaryColor,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
