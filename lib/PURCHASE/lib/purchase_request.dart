import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchase_erp/dashboard.dart';
import 'package:purchase_erp/widgets/bottom_nav.dart';
import 'package:purchase_erp/purchase_orders/pr_details.dart';
import 'package:purchase_erp/models/pr_model.dart';

class PurchaseRequestScreen extends StatefulWidget {
  const PurchaseRequestScreen({super.key});

  @override
  State<PurchaseRequestScreen> createState() => _PurchaseRequestScreenState();
}

class _PurchaseRequestScreenState extends State<PurchaseRequestScreen> {
  String selectedFilter = "All";
  List<PrData> prList = [];
  bool isLoading = true;
  String errorMessage = "";

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchPrData();
    searchController.addListener(() {
      if (!mounted) return;
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPrData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cid = prefs.getString('cid') ?? '';
      final deviceId = prefs.getString('device_id') ?? 'Unknown';
      final lt = prefs.getString('lt') ?? '0.0';
      final ln = prefs.getString('ln') ?? '0.0';

      if (cid.isEmpty) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = "Account ID not found. Please log in again.";
        });
        return;
      }

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "4006",
          "cid": cid,
          "device_id": deviceId,
          "ln": ln,
          "lt": lt,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final prResponse = PrResponse.fromJson(data);
        if (!prResponse.error) {
          if (!mounted) return;
          setState(() {
            prList = prResponse.data;
            isLoading = false;
          });
        } else {
          if (!mounted) return;
          setState(() {
            isLoading = false;
            errorMessage = prResponse.message;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Filter the data based on selection AND search query
    final filteredData = prList.where((pr) {
      final statusMatch =
          selectedFilter == "All" ||
          _mapStatus(pr.master.status) == selectedFilter;
      final searchMatch =
          searchQuery.isEmpty ||
          pr.master.no.toLowerCase().contains(searchQuery) ||
          pr.master.department.toLowerCase().contains(searchQuery);
      return statusMatch && searchMatch;
    }).toList();

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

        /// APP BAR
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

        body: RefreshIndicator(
          onRefresh: _fetchPrData,
          color: const Color(0xFF26A69A),
          child: Padding(
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
                          controller: searchController,
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

                    /// FILTER POPUP
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
                          value: "Approve",
                          child: Text("Approve"),
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF26A69A),
                          ),
                        )
                      : errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchPrData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF26A69A),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : filteredData.isEmpty
                      ? Center(
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
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            return prCard(context, width, item);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),

        /// BOTTOM NAVBAR
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
      ),
    );
  }

  String _mapStatus(String? statusId) {
    if (statusId == "1" || statusId == "2") return "Approve";
    if (statusId == "3") return "Rejected";
    return "Pending";
  }

  /// PURCHASE REQUEST CARD
  Widget prCard(BuildContext context, double width, PrData prData) {
    final status = _mapStatus(prData.master.status);
    final id = prData.master.no;
    final dept = "Department: ${prData.master.department}";
    final date = "Date: ${prData.master.reqDate}";

    Color statusColor;
    Color bgColor;

    switch (status) {
      case "Approve":
        statusColor = Colors.white;
        bgColor = const Color(0xFF0F8C2A);
        break;

      case "Rejected":
        statusColor = Colors.white;
        bgColor = const Color(0xFFAD0F14);
        break;

      default:
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
              /// ICON
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

              /// TEXT
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
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS BADGE
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
                    department: prData.master.department,
                    status: status,
                    prFullData: prData,
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
