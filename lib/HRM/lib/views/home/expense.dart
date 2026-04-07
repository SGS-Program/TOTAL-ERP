import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrm/models/expense_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import 'add_expense.dart';

class ExpenseManagementScreen extends StatefulWidget {
  const ExpenseManagementScreen({super.key});

  @override
  State<ExpenseManagementScreen> createState() =>
      _ExpenseManagementScreenState();
}

class _ExpenseManagementScreenState extends State<ExpenseManagementScreen> {
  bool _isLoading = true;
  List<dynamic> _expenses = [];
  String _error = "";

  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'Total';
  bool _isDateFilterActive = false;
  Map<String, dynamic> _apiSummary = {};

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF26A69A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF26A69A),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      bool needsFetch =
          picked.month != _selectedDate.month ||
          picked.year != _selectedDate.year;

      setState(() {
        _selectedDate = picked;
        _isDateFilterActive = true;
      });

      if (needsFetch) {
        _fetchExpenses();
      }
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    DateTime tempDate = _selectedDate;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => setStateDialog(
                      () => tempDate = DateTime(
                        tempDate.year - 1,
                        tempDate.month,
                      ),
                    ),
                  ),
                  Text(
                    "${tempDate.year}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => setStateDialog(
                      () => tempDate = DateTime(
                        tempDate.year + 1,
                        tempDate.month,
                      ),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 300,
                height: 250,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final monthIndex = index + 1;
                    final isSelected =
                        tempDate.year == _selectedDate.year &&
                        monthIndex == _selectedDate.month;
                    return InkWell(
                      onTap: () => Navigator.pop(
                        context,
                        DateTime(tempDate.year, monthIndex),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF26A69A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF26A69A)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          [
                            "Jan",
                            "Feb",
                            "Mar",
                            "Apr",
                            "May",
                            "Jun",
                            "Jul",
                            "Aug",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Dec",
                          ][index],
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    ).then((picked) {
      if (picked != null && picked is DateTime) {
        if (picked.month != _selectedDate.month ||
            picked.year != _selectedDate.year) {
          setState(() {
            _selectedDate = picked;
            _expenses = []; // Clear current list
            _isLoading = true;
            _isDateFilterActive = false; // Reset to Month View
          });
          _fetchExpenses();
        }
      }
    });
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      // Try last known first (instant)
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;

      // Fast current position (low accuracy, short timeout)
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 3),
      );
    } catch (e) {
      print("Location Fetch Error: $e");
      return null;
    }
  }

  Future<void> _fetchExpenses() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final uid =
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getString('login_cus_id') ??
          prefs.getInt('uid')?.toString() ??
          "";
      final cid = prefs.getString('cid') ?? "";

      final deviceId = prefs.getString('device_id') ?? "123456";

      final position = await _determinePosition();
      final lat = position?.latitude.toString() ?? "0.0";
      final lng = position?.longitude.toString() ?? "0.0";

      final response = await ExpenseRepo.getExpenses(
        cid: cid,
        uid: uid,
        month: _selectedDate.month.toString().padLeft(2, '0'),
        year: _selectedDate.year.toString(),
        deviceId: deviceId,
        lat: lat,
        lng: lng,
        token: prefs.getString('token'),
      );

      if (!mounted) return;

      if (response["success"] == true ||
          response["error"] == false ||
          response["error"] == "false") {
        final data = response["data"];

        List<dynamic> expenseList = [];

        if (data is Map) {
          if (data["expenses"] is List) {
            expenseList = data["expenses"];
          } else if (data["expense_list"] is List) {
            expenseList = data["expense_list"];
          }
        } else if (data is List) {
          expenseList = data;
        }

        setState(() {
          _expenses = expenseList;
          if (_expenses.isNotEmpty) {
            debugPrint("EXPENSE_DATA_SAMPLE => ${_expenses[0]}");
          }
          // Safely access summary from either data (if map) or response directly
          _apiSummary = {};
          if (data is Map && data["summary"] != null) {
            _apiSummary = Map<String, dynamic>.from(data["summary"]);
          } else if (response["summary"] != null) {
            _apiSummary = Map<String, dynamic>.from(response["summary"]);
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _error =
              response["message"] ??
              response["error_msg"] ??
              "Failed to fetch expenses";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Error: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    // 1. Apply Date Filter if Active
    List<dynamic> dateFilteredList = _expenses;
    if (_isDateFilterActive) {
      String targetDate =
          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
      dateFilteredList = _expenses.where((item) {
        String itemDate = item["expense_date"] ?? "";
        return itemDate == targetDate;
      }).toList();
    }

    // 2. Determine Summary
    double total = 0;
    double approved = 0;
    double pending = 0;

    if (_apiSummary.isNotEmpty && !_isDateFilterActive) {
      // Use API provided summary for total view if available
      String totalStr = _apiSummary["total_amount"]?.toString() ?? "0";
      total = double.tryParse(totalStr.replaceAll(",", "")) ?? 0;
    }

    // Default to local calculation for accuracy when filtering
    double localTotal = 0;
    double localApproved = 0;
    double localPending = 0;

    for (var item in dateFilteredList) {
      String amountStr = item["amount"]?.toString() ?? "0";
      double claimAmt = double.tryParse(amountStr.replaceAll(",", "")) ?? 0;
      localTotal += claimAmt;

      String status = item["status"]?.toString().toLowerCase() ?? "0";
      String approvedStr =
          (item['approved_amt'] ?? item['approved_amount'])?.toString() ?? "0";
      double apprAmt = double.tryParse(approvedStr.replaceAll(",", "")) ?? 0;

      // Handle legacy data where status is 1 but approved_amt is 0
      if ((status == "1" || status.contains("approv")) && apprAmt == 0) {
        apprAmt = claimAmt;
      }

      localApproved += apprAmt;

      // Pending is what remains to be approved for non-rejected items
      if (status != "2" && !status.contains("reject")) {
        localPending += (claimAmt - apprAmt);
      }
    }

    total = localTotal;
    approved = localApproved;
    pending = localPending;

    final currentSummary = {
      "total": total,
      "approved": approved,
      "pending": pending,
      "balance": total - approved,
    };

    // 3. Filter by Status Tab
    List<dynamic> finalDisplayList = dateFilteredList.where((item) {
      if (_selectedFilter == 'Total') return true;

      String statusRaw = item["status"]?.toString().toLowerCase() ?? "0";
      double claim =
          double.tryParse(
            item['amount']?.toString().replaceAll(",", "") ?? "0",
          ) ??
          0;
      double appr =
          double.tryParse(
            (item['approved_amt'] ?? item['approved_amount'])
                    ?.toString()
                    .replaceAll(",", "") ??
                "0",
          ) ??
          0;

      if ((statusRaw == "1" || statusRaw.contains("approv")) && appr == 0) {
        appr = claim;
      }

      if (_selectedFilter == 'Approved') {
        return appr > 0;
      }
      if (_selectedFilter == 'Pending') {
        // Show if not rejected and not fully approved
        return statusRaw != "2" &&
            !statusRaw.contains("reject") &&
            appr < claim;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, size: 20),
            tooltip: "Filter by Date",
          ),
          InkWell(
            onTap: () => _selectMonth(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  if (!_isDateFilterActive) ...[
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][_selectedDate.month - 1]} ${_selectedDate.year}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ] else ...[
                    Text(
                      "${_selectedDate.day.toString().padLeft(2, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.year}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isDateFilterActive = false;
                        });
                      },
                      tooltip: "Clear Date Filter",
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        title: Text(
          "Expense Management",
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 22 : 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 160,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpense()),
            );
            if (result == true) {
              _fetchExpenses();
            }
          },
          label: Text(
            "Add Expense",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 22),
          backgroundColor: const Color(0xFF26A69A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExpenses,
        color: const Color(0xFF26A69A),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF26A69A)),
              )
            : _error.isNotEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Center(child: Text(_error)),
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ==================== SUMMARY CARDS ====================
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedFilter = 'Total'),
                            child: _buildSummaryCard(
                              "Total",
                              "\u20B9 ${currentSummary['total']}",
                              const Color(0xFF3F51B5), // Blue
                              _selectedFilter == 'Total',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedFilter = 'Approved'),
                            child: _buildSummaryCard(
                              "Approved",
                              "\u20B9 ${currentSummary['approved']}",
                              const Color(0xFF4CAF50), // Green
                              _selectedFilter == 'Approved',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () =>
                                setState(() => _selectedFilter = 'Pending'),
                            child: _buildSummaryCard(
                              "Pending",
                              "\u20B9 ${currentSummary['pending']}",
                              const Color(0xFFFF9800), // Orange
                              _selectedFilter == 'Pending',
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ==================== NEW: APPROVAL DETAIL HIGHLIGHT ====================
                    if (_selectedFilter == 'Approved') ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_outlined,
                                  color: Color(0xFF4CAF50),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Approval Detailed Stats",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _detailStat(
                                  "Applied Amt",
                                  "\u20B9 ${currentSummary['total']}",
                                ),
                                _detailStat(
                                  "Approved Amt",
                                  "\u20B9 ${currentSummary['approved']}",
                                ),
                                _detailStat(
                                  "Balance",
                                  "\u20B9 ${currentSummary['balance']?.toStringAsFixed(2)}",
                                  isBold: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    if (finalDisplayList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          "No expenses found for this category",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: finalDisplayList.length,
                        itemBuilder: (context, index) {
                          final item = finalDisplayList[index];
                          // Map properties
                          // Prioritize showing the specific purpose/category selected by user
                          String title =
                              item["expense_category"] ??
                              item["purpose"] ??
                              item["expense_type"] ??
                              item["description"] ??
                              "Miscellaneous";

                          if (title.trim().isEmpty ||
                              title.toLowerCase() == "expense") {
                            title = "Miscellaneous";
                          }

                          // Normalize status to lowercase
                          String statusRaw =
                              item["status"]?.toString().toLowerCase() ?? "0";

                          String claimAmountStr =
                              item['amount']?.toString() ?? "0";
                          String approvedAmountStr =
                              item['approved_amt']?.toString() ??
                              item['approved_amount']?.toString() ??
                              "0";

                          // If it was already approved but approved_amt is missing/zero, assume it matches the claim
                          if ((statusRaw == "1" ||
                                  statusRaw.contains("approv")) &&
                              (double.tryParse(approvedAmountStr) ?? 0) <= 0) {
                            approvedAmountStr = claimAmountStr;
                          }

                          String claimAmount =
                              "\u20B9 ${claimAmountStr.replaceAll(",", "")}";
                          String approvedAmount =
                              "\u20B9 ${approvedAmountStr.replaceAll(",", "")}";

                          String dateStr =
                              item["expense_date"]?.toString() ?? "";
                          String date = dateStr;
                          try {
                            if (dateStr.contains("-")) {
                              List<String> parts = dateStr.split("-");
                              if (parts.length == 3) {
                                // Check if YYYY-MM-DD
                                if (parts[0].length == 4) {
                                  date = "${parts[2]}-${parts[1]}-${parts[0]}";
                                }
                              }
                            }
                          } catch (_) {}
                          String statusText = "Pending";
                          Color statusColor = const Color(0xffF87000); // Orange
                          Color statusBgColor = const Color(
                            0xffFFE0B2,
                          ); // Light Orange

                          if (statusRaw == "1" ||
                              statusRaw.contains("approv")) {
                            statusText = "Approved";
                            statusColor = const Color(0xff05D817); // Green
                            statusBgColor = const Color(
                              0xffE8F5E9,
                            ); // Light Green
                          } else if (statusRaw == "2" ||
                              statusRaw.contains("reject")) {
                            statusText = "Rejected";
                            statusColor = Colors.red;
                            statusBgColor = const Color(
                              0xffFFEBEE,
                            ); // Light Red
                          }

                          IconData icon = Icons.receipt_long;
                          Color iconColor = const Color(
                            0xFFD32F2F,
                          ); // Default to Red

                          final lowerTitle = title.toLowerCase();
                          if (lowerTitle.contains("food") ||
                              lowerTitle.contains("lunch") ||
                              lowerTitle.contains("dinner")) {
                            icon = Icons.restaurant;
                          } else if (lowerTitle.contains("travel") ||
                              lowerTitle.contains("flight") ||
                              lowerTitle.contains("taxi")) {
                            icon = Icons.directions_car;
                          } else if (lowerTitle.contains("stationary") ||
                              lowerTitle.contains("office")) {
                            icon = Icons.work;
                          } else {
                            icon = Icons.currency_rupee;
                          }

                          // Override color based on status
                          if (statusText == "Approved") {
                            iconColor = const Color(0xFF4CAF50); // Green
                          } else {
                            iconColor = const Color(0xFFD32F2F); // Red
                          }

                          double claimVal =
                              double.tryParse(
                                claimAmountStr.replaceAll(",", ""),
                              ) ??
                              0;
                          double apprVal =
                              double.tryParse(
                                approvedAmountStr.replaceAll(",", ""),
                              ) ??
                              0;
                          double balanceVal = claimVal - apprVal;

                          bool isPartiallyPending =
                              statusText == "Approved" && balanceVal > 0;

                          return Column(
                            children: [
                              _buildExpenseItem(
                                context: context,
                                icon: icon,
                                iconColor: iconColor,
                                title: title,
                                date: date,
                                claimAmount: claimAmount,
                                approvedAmount: approvedAmount,
                                balanceAmount:
                                    "\u20B9 ${balanceVal.toStringAsFixed(2)}",
                                status: statusText,
                                statusColor: statusColor,
                                statusBgColor: statusBgColor,
                                isPartiallyPending: isPartiallyPending,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),

                    const SizedBox(height: 100),

                    const SizedBox(height: 80), // Space for FAB

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  // Summary Card
  Widget _buildSummaryCard(
    String title,
    String amount,
    Color activeColor,
    bool isSelected,
  ) {
    final color = isSelected ? activeColor : const Color(0xFF1A1C3D);
    final bgColor = isSelected
        ? activeColor.withValues(alpha: 0.08)
        : Colors.white;

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? activeColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isSelected ? activeColor : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Individual Expense Item
  Widget _buildExpenseItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String date,
    required String claimAmount,
    required String approvedAmount,
    required String balanceAmount,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    bool isPartiallyPending = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor, // Solid color based on type
            child: Icon(icon, color: Colors.white, size: 30), // White icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Claim: $claimAmount",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              if (status == "Approved") ...[
                const SizedBox(height: 2),
                Text(
                  "Appr: $approvedAmount",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                if (isPartiallyPending)
                  Text(
                    "Bal: $balanceAmount",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ] else ...[
                const SizedBox(height: 2),
                Text(
                  "Pending",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              if (status == "Approved")
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isPartiallyPending
                        ? Colors.orange.shade50
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isPartiallyPending
                          ? Colors.orange.shade700
                          : const Color(0xFF2E7D32),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPartiallyPending
                            ? Icons.error_outline_rounded
                            : Icons.check_circle,
                        color: isPartiallyPending
                            ? Colors.orange.shade700
                            : const Color(0xFF2E7D32),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPartiallyPending ? "Partial" : "Approved",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPartiallyPending
                              ? Colors.orange.shade700
                              : const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailStat(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFF2E7D32) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
