import 'package:flutter/material.dart';
import 'package:purchase_erp/dashboard.dart';
import 'package:purchase_erp/widgets/bottom_nav.dart';
import 'package:purchase_erp/Request%20Approvals/request_approval_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RequestApprovals extends StatefulWidget {
  // Static Cache to store data for instant loading
  static List<dynamic> cachedApprovals = [];
  static Map<String, String> cachedUserMap = {};
  static bool hasCachedData = false;
  static bool isPreFetching = false;

  static const String apiUrl = 'https://erpsmart.in/total/api/m_api/';

  const RequestApprovals({super.key});

  // Pre-fetch method to be called from Dashboard or background
  static Future<void> preFetch() async {
    if (isPreFetching) return;
    isPreFetching = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cid = prefs.getString('cid') ?? '44555666';

      // Fetch users and PR data in parallel
      final results = await Future.wait([
        http.post(
          Uri.parse(apiUrl),
          body: {
            'type': '5001',
            'cid': cid,
            'device_id': '123',
            'ln': '123',
            'lt': '34',
          },
        ),
        http.post(
          Uri.parse(apiUrl),
          body: {
            'type': '4006',
            'cid': cid,
            'device_id': '123',
            'ln': '123',
            'lt': '34',
          },
        ),
      ]);

      final userResponse = results[0];
      final prResponse = results[1];

      if (userResponse.statusCode == 200) {
        final jsonResponse = json.decode(userResponse.body);
        if (jsonResponse['error'] == false ||
            jsonResponse['error']?.toString().toLowerCase() == 'false') {
          final users = jsonResponse['data'];
          cachedUserMap.clear();
          for (var user in users) {
            cachedUserMap[user['id'].toString()] = user['name'].toString();
          }
        }
      }

      if (prResponse.statusCode == 200) {
        final jsonResponse = json.decode(prResponse.body);
        if (jsonResponse['error'] == false ||
            jsonResponse['error']?.toString().toLowerCase() == 'false') {
          cachedApprovals = jsonResponse['data'] ?? [];
          hasCachedData = true;
        }
      }
    } catch (e) {
      debugPrint("Pre-fetch error: $e");
    } finally {
      isPreFetching = false;
    }
  }

  @override
  State<RequestApprovals> createState() => _RequestApprovalsState();
}

class _RequestApprovalsState extends State<RequestApprovals> {
  List<dynamic> approvals = List.from(RequestApprovals.cachedApprovals);
  Map<String, String> userMap = Map.from(RequestApprovals.cachedUserMap);
  bool isLoading = !RequestApprovals.hasCachedData; // Only load if no cache
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // If we have no data, show loader
    if (approvals.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
    }

