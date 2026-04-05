import 'package:flutter/material.dart';

class SupplierSelectionScreen extends StatefulWidget {
  const SupplierSelectionScreen({super.key});

  @override
  State<SupplierSelectionScreen> createState() => _SupplierSelectionScreenState();
}

class _SupplierSelectionScreenState extends State<SupplierSelectionScreen> {
  bool selectAll = false;
  List<bool> selectedSuppliers = [false, false, false, false];
  final List<String> suppliers = ["CMS Soft", "RK Traders", "SMM", "SMV"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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
          "Request for Quotation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Supplier...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.black, size: 22),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xff26A69A)),
                ),
              ),
            ),
          ),

          /// SELECT ALL SUPPLIERS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: selectAll,
                    activeColor: const Color(0xff26A69A),
                    onChanged: (val) {
                      setState(() {
                        selectAll = val ?? false;
                        for (int i = 0; i < selectedSuppliers.length; i++) {
                          selectedSuppliers[i] = selectAll;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Select All Suppliers",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// SUPPLIER LIST
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: selectedSuppliers[index],
                          activeColor: const Color(0xff26A69A),
                          onChanged: (val) {
                            setState(() {
                              selectedSuppliers[index] = val ?? false;
                              if (selectedSuppliers.contains(false)) {
                                selectAll = false;
                              } else {
                                selectAll = true;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        suppliers[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// CONFIRM & SAVE BUTTON
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: InkWell(
              onTap: () {
                // Final save action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("RFQ Saved Successfully!")),
                );
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
                  "Confirm & Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }
}
