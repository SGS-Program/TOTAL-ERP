import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchase_erp/dashboard.dart';
import 'package:purchase_erp/widgets/bottom_nav.dart';
import 'package:purchase_erp/purchase_orders/pr_details.dart';

class PurchaseRequestScreen extends StatefulWidget {
  const PurchaseRequestScreen({super.key});

  @override
  State<PurchaseRequestScreen> createState() => _PurchaseRequestScreenState();
}

class _PurchaseRequestScreenState extends State<PurchaseRequestScreen> {
  String selectedFilter = "All";

  // Future to hold the API data
  late Future<List<Map<String, dynamic>>> prFuture = fetchPurchaseRequests();

  @override
  void initState() {
    super.initState();
  }

  // Fetch data from API
  Future<List<Map<String, dynamic>>> fetchPurchaseRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cid = prefs.getString('cid');

      if (cid == null || cid.isEmpty) {
        throw Exception("CID not found in SharedPreferences");
      }

      final url = Uri.parse("https://erpsmart.in/total/api/m_api/");

      final response = await http.post(
        url,
        body: {
          "type": "4018",
          "cid": cid,
          "ln": "123",
          "lt": "342",
          "device_id": "123",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['error'] == false && jsonData['data'] != null) {
          final List<dynamic> dataList = jsonData['data'];
          return dataList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          throw Exception(jsonData['error_msg'] ?? "Failed to load data");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF26A69A), Color(0xFF26A69A)],
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          ),
          title: const Text(
            "Purchase Request",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search by PR number or department....",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 26,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.filter_list,
                      size: 32,
                      color: Colors.black,
                    ),
                    onSelected: (String value) {
                      setState(() {
                        selectedFilter = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Filtering by: $value"),
                          duration: const Duration(seconds: 1),
                          backgroundColor: const Color(0xFF26A69A),
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(value: "All", child: Text("All")),
                      const PopupMenuItem(
                        value: "Approved",
                        child: Text("Approved"),
                      ),
                      const PopupMenuItem(
                        value: "Rejected",
                        child: Text("Rejected"),
                      ),
                      const PopupMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),

              // Filter Status Chip Display
              if (selectedFilter != "All")
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        "Showing: ",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Chip(
                        label: Text(selectedFilter),
                        onDeleted: () {
                          setState(() {
                            selectedFilter = "All";
                          });
                        },
                        deleteIcon: const Icon(Icons.close, size: 14),
                        backgroundColor: const Color(
                          0xFF26A69A,
                        ).withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: Color(0xFF26A69A),
                          fontSize: 12,
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: prFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  prFuture = fetchPurchaseRequests();
                                });
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No purchase requests found",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Filter data based on selectedFilter
                    final List<Map<String, dynamic>> allData = snapshot.data!;
                    final filteredData = selectedFilter == "All"
                        ? allData
                        : allData
                              .where((pr) => pr["status"] == selectedFilter)
                              .toList();

                    if (filteredData.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No $selectedFilter requests found",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return prCard(
                          context,
                          width,
                          item["pr_number"] ?? "N/A", // PR Number
                          item["department"] ?? "N/A", // Department
                          item["status"] ?? "Pending", // Status
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      ),
    );
  }

  /// PURCHASE REQUEST CARD (unchanged)
  Widget prCard(
    BuildContext context,
    double width,
    String id,
    String dept,
    String status,
  ) {
    Color statusColor;
    Color bgColor;
    switch (status) {
      case "Approved":
        statusColor = Colors.white;
        bgColor = const Color(0xFF0F8C2A);
        break;
      case "Rejected":
        statusColor = Colors.white;
        bgColor = const Color(0xFFAD0F14);
        break;
      default: // Pending
        statusColor = Colors.white;
        bgColor = const Color(0xFFC89211);
    }

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.035),
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: width * 0.1,
                height: width * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFF26A69A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description, color: Colors.white),
              ),
              SizedBox(width: width * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dept,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: width * 0.012,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PRDetailsScreen(
                    prId: id,
                    department: dept,
                    status: status,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BottomItem class (kept as you provided)
class BottomItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const BottomItem({
    super.key,
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: selected ? const Color(0xff3E2C91) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: selected ? const Color(0xff3E2C91) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
