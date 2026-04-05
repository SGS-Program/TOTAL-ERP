import 'package:flutter/material.dart';

class GrnInspectionScreen extends StatefulWidget {
  const GrnInspectionScreen({super.key});

  @override
  State<GrnInspectionScreen> createState() => _GrnInspectionScreenState();
}

class _GrnInspectionScreenState extends State<GrnInspectionScreen> {
  int selectedProductIndex = 0;

  Widget _buildStatCard(String title, String value, Color bgColor, Color textColor, {bool isReversed = false}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isReversed ? value : title,
            style: TextStyle(
              color: textColor,
              fontWeight: isReversed ? FontWeight.bold : FontWeight.w600,
              fontSize: isReversed ? 16 : 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isReversed ? title : value,
            style: TextStyle(
              color: textColor,
              fontWeight: isReversed ? FontWeight.w600 : FontWeight.bold,
              fontSize: isReversed ? 12 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value, {bool isHint = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          child: TextField(
            decoration: InputDecoration(
              hintText: isHint ? value : null,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            controller: isHint ? null : TextEditingController(text: value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff2AAA98); // Matches the teal used in the app

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "GRN Inspection",
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
            /// GRN NUMBER Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "GRN NUMBER",
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.cyanAccent, width: 2),
                      ),
                    ),
                    child: const Text(
                      "GRN - 2026 - 0101",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /// 2 Products - Auto Store Enabled
            Row(
              children: [
                const Text(
                  "2 Products",
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  "  -  Auto Store Enabled",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Product Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(3, (index) {
                  bool isSelected = selectedProductIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedProductIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        "Product ${index + 1}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            /// Product Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "PRODUCT NAME",
                        style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xffB18428), // Golden brown
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Pending",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "XL 6009 DC-DC Boost Converter",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Code : SM/BRMS-0048",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  /// Stats Grid Responsive
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildStatCard(
                                  "ORDERED QTY",
                                  "200",
                                  const Color(0xffE9F5FB), // Light Blue
                                  const Color(0xff226CA3), // Blue Dark text
                                ),
                                const SizedBox(height: 12),
                                _buildStatCard(
                                  "Accepted",
                                  "0",
                                  const Color(0xffE6F9EE), // Light Green
                                  const Color(0xff16A84F), // Green Dark text
                                  isReversed: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _buildStatCard(
                                  "RECEIVED QTY",
                                  "50",
                                  const Color(0xffFAEBFA), // Light Pink/Purple
                                  const Color(0xffB52B90), // Magenta text
                                ),
                                const SizedBox(height: 12),
                                _buildStatCard(
                                  "Rejected",
                                  "10",
                                  const Color(0xffFAEEEE), // Light Red
                                  const Color(0xffC62828), // Red Dark text
                                  isReversed: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    "Result : Auto Store",
                    style: TextStyle(color: Color(0xff3B187B), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Product Details & Inspection",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 12),

                  /// Input Fields
                  Row(
                    children: [
                      Expanded(child: _buildInputField("Accept Qty", "1")),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInputField("Rejected Qty", "10")),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField("Remarks", "Remarks", isHint: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Inspection Summary
            const Text(
              "Inspection Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            const Text(
              "Auto Pass : 1",
              style: TextStyle(color: Color(0xff3B187B), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard("Checked", "4", const Color(0xffE2DAFB), const Color(0xff432585), isReversed: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard("Pass", "3", const Color(0xffD6F8DB), const Color(0xff1A8B35), isReversed: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard("Fail", "8", const Color(0xffFAE1E1), const Color(0xffB22323), isReversed: true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(flex: 1, child: SizedBox()), // Padding
                Expanded(
                  flex: 3,
                  child: _buildStatCard("Acc Qty", "40", const Color(0xffE2DAFB), const Color(0xff432585), isReversed: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildStatCard("Rej Qty", "10", const Color(0xffD6F8DB), const Color(0xff1A8B35), isReversed: true),
                ),
                Expanded(flex: 1, child: SizedBox()), // Padding
              ],
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(24),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xff2AAA98), size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            "Submitted Successfully",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2AAA98),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Go back to QC Inspections
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
