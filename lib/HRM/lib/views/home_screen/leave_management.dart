import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'leave_application.dart';
import 'permission_form.dart';

enum LeaveManagementMode {
  selection,
  leaveDashboard,
  leaveForm,
  permissionDashboard,
  permissionForm,
}

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  LeaveManagementMode _currentMode = LeaveManagementMode.selection;
  int selectedTab = 0; // 0 = Summary, 1 = History
  List<dynamic> leaveHistoryData = [];
  List<dynamic> permissionHistoryData = [];
  Map<String, dynamic>? permissionSummary;
  bool isLoading = false;
  bool isBalanceLoading = false;

  // Static list structure matching original design
  List<Map<String, dynamic>> leaveBalanceData = [
    {
      "type": "Casual",
      "taken": 0,
      "total": 12,
      "balance": "12/12",
      "gradient": [const Color(0xFFF5F5F5), const Color(0xFFD4D6FF)],
      "progressColor": const Color(0xff8388FF),
      "titleColor": const Color(0xff1B2C61),
    },
    {
      "type": "Sick",
      "taken": 0,
      "total": 12,
      "balance": "12/12",
      "gradient": [const Color(0xFFF5F5F5), const Color(0xFFD4FEFF)],
      "progressColor": const Color(0xff59FAFF),
      "titleColor": const Color(0xff1B2C61),
    },
    {
      "type": "Earned",
      "taken": 0,
      "total": 12,
      "balance": "12/12",
      "gradient": [const Color(0xFFF5F5F5), const Color(0xFFF4D4FF)],
      "progressColor": const Color(0xffD679F8),
      "titleColor": const Color(0xff1B2C61),
    },
    {
      "type": "Maternity",
      "taken": 0,
      "total": 12,
      "balance": "12/12",
      "gradient": [const Color(0xFFFFF5F5), const Color(0xFFFFD4D4)],
      "progressColor": const Color(0xFFFB6065),
    },
    {
      "type": "Unpaid",
      "taken": 0,
      "total": null,
      "balance": "-/-",
      "gradient": [const Color(0xFFF5FFF5), const Color(0xFFD4FFD4)],
      "progressColor": const Color(0xFF26A69A),
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchLeaveSummary();
  }

  Future<void> _fetchLeaveSummary() async {
    if (!mounted) return;
    setState(() => isBalanceLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      // âœ… PRIMARY UID: Use login_cus_id as requested for leave history
      final String uid =
          prefs.getString('login_cus_id') ??
          "54";
      final String token = prefs.getString('token') ?? "";

      final String deviceId = prefs.getString('device_id') ?? "123456";
      final String lt = prefs.getDouble('lat')?.toString() ?? "145";
      final String ln = prefs.getDouble('lng')?.toString() ?? "145";

      final response = await http
          .post(
            Uri.parse("https://erpsmart.in/total/api/m_api/"),
            body: {
              "cid": prefs.getString('cid') ?? prefs.getString('cid_str') ?? "21472147",
              "device_id": deviceId,
              "lt": lt,
              "ln": ln,
              "type": "2051",
              "uid": uid,
              "id": uid,
              if (token.isNotEmpty) "token": token,
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        debugPrint("API Response (Leave Summary): ${response.body}");
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          List<dynamic> apiList = data['leave_summary'] ?? [];
          setState(() {
            for (var staticItem in leaveBalanceData) {
              String staticType = staticItem['type'].toString().toLowerCase();
              var apiItem = apiList.firstWhere((api) {
                String apiType = (api['leave_type'] ?? "")
                    .toString()
                    .toLowerCase();
                if (staticType == "earned")
                  return apiType.contains("earned") ||
                      apiType.contains("annual") ||
                      apiType.contains("al");
                if (staticType == "casual")
                  return apiType.contains("casual") || apiType.contains("cl");
                if (staticType == "sick")
                  return apiType.contains("medical") ||
                      apiType.contains("ml") ||
                      apiType.contains("sick");
                if (staticType == "maternity")
                  return apiType.contains("maternity");
                if (staticType == "unpaid")
                  return apiType.contains("unpaid") || apiType.contains("lop");
                return apiType.contains(staticType);
              }, orElse: () => null);

              if (apiItem != null) {
                int taken =
                    int.tryParse(
                      apiItem['leaves_taken_this_year']?.toString() ?? "0",
                    ) ??
                    0;
                int total =
                    int.tryParse(
                      apiItem['max_days_per_year']?.toString() ?? "12",
                    ) ??
                    12;
                staticItem['taken'] = taken;
                staticItem['total'] = total;
                staticItem['balance'] = "${total - taken}/$total";
              }
            }
          });
        }
      }
      await _fetchLeaveHistory();
    } catch (e) {
      debugPrint("Error fetching leave summary: $e");
    } finally {
      if (mounted) setState(() => isBalanceLoading = false);
    }
  }

  Future<void> _fetchLeaveHistory() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String uid =
          prefs.getString('login_cus_id') ??
          "54";
      final String token = prefs.getString('token') ?? "";

      final String deviceId = prefs.getString('device_id') ?? "123456";
      final String lt = prefs.getDouble('lat')?.toString() ?? "145";
      final String ln = prefs.getDouble('lng')?.toString() ?? "145";

      final response = await http
          .post(
            Uri.parse("https://erpsmart.in/total/api/m_api/"),
            body: {
              "cid": prefs.getString('cid') ?? prefs.getString('cid_str') ?? "21472147",
              "device_id": deviceId,
              "lt": lt,
              "ln": ln,
              "type": "2052",
              "uid": uid,
              "id": uid,
              if (token.isNotEmpty) "token": token,
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        debugPrint("API Response (Leave History): ${response.body}");
        final data = jsonDecode(response.body);
        List<dynamic> fetchedList =
            data['leave_applications'] ?? data['data'] ?? [];
        setState(() {
          leaveHistoryData = fetchedList;
          _calculateBalances();
        });
      }
    } catch (e) {
      debugPrint("Error fetching history: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _fetchPermissionHistory() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String uid =
          prefs.getString('login_cus_id') ??
          "54";
      final String token = prefs.getString('token') ?? "";

      final String deviceId = prefs.getString('device_id') ?? "123456";
      final String lt = prefs.getDouble('lat')?.toString() ?? "145";
      final String ln = prefs.getDouble('lng')?.toString() ?? "145";

      final response = await http
          .post(
            Uri.parse("https://erpsmart.in/total/api/m_api/"),
            body: {
              "cid": prefs.getString('cid') ?? prefs.getString('cid_str') ?? "21472147",
              "device_id": deviceId,
              "lt": lt,
              "ln": ln,
              "type": "2078",
              "uid": uid,
              "id": uid,
              if (token.isNotEmpty) "token": token,
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        debugPrint("API Response (Permission History): ${response.body}");
        final data = jsonDecode(response.body);

        List<dynamic> fetchedList =
            data['data'] ?? data['permission_applications'] ?? [];
        setState(() {
          permissionHistoryData = fetchedList;
          permissionSummary = data['summary'];

          // Re-initialize permission summary items if we have summary data
          if (permissionSummary != null) {
            _updatePermissionBalances(data);
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching permission history: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _updatePermissionBalances(Map<String, dynamic> apiResponse) {
    List<dynamic> fetchedList = apiResponse['data'] ?? [];
    var summary = apiResponse['summary'];

    // --- MANUAL CALCULATION FOR ACCURACY ---
    int approved = 0;
    int pending = 0;
    int rejected = 0;

    for (var item in fetchedList) {
      String status = (item['status'] ?? "").toString().toLowerCase();
      if (status == "1" ||
          status == "approved" ||
          status == "accept" ||
          status.contains("approv")) {
        approved++;
      } else if (status == "2" || status == "rejected" || status == "reject") {
        rejected++;
      } else {
        pending++;
      }
    }

    // Use API summary values if they are higher (server-side total might include archived records)
    if (summary != null) {
      approved =
          (int.tryParse(summary['approved']?.toString() ?? "0") ?? 0) > approved
          ? int.parse(summary['approved'].toString())
          : approved;
      pending =
          (int.tryParse(summary['pending']?.toString() ?? "0") ?? 0) > pending
          ? int.parse(summary['pending'].toString())
          : pending;
      rejected =
          (int.tryParse(summary['rejected']?.toString() ?? "0") ?? 0) > rejected
          ? int.parse(summary['rejected'].toString())
          : rejected;
    }

    int totalVisible = approved + pending + rejected;
    if (totalVisible == 0) totalVisible = 1;

    // We can use the first data item to get monthly balance if available
    var firstItem = fetchedList.firstOrNull;

    setState(() {
      permissionBalanceData = [
        {
          "type": "Approved",
          "count": approved,
          "total": totalVisible,
          "gradient": [const Color(0xFFF5F5F5), const Color(0xFFD4FEFF)],
          "progressColor": Colors.green,
        },
        {
          "type": "Pending",
          "count": pending,
          "total": totalVisible,
          "gradient": [const Color(0xFFFFF5F5), const Color(0xFFFFD4D4)],
          "progressColor": Colors.orange,
        },
        {
          "type": "Rejected",
          "count": rejected,
          "total": totalVisible,
          "gradient": [const Color(0xFFF5FFF5), const Color(0xFFD4FFD4)],
          "progressColor": Colors.red,
        },
        {
          "type": "Monthly Bal",
          "count":
              int.tryParse(firstItem?['per_taken']?.toString() ?? "0") ?? 0,
          "total":
              int.tryParse(firstItem?['Max_month']?.toString() ?? "2") ?? 2,
          "balance":
              "${firstItem?['bal_permission'] ?? '0'}/${firstItem?['Max_month'] ?? '2'}",
          "gradient": [const Color(0xFFF5F5F5), const Color(0xFFF4D4FF)],
          "progressColor": const Color(0xffD679F8),
        },
      ];
    });
  }

  List<Map<String, dynamic>> permissionBalanceData = [
    {
      "type": "Approved",
      "count": 0,
      "total": 1,
      "gradient": [const Color(0xFFF5F5F5), const Color(0xFFD4FEFF)],
      "progressColor": Colors.green,
    },
    {
      "type": "Pending",
      "count": 0,
      "total": 1,
      "gradient": [const Color(0xFFFFF5F5), const Color(0xFFFFD4D4)],
      "progressColor": Colors.orange,
    },
    {
      "type": "Rejected",
      "count": 0,
      "total": 1,
      "gradient": [const Color(0xFFF5FFF5), const Color(0xFFD4FFD4)],
      "progressColor": Colors.red,
    },
    {
      "type": "Monthly Bal",
      "count": 0,
      "total": 2,
      "gradient": [const Color(0xFFF5F5F5), const Color(0xFFF4D4FF)],
      "progressColor": const Color(0xffD679F8),
    },
  ];

  void _calculateBalances() {
    for (var b in leaveBalanceData) b['taken'] = 0;
    for (var h in leaveHistoryData) {
      String status = (h['status'] ?? "0").toString().toLowerCase();
      // âœ… STRICT RULE: Only count approved leaves in balance
      bool isApproved =
          (status == "1" ||
          status == "accept" ||
          status == "approved" ||
          status.contains("approv"));
      if (!isApproved) continue;

      num days = 1;
      if (h['leave_taken'] != null &&
          h['leave_taken'].toString().isNotEmpty &&
          h['leave_taken'].toString() != "null") {
        days = num.tryParse(h['leave_taken'].toString()) ?? 1;
      } else if (h['total_days'] != null &&
          h['total_days'].toString().isNotEmpty &&
          h['total_days'].toString() != "null") {
        days = num.tryParse(h['total_days'].toString()) ?? 1;
      } else if (h['no_of_days'] != null &&
          h['no_of_days'].toString().isNotEmpty &&
          h['no_of_days'].toString() != "null") {
        days = num.tryParse(h['no_of_days'].toString()) ?? 1;
      }
      String type = (h['leave_type'] ?? "").toString().toLowerCase();

      for (var b in leaveBalanceData) {
        String bType = b['type'].toString().toLowerCase();
        bool match = false;
        if (bType == "earned")
          match = type.contains("privilege") || type.contains("earned");
        else if (bType == "casual")
          match = type.contains("casual");
        else if (bType == "sick")
          match = type.contains("medical") || type.contains("sick");
        else if (bType == "unpaid")
          match = type.contains("unpaid") || type.contains("lop");
        else
          match = type.contains(bType);

        if (match) {
          b['taken'] = (b['taken'] as num) + days;
          break;
        }
      }
    }
    for (var b in leaveBalanceData) {
      num taken = b['taken'];
      if (b['type'].toString().toLowerCase() == "unpaid")
        b['balance'] = "$taken/-";
      else
        b['balance'] = "${(b['total'] ?? 12) - taken}/${b['total'] ?? 12}";
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "Leave Management";
    if (_currentMode == LeaveManagementMode.leaveDashboard)
      title = "Leave Request";
    if (_currentMode == LeaveManagementMode.leaveForm) title = "Apply Leave";
    if (_currentMode == LeaveManagementMode.permissionDashboard)
      title = "Permission Request";
    if (_currentMode == LeaveManagementMode.permissionForm)
      title = "Apply Permission";

    bool isPermission =
        _currentMode == LeaveManagementMode.permissionDashboard ||
        _currentMode == LeaveManagementMode.permissionForm;

    Color themeColor = isPermission
        ? const Color(0xFF5C6BC0)
        : const Color(0xff26A69A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (_currentMode == LeaveManagementMode.selection) {
              Navigator.pop(context);
            } else if (_currentMode == LeaveManagementMode.leaveForm) {
              setState(() => _currentMode = LeaveManagementMode.leaveDashboard);
            } else if (_currentMode == LeaveManagementMode.permissionForm) {
              setState(
                () => _currentMode = LeaveManagementMode.permissionDashboard,
              );
            } else {
              setState(() => _currentMode = LeaveManagementMode.selection);
            }
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentMode) {
      case LeaveManagementMode.selection:
        return _buildSelectionMode();
      case LeaveManagementMode.leaveDashboard:
        return RefreshIndicator(
          onRefresh: () async {
            await _fetchLeaveSummary();
            await _fetchLeaveHistory();
          },
          color: const Color(0xff26A69A),
          child: _buildDashboardMode(isLeave: true),
        );
      case LeaveManagementMode.permissionDashboard:
        return RefreshIndicator(
          onRefresh: () async {
            await _fetchPermissionHistory();
          },
          color: const Color(0xFF5C6BC0),
          child: _buildDashboardMode(isLeave: false),
        );
      case LeaveManagementMode.leaveForm:
        return const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: LeaveForm(),
        );
      case LeaveManagementMode.permissionForm:
        return const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: PermissionForm(),
        );
    }
  }

  Widget _buildSelectionMode() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Welcome back!",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B2C61),
            ),
          ),
          Text(
            "Select a category to manage your requests.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          _selectionCardResponsive(
            "Leave Request",
            "Total Leave: 12 Days Yearly",
            "Manage balance & history",
            Icons.event_note_rounded,
            const Color.fromRGBO(38, 166, 154, 1),
            () {
              setState(() {
                _currentMode = LeaveManagementMode.leaveDashboard;
                selectedTab = 0; // Reset to Summary tab
              });
              _fetchLeaveSummary();
            },
          ),
          const SizedBox(height: 20),
          _selectionCardResponsive(
            "Permission Request",
            "Total Permission: 2/Month",
            "Apply personal permission",
            Icons.more_time_rounded,
            const Color(0xFF5C6BC0),
            () {
              setState(() {
                _currentMode = LeaveManagementMode.permissionDashboard;
                selectedTab = 0; // Reset to Summary tab
              });
              _fetchPermissionHistory();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _selectionCardResponsive(
    String title,
    String subtitle,
    String desc,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -30,
                right: -30,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: color.withValues(alpha: 0.04),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B2C61),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 20,
                right: 20,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: color,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardMode({required bool isLeave}) {
    Color themeColor = isLeave
        ? const Color(0xff26A69A)
        : const Color(0xFF5C6BC0);
    return Column(
      children: [
        _buildTabs(themeColor),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                selectedTab == 0
                    ? (isBalanceLoading || (isLoading && !isLeave))
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildSummaryGrid(isLeave: isLeave)
                    : (isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _buildHistoryList(isLeave: isLeave)),
                const SizedBox(height: 20),
                _buildHolidayListCard(),
                const SizedBox(height: 20),
                _buildApplyButton(isLeave, themeColor),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tabItem(0, "Summary", themeColor),
            _tabItem(1, "History", themeColor),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(int index, String label, Color themeColor) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? themeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGrid({required bool isLeave}) {
    List<Map<String, dynamic>> dataList = isLeave
        ? leaveBalanceData
        : permissionBalanceData;
    return Column(
      children: [
        const SizedBox(height: 10),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: dataList.length,
          itemBuilder: (context, index) =>
              _balanceCard(dataList[index], isLeave: isLeave),
        ),
      ],
    );
  }

  Widget _balanceCard(Map<String, dynamic> data, {required bool isLeave}) {
    num count = (data['taken'] ?? data['count'] ?? 0);
    num total = (data['total'] ?? 1);
    double progress = (total > 0) ? (count / total) : 0;
    if (progress > 1.0) progress = 1.0;

    String balanceText =
        data['balance'] ??
        (isLeave ? "${total - count}/$total" : "$count/$total");

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data['gradient'] ?? [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: data['progressColor'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['type'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B2C61),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _balanceInfoRow(isLeave ? "Taken" : "Count", ": $count"),
                const SizedBox(height: 4),
                _balanceInfoRow(
                  isLeave ? "Balance" : "Status",
                  ": $balanceText",
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 8,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: data['progressColor'],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1B2C61),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B2C61),
          ),
        ),
      ],
    );
  }

  Widget _buildHolidayListCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(
            0xFFFFB7B7,
          ).withValues(alpha: 0.6), // Light red/pink
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: Color(0xFF1B2C61),
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Holiday List",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2C61),
                ),
              ),
            ),
            const Icon(Icons.arrow_right, color: Color(0xFF1B2C61)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList({required bool isLeave}) {
    List<dynamic> dataToUse = isLeave
        ? leaveHistoryData
        : permissionHistoryData;
    if (dataToUse.isEmpty) {
      // Re-trigger fetch if empty and dashboard just loaded
      if (isLeave) {
        _fetchLeaveHistory();
      } else {
        _fetchPermissionHistory();
      }
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text("No records found"),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: dataToUse.length,
      itemBuilder: (context, index) => _historyCard(dataToUse[index], isLeave),
    );
  }

  Widget _historyCard(Map<String, dynamic> item, bool isLeave) {
    String status = (item['status'] ?? "0").toString().toLowerCase();
    Color statusColor = Colors.orange;
    String statusText = "Pending";

    bool isApproved =
        (status == "1" ||
        status == "accept" ||
        status == "approved" ||
        status.contains("approv"));
    bool isRejected =
        (status == "2" ||
        status == "reject" ||
        status == "rejected" ||
        status.contains("reject"));

    if (isApproved) {
      statusColor = Colors.green;
      statusText = "Approved";
    } else if (isRejected) {
      statusColor = Colors.red;
      statusText = "Rejected";
    }

    String title = isLeave
        ? (item['leave_type']?.toString().isNotEmpty == true
              ? item['leave_type']
              : "Leave Request")
        : (item['permission_type']?.toString().isNotEmpty == true
              ? item['permission_type']
              : "Permission Request");
    String dateRange = isLeave
        ? "${item['leave_start_date']} to ${item['leave_end_date']}"
        : "${item['permission_date'] ?? item['app_date'] ?? ""} (${item['start_time']} - ${item['end_time'] ?? item['end_date'] ?? ""})";

    String durationLabel = isLeave
        ? "(${item['total_days'] ?? item['no_of_days'] ?? item['leave_taken'] ?? "0"} Days)"
        : ""; // Permissions are usually hourly
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title $durationLabel",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B2C61),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateRange,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              statusText,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(bool isLeave, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () => setState(
            () => _currentMode = isLeave
                ? LeaveManagementMode.leaveForm
                : LeaveManagementMode.permissionForm,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            isLeave ? "Apply for Leave" : "Apply for Permission",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
