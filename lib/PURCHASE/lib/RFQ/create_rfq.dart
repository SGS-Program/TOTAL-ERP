import 'package:flutter/material.dart';

class CreateRFQScreen extends StatefulWidget {
  const CreateRFQScreen({super.key});

  @override
  State<CreateRFQScreen> createState() => _CreateRFQScreenState();
}

class _CreateRFQScreenState extends State<CreateRFQScreen> {
  final List<Map<String, dynamic>> items = [
    {
      "code": TextEditingController(),
      "name": TextEditingController(),
      "uom": TextEditingController(),
      "qty": TextEditingController(),
      "remarks": TextEditingController(),
      "selectedSuppliers": <String>[],
    }
  ];

  final List<String> allSuppliers = ["CMS Soft", "RK Traders", "SMM", "SMV"];

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
          "Create RFQ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROJECT NAME & DATE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Project Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Date : 25-03-2026",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            buildTextField("Project Name"),

            const SizedBox(height: 16),

            /// DEPARTMENT
            const Text(
              "Department",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            buildTextField("Department"),

            const SizedBox(height: 16),

            /// DUE DATE
            const Text(
              "Due Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            buildTextField("25-03-2026"),

            const SizedBox(height: 16),

            /// APPROVED BY
            const Text(
              "Approved By",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            buildTextField("Approved By"),

            const SizedBox(height: 16),

            /// REASON FOR PURCHASE
            const Text(
              "Reason For Purchase",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            buildTextField("Reason For Purchase", maxLines: 3),

            const SizedBox(height: 24),

            /// ITEMS SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Items",
                    style: TextStyle(
                      color: Color(0xff512DA8), // Purple color
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(items.length, (index) => buildItemCard(index)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          items.add({
                            "code": TextEditingController(),
                            "name": TextEditingController(),
                            "uom": TextEditingController(),
                            "qty": TextEditingController(),
                            "remarks": TextEditingController(),
                            "selectedSuppliers": <String>[],
                          });
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff26A69A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text(
                              "Add",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// SUPPLIER QUOTATION BUTTON
            InkWell(
              onTap: () {
                _showSuccessDialog();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff26A69A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Supplier Quotation",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xff26A69A), size: 60),
            const SizedBox(height: 16),
            const Text(
              "Success!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Supplier Quotation created successfully",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff26A69A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back from Create RFQ
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (items.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          buildLabel("Item Code"),
          buildSmallTextField("Enter Item Code", items[index]["code"]),
          const SizedBox(height: 12),
          buildLabel("Product Name"),
          buildSmallTextField("QC Test Result", items[index]["name"]),
          const SizedBox(height: 12),
          buildLabel("UOM"),
          buildSmallTextField("UOM", items[index]["uom"]),
          const SizedBox(height: 12),
          buildLabel("Ordered QTY"),
          buildSmallTextField("0", items[index]["qty"]),
          const SizedBox(height: 12),
          buildLabel("Remarks"),
          buildSmallTextField("Remarks", items[index]["remarks"]),
          const SizedBox(height: 12),
          buildLabel("Supplier"),
          buildSupplierDropdown(index),
        ],
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff26A69A))),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildSmallTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff26A69A))),
      ),
    );
  }

  Widget buildSupplierDropdown(int itemIndex) {
    List<String> selected = items[itemIndex]["selectedSuppliers"];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: selected.isEmpty
                  ? const Text("Supplier", style: TextStyle(color: Colors.grey, fontSize: 13))
                  : Wrap(
                      spacing: 8,
                      children: selected.map((s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 12)),
                        deleteIcon: const Icon(Icons.close, size: 14, color: Colors.red),
                        onDeleted: () {
                          setState(() {
                            selected.remove(s);
                          });
                        },
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Colors.grey.shade200,
                      )).toList(),
                    ),
            ),
          ),
          DropdownButton<String>(
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            items: allSuppliers.where((s) => !selected.contains(s)).map((String s) {
              return DropdownMenuItem<String>(
                value: s,
                child: Text(s, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  selected.add(val);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