    // Refresh data in background
    try {
      await Future.wait([fetchUsers(), fetchPRData()]);
    } catch (e) {
      debugPrint("Load data error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchPRData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cid = prefs.getString('cid') ?? '44555666';

      final response = await http.post(
        Uri.parse(RequestApprovals.apiUrl),
        body: {
          'type': '4006',
          'cid': cid,
          'device_id': '123',
          'ln': '123',
          'lt': '34',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['error'] == false ||
            jsonResponse['error']?.toString().toLowerCase() == 'false') {
          if (!mounted) return;
          final newData = jsonResponse['data'] ?? [];
          setState(() {
            approvals = newData;
            RequestApprovals.cachedApprovals = newData;
            RequestApprovals.hasCachedData = true;
          });
        } else {
          if (approvals.isEmpty) {
            if (!mounted) return;
            setState(() {
              errorMessage = jsonResponse['message'] ?? 'Failed to fetch data';
            });
          }
        }
      } else {
        if (approvals.isEmpty) {
          if (!mounted) return;
          setState(() {
            errorMessage = 'Server error: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (approvals.isEmpty) {
        if (!mounted) return;
        setState(() {
          errorMessage = 'Network error: $e';
        });
      }
    }
  }

  Future<void> fetchUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cid = prefs.getString('cid') ?? '44555666';

      final response = await http.post(
        Uri.parse(RequestApprovals.apiUrl),
        body: {
          'type': '5001',
          'cid': cid,
          'device_id': '123',
          'ln': '123',
          'lt': '34',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['error'] == false ||
            jsonResponse['error']?.toString().toLowerCase() == 'false') {
          final users = jsonResponse['data'];

          userMap.clear();
          for (var user in users) {
            final id = user['id'].toString();
            final name = user['name'].toString();
            userMap[id] = name;
          }
          RequestApprovals.cachedUserMap = Map.from(userMap);
        }
      }
    } catch (e) {
      debugPrint("User fetch error: $e");
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
        backgroundColor: Colors.grey[200],

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
            "Request Approvals",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),

        /// BODY
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            children: [
              /// STATUS CARDS (kept as static for now - can be made dynamic later)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statCard(
                    width,
                    "Total Pending",
                    approvals.length.toString(),
                    const Color(0xffA29329),
                    Icons.description_outlined,
                  ),
                  statCard(
                    width,
                    "High Priority",
                    "1", // You can compute dynamically if priority field is used
                    const Color(0xff0F6229),
                    Icons.trending_up,
                  ),
                  statCard(
                    width,
                    "Total QTY",
                    _calculateTotalQty().toString(),
                    const Color(0xff1B607E),
                    Icons.assignment_outlined,
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),

              /// LIST OF APPROVALS
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: fetchPRData,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : approvals.isEmpty
                    ? const Center(child: Text('No pending requests'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: approvals.length,
                        itemBuilder: (context, index) {
                          final item = approvals[index];
                          final master = item['master'] ?? {};
                          final itemsList = item['items'] ?? [];

                          // Use first item for display as per sample structure
                          final displayItem = itemsList.isNotEmpty
                              ? itemsList[0]
                              : {};

                          final prNumber = master['no']?.toString() ?? 'N/A';
                          final qty =
                              master['current_order_quantity']?.toString() ??
                              displayItem['current_order_quantity']
                                  ?.toString() ??
                              master['quantity_required']?.toString() ??
                              displayItem['quantity_required']?.toString() ??
                              '0';
                          final title =
                              displayItem['product_name']?.toString() ??
                              displayItem['item_description']?.toString() ??
                              'Purchase Request';
                          final department =
                              master['department']?.toString() ?? 'N/A';
                          final requestedByRaw =
                              master['requested_by']?.toString() ?? 'N/A';

                          final requestedBy =
                              (int.tryParse(requestedByRaw) != null &&
                                  userMap.containsKey(requestedByRaw))
                              ? userMap[requestedByRaw]!
                              : requestedByRaw;

                          return Column(
                            children: [
                              ApprovalCard(
                                prNumber: prNumber,
                                qty: qty,
                                title: title,
                                department: department,
                                requestedBy: requestedBy,
                                masterData: master,
                                itemsData: itemsList,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),

        /// BOTTOM NAV
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
      ),
    );
  }

  int _calculateTotalQty() {
    int total = 0;
    for (var item in approvals) {
      final master = item['master'] ?? {};
      final itemsList = item['items'] ?? [];
      final displayItem = itemsList.isNotEmpty ? itemsList[0] : {};

      final qtyStr =
          master['current_order_quantity']?.toString() ??
          displayItem['current_order_quantity']?.toString() ??
          master['quantity_required']?.toString() ??
          displayItem['quantity_required']?.toString() ??
          '0';
      total += int.tryParse(qtyStr) ?? 0;
    }
    return total;
  }

  /// STAT CARD WIDGET (unchanged)
  Widget statCard(
    double width,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: width * 0.29,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ApprovalCard extends StatelessWidget {
  final String prNumber;
  final String qty;
  final String title;
  final String department;
  final String requestedBy;
  final Map<String, dynamic> masterData;
  final List<dynamic> itemsData;

  const ApprovalCard({
    super.key,
    required this.prNumber,
    required this.qty,
    required this.title,
    required this.department,
    required this.requestedBy,
    required this.masterData,
    required this.itemsData,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PR + AMOUNT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                "QTY : $qty",
                style: const TextStyle(
                  color: Color(0xff3F1299),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            department,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 12),

          Text(
            "Request By : $requestedBy",
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(height: 18),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestApprovalDetailsScreen(
                    masterData: masterData,
                    itemsData: itemsData,
                    requestedByName: requestedBy,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF26A69A), width: 1.2),
              ),
              child: const Text(
                "View Details",
                style: TextStyle(
                  color: Color(0xFF26A69A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
