import 'package:flutter/material.dart';
import 'package:purchase_erp/dashboard.dart';
import 'package:purchase_erp/widgets/bottom_nav.dart';
import 'package:purchase_erp/purchase_orders/po_opens.dart';
import 'package:purchase_erp/purchase_orders/create_purchase_order.dart';

class PurchaseOrdersScreen extends StatefulWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  State<PurchaseOrdersScreen> createState() => _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends State<PurchaseOrdersScreen> {
  String selectedFilter = "All";

  // Sample data for PO list
  final List<Map<String, String>> poData = [
    {
      "id": "PO001",
      "supplier": "ABC Traders",
      "price": "₹45,000",
      "status": "Approved",
    },
    {
      "id": "PO002",
      "supplier": "XYZ Suppliers",
      "price": "₹32,000",
      "status": "Rejected",
    },
    {
      "id": "PO003",
      "supplier": "Tech Solutions",
      "price": "₹78,000",
      "status": "Approved",
    },
    {
      "id": "PO004",
      "supplier": "Office Mart",
      "price": "₹12,500",
      "status": "Pending",
    },
    {
      "id": "PO005",
      "supplier": "Global Corp",
      "price": "₹95,000",
      "status": "Approved",
    },
    {
      "id": "PO006",
      "supplier": "Unity Prime",
      "price": "₹28,400",
      "status": "Pending",
    },
    {
      "id": "PO007",
      "supplier": "Build It",
      "price": "₹15,000",
      "status": "Rejected",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Filter data based on selected status
    final filteredData = selectedFilter == "All"
        ? poData
        : poData.where((po) => po["status"] == selectedFilter).toList();

    // Calculate dynamic stats
    final totalPOs = poData.length;
    final approvedPOs = poData.where((po) => po["status"] == "Approved").length;
    final rejectedPOs = poData.where((po) => po["status"] == "Rejected").length;

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF26A69A), Color(0xFF26A69A)],
              ),
            ),
          ),
          title: const Text(
            "Purchase Orders",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
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
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePurchaseOrderScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  "New",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 3),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 10),
          child: Column(
            children: [
              /// SEARCH BAR
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
              const SizedBox(height: 16),

              /// STATS GRID
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statCard(
                        width,
                        "Total POs",
                        totalPOs.toString(),
                        const Color(0xff9E8B1E),
                        Icons.inventory_2,
                      ),
                      statCard(
                        width,
                        "Approved",
                        approvedPOs.toString(),
                        const Color(0xff088C29),
                        Icons.unarchive,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statCard(
                        width,
                        "Rejected",
                        rejectedPOs.toString(),
                        const Color(0xffAF1616),
                        Icons.inventory,
                      ),
                      statCard(
                        width,
                        "Total Value",
                        "₹702,000",
                        const Color(0xffB9187D),
                        Icons.account_balance_wallet,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

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

              /// PO LIST
              Expanded(
                child: filteredData.isEmpty
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
                              "No $selectedFilter PO found",
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
                          return OrderCard(
                            item["id"]!,
                            item["supplier"]!,
                            item["price"]!,
                            item["status"]!,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// STAT CARD WIDGET
  Widget statCard(
    double width,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: width * 0.44,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String supplier;
  final String price;
  final String status;

  const OrderCard(
    this.orderId,
    this.supplier,
    this.price,
    this.status, {
    super.key,
  });

  Color statusColor() {
    switch (status) {
      case "Approved":
        return const Color(0xff088C29);
      case "Rejected":
        return const Color(0xffAF1616);
      case "Pending":
        return const Color(0xffC59B13);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        if (orderId == "PO001") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PODetailsScreen()),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.035),
        padding: EdgeInsets.all(width * 0.04),
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
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF26A69A),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Supplier: $supplier",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
