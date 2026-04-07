import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrm/views/home/settings.dart';
import 'dart:async';
import 'package:hrm/views/home_screen/employee_detail.dart';
import 'package:hrm/views/home_screen/performance.dart';
import 'package:hrm/views/home_screen/reports.dart';
import 'package:hrm/views/marketing/marketing_selection.dart';

import 'leave_management.dart';

import 'tasks_list.dart';
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../attendance_history/attendance.dart';
import 'annocement_screen.dart';

class Dashboard extends StatefulWidget {
  final bool isEmbedded;
  const Dashboard({super.key, this.isEmbedded = false});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = "User";
  double _monthlyRate = 0;
  bool isCheckedInByServer = false;
  bool isCheckedInByLocal = false;
  bool isTodayFinished = false;
  bool get isCheckedIn => isCheckedInByServer || isCheckedInByLocal;
  bool marketingAttendanceMode = false;
  bool hasDoneMarketingToday = false;
  bool isOnBreak = false;
  String breakPurpose = "";
  Duration breakDuration = Duration.zero;
  Timer? _breakTimer;

  List<dynamic> leaveHistory = [];
  bool isLeaveHistoryLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _breakTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (mounted) {
      setState(() {
        userName = prefs.getString('name') ?? "User";
        
        // 🚨 STRICT STARTUP RESET
        isCheckedInByLocal = false;
        isCheckedInByServer = false;
        isTodayFinished = false;
        isOnBreak = false;

        final String lastCheckIn = prefs.getString('last_checkin_date') ?? "";
        final String lastCheckOut = prefs.getString('last_checkout_date') ?? "";

        // ✅ ONLY ENABLE IF ACTION IS TODAY AND NOT FINISHED
        if (lastCheckIn == today && lastCheckOut != today) {
          isCheckedInByLocal = true;
        } else if (lastCheckOut == today) {
          isTodayFinished = true;
          // Clean up if somehow stuck
          isCheckedInByLocal = false;
        } else {
          // If no action today, ensure local cache is clean
          isCheckedInByLocal = false;
          _clearAttendancePrefs(prefs);
        }

        marketingAttendanceMode =
            prefs.getBool('marketing_attendance_mode') ?? false;
        hasDoneMarketingToday =
            prefs.getBool('has_done_marketing_today') ?? false;

        // ✅ CHECK-IN AND BREAK PERSISTENCE FROM LOCAL PREFS
        final bool isCheckInStored = prefs.getBool('isCheckedIn') ?? false;
        bool isBreakStored = prefs.getBool('is_on_break') ?? false;

        if (isCheckInStored) {
          isCheckedInByLocal = true;
        }

        // ✅ RELAXED SYNC: Always try to restore break if it's in local memory
        if (isBreakStored) {
          isOnBreak = true;
          breakPurpose = prefs.getString('break_purpose') ?? "Break";
          String? startTimeStr = prefs.getString('break_start_time');
          if (startTimeStr != null) {
            try {
              DateTime startTime = DateTime.parse(startTimeStr);
              breakDuration = DateTime.now().difference(startTime);
              _startBreakTimer(startTime);
            } catch (e) {
              isOnBreak = false;
              prefs.setBool('is_on_break', false);
            }
          }
        } else {
          isOnBreak = false;
          _breakTimer?.cancel();
        }
      });
    }

    Future.wait([
      _backgroundProfileFetch(prefs),
      _fetchLeaveSummary(prefs),
      _fetchLeaveHistory(),
      _fetchMonthlyPerformance(prefs),
      _fetchCheckInStatus(prefs),
    ]);
  }

  Future<void> _clearAttendancePrefs(SharedPreferences prefs) async {
    await prefs.setBool('isCheckedIn', false);
    await prefs.setBool('is_on_break', false);
    await prefs.remove('break_start_time');
    await prefs.setBool('marketing_attendance_mode', false);
    await prefs.setBool('has_done_marketing_today', false);
  }

  Future<void> _backgroundProfileFetch(SharedPreferences prefs) async {
    try {
      final String sessionUid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "84";

      final String lat = prefs.getDouble('lat')?.toString() ?? "145";
      final String lng = prefs.getDouble('lng')?.toString() ?? "145";
      final String deviceId = prefs.getString('device_id') ?? "123456";

      final body = {
        "type": "2048",
        "cid": prefs.getString('cid') ?? "21472147",
        "uid": sessionUid,
        "id": sessionUid,
        "device_id": deviceId,
        "lt": lat,
        "ln": lng,
        if (prefs.getString('token') != null) "token": prefs.getString('token'),
      };

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["error"] == false || data["error"] == "false") {
          if (mounted) {
            setState(() {
              userName = data["name"] ?? prefs.getString('name') ?? "User";
            });
          }
          await prefs.setString('name', userName);
          await prefs.setString('employee_code', data["employee_code"] ?? "");
          await prefs.setString('profile_photo', data["profile_photo"] ?? "");
        }
      }
    } catch (e) {
      debugPrint("Dashboard Background Profile Error => $e");
    }
  }

  List<Map<String, dynamic>> leaveBalanceData = [
    {"type": "Casual", "taken": 0, "total": 12, "balance": "12/12"},
    {"type": "Sick", "taken": 0, "total": 12, "balance": "12/12"},
    {"type": "Earned", "taken": 0, "total": 12, "balance": "12/12"},
    {"type": "Unpaid", "taken": 0, "total": null, "balance": "0/-"},
  ];

  Future<void> _fetchLeaveSummary(SharedPreferences prefs) async {
    try {
      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "1";
      final lat = prefs.getDouble('lat')?.toString() ?? "145";
      final lng = prefs.getDouble('lng')?.toString() ?? "145";

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "cid": prefs.getString('cid') ?? "",
          "device_id": prefs.getString('device_id') ?? "",
          "lt": lat,
          "ln": lng,
          "type": "2051",
          "uid": uid.toString(),
          "id": uid.toString(),
        },
      );

      if (response.statusCode == 200) {
        debugPrint("API Response (Leave Summary Dashboard): ${response.body}");
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          List<dynamic> apiList = [];
          if (data['leave_summary'] != null && data['leave_summary'] is List) {
            apiList = data['leave_summary'];
          } else if (data['data'] != null && data['data'] is List) {
            apiList = data['data'];
          }

          if (mounted) {
            setState(() {
              for (var staticItem in leaveBalanceData) {
                String staticType = staticItem['type'].toString().toLowerCase();
                var apiItem = apiList.firstWhere((api) {
                  String apiType =
                      (api['leave_type_name'] ??
                              api['leave_type'] ??
                              api['type'] ??
                              "")
                          .toString()
                          .toLowerCase();
                  if (staticType == "earned") {
                    return apiType.contains("privilege") ||
                        apiType.contains("earned");
                  }
                  if (staticType == "casual") return apiType.contains("casual");
                  if (staticType == "sick") {
                    return apiType.contains("medical") ||
                        apiType.contains("sick");
                  }
                  return apiType.contains(staticType);
                }, orElse: () => null);

                if (apiItem != null) {
                  int taken =
                      int.tryParse(
                        apiItem['leaves_taken_this_year']?.toString() ??
                            apiItem['leave_taken']?.toString() ??
                            "0",
                      ) ??
                      0;
                  int total =
                      int.tryParse(
                        apiItem['max_days_per_year']?.toString() ??
                            apiItem['total_allowed']?.toString() ??
                            "12",
                      ) ??
                      12;
                  staticItem['total'] = total;
                  staticItem['taken'] = taken;
                  staticItem['balance'] = "${total - taken}/$total";
                }
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching leave summary: $e");
    }
  }

  Future<void> _fetchLeaveHistory() async {
    if (mounted) setState(() => isLeaveHistoryLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "2";
      final String empCode = prefs.getString('employee_code') ?? "";
      final String lt = prefs.getDouble('lat')?.toString() ?? "145";
      final String ln = prefs.getDouble('lng')?.toString() ?? "145";

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "cid": prefs.getString('cid') ?? "",
          "device_id": prefs.getString('device_id') ?? "123456",
          "lt": lt,
          "ln": ln,
          "type": "2052",
          "uid": uid.toString(),
          "id": uid.toString(),
        },
      );

      if (response.statusCode == 200) {
        debugPrint("API Response (Leave History Dashboard): ${response.body}");
        final data = jsonDecode(response.body);
        List<dynamic> fetchedList = [];

        if (data is List) {
          fetchedList = data;
        } else if (data['leave_applications'] != null &&
            data['leave_applications'] is List) {
          fetchedList = data['leave_applications'];
        }

        if (empCode.isNotEmpty) {
          fetchedList = fetchedList
              .where(
                (item) => (item['employee_uid']?.toString() ?? "") == empCode,
              )
              .toList();
        }

        if (mounted) {
          setState(() {
            leaveHistory = fetchedList;
            for (var b in leaveBalanceData) b['taken'] = 0;

            for (var h in fetchedList) {
              String status = (h['status'] ?? "0").toString().toLowerCase();
              bool isApproved =
                  status == "1" ||
                  status.contains("approv") ||
                  status.contains("accept");
              if (!isApproved) continue;

              String leaveTypeLower = (h['leave_type'] ?? h['reason'] ?? "")
                  .toString()
                  .toLowerCase();
              bool isLop =
                  leaveTypeLower.contains("unpaid") ||
                  leaveTypeLower.contains("lop") ||
                  leaveTypeLower.contains("loss of pay") ||
                  leaveTypeLower.contains("without pay");

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

              if (isLop) {
                var unpaidItem = leaveBalanceData.firstWhere(
                  (b) => b['type'] == 'Unpaid',
                  orElse: () => <String, dynamic>{},
                );
                if (unpaidItem.isNotEmpty) {
                  unpaidItem['taken'] = (unpaidItem['taken'] as num) + days;
                }
                continue;
              }

              String type = (h['leave_type'] ?? h['reason'] ?? "")
                  .toString()
                  .toLowerCase();
              for (var b in leaveBalanceData) {
                String bType = b['type'].toString().toLowerCase();
                bool match = false;
                if (bType == "earned") {
                  match = type.contains("privilege") || type.contains("earned");
                } else if (bType == "casual") {
                  match = type.contains("casual");
                } else if (bType == "sick") {
                  match = type.contains("medical") || type.contains("sick");
                } else {
                  match = type.contains(bType);
                }

                if (match) {
                  b['taken'] = (b['taken'] as num) + days;
                  break;
                }
              }
            }

            for (var b in leaveBalanceData) {
              num total = b['total'] ?? 12;
              num taken = b['taken'];
              b['balance'] = "${total - taken}/$total";
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching leave history: $e");
    } finally {
      if (mounted) setState(() => isLeaveHistoryLoading = false);
    }
  }

  Future<void> _fetchMonthlyPerformance(SharedPreferences prefs) async {
    try {
      final String cid = prefs.getString('cid') ?? "";
      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "0";
      final String deviceId = prefs.getString('device_id') ?? "";
      final String lat = prefs.getDouble('lat')?.toString() ?? "";
      final String lng = prefs.getDouble('lng')?.toString() ?? "";
      final String? token = prefs.getString('token');

      DateTime now = DateTime.now();
      String fromDate = DateFormat('yyyy-MM-01').format(now);
      String toDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(now.year, now.month + 1, 0));

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "2075",
          "cid": cid,
          "uid": uid,
          "device_id": deviceId,
          "lt": lat,
          "ln": lng,
          "token": token ?? "",
          "from_date": fromDate,
          "to_date": toDate,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false && data['summary'] != null) {
          int total = data['summary']['total'] ?? 0;
          int completed = data['summary']['completed'] ?? 0;
          if (mounted) {
            setState(() {
              _monthlyRate = total == 0 ? 0 : (completed / total) * 100;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching monthly performance: $e");
    }
  }

  Future<void> _fetchCheckInStatus(SharedPreferences prefs) async {
    try {
      final String cid = prefs.getString('cid') ?? "";
      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "0";
      final String token = prefs.getString('token') ?? "";
      final String lat = prefs.getDouble('lat')?.toString() ?? "";
      final String lng = prefs.getDouble('lng')?.toString() ?? "";
      final String dId = prefs.getString('device_id') ?? "";

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "2064",
          "cid": cid,
          "uid": uid,
          "device_id": dId,
          "lt": lat,
          "ln": lng,
          if (token.isNotEmpty) "token": token,
        },
      );

      final data = jsonDecode(response.body);
      if (data["error"] == false || data["error"] == "false") {
        final List<dynamic> records = data["data"] ?? [];
        final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final todayRecord = records.firstWhere(
          (e) => e["date"] == today,
          orElse: () => null,
        );

        // Helper to check if a time is valid (not empty and not a dummy value)
        bool isTimeValid(dynamic time) {
          if (time == null) return false;
          String t = time.toString().trim().toLowerCase();
          return t.isNotEmpty && t != "null" && t != "00:00:00" && t != "00:00";
        }

        if (todayRecord != null) {
          final String inTimeStr = todayRecord["in_time"]?.toString() ?? "";
          final String outTimeStr = todayRecord["out_time"]?.toString() ?? "";

          final bool hasIn = isTimeValid(inTimeStr);
          final bool hasOut = isTimeValid(outTimeStr);

          if (mounted) {
            setState(() {
              if (hasIn && !hasOut) {
                // ✅ DATABASE SAYS: CHECKED IN
                isCheckedInByServer = true;
                isTodayFinished = false;
              } else if (hasIn && hasOut) {
                // ✅ DATABASE SAYS: COMPLETED
                isCheckedInByServer = false;
                isTodayFinished = true;
              } else {
                // ✅ DATABASE SAYS: NO RECORD
                isCheckedInByServer = false;
                isTodayFinished = false;
              }
              marketingAttendanceMode =
                  prefs.getBool('marketing_attendance_mode') ?? false;
              hasDoneMarketingToday =
                  prefs.getBool('has_done_marketing_today') ?? false;
            });
            await prefs.setBool('isCheckedIn', isCheckedInByServer);
            if (hasIn) await prefs.setString('last_checkin_date', today);
            if (hasOut) await prefs.setString('last_checkout_date', today);

            // ✅ SYNC BREAK STATUS FROM SERVER
            final String serverStatus =
                todayRecord["status"]?.toString().toLowerCase() ?? "";
            final bool serverSaysOnBreak = serverStatus.contains("break");

            if (mounted) {
              setState(() {
                if (isCheckedInByServer) {
                  if (serverSaysOnBreak) {
                    isOnBreak = true;
                  } else {
                    // ✅ SAFE STOP: Only stop break if local prefs ALSO confirm not on break
                    final bool localSaysOnBreak = prefs.getBool('is_on_break') ?? false;
                    if (!localSaysOnBreak) {
                      isOnBreak = false;
                      _breakTimer?.cancel();
                    }
                    // If local says on break, keep running — local wins
                  }
                } else {
                  // Checked out — definitely end break
                  isOnBreak = false;
                  _breakTimer?.cancel();
                }
              });
            }

            // Sync Preference — only clear if server confirmed checkout
            if (!isCheckedInByServer) {
              await prefs.setBool('is_on_break', false);
              await prefs.remove('break_start_time');
            } else if (serverSaysOnBreak) {
              await prefs.setBool('is_on_break', true);
            }
            final String serverWorkMode =
                todayRecord["wrk_mde"]?.toString().toLowerCase() ?? "";

            if (serverWorkMode.isNotEmpty) {
                bool isMkt = serverWorkMode == "marketing";
                await prefs.setBool('marketing_attendance_mode', isMkt);

                if (isMkt) {
                  // If chosen marketing, check if they actually did a marketing check-in
                  final historyResp = await http.post(
                    Uri.parse("https://erpsmart.in/total/api/m_api/"),
                    body: {
                      "type": "2062",
                      "cid": cid,
                      "uid": uid,
                      "device_id": dId,
                      "lt": lat,
                      "ln": lng,
                      if (token.isNotEmpty) "token": token,
                    },
                  );
                  final hData = jsonDecode(historyResp.body);
                  if (hData['error'] == false) {
                    final List records = hData['data'] ?? [];
                    final hasOpenRecord = records.any(
                      (r) =>
                          r['date'] == today &&
                          r['status']?.toString().toLowerCase() == "open",
                    );
                    if (mounted) {
                      setState(() {
                        hasDoneMarketingToday = hasOpenRecord;
                        marketingAttendanceMode = isMkt;
                      });
                    }
                    await prefs.setBool(
                      'has_done_marketing_today',
                      hasOpenRecord,
                    );
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      marketingAttendanceMode = isMkt;
                    });
                  }
                }
              }
            } else {
            // ✅ NO RECORD ON SERVER FOR TODAY - FORCE RESET LOCAL STATE
            if (mounted) {
              setState(() {
                isCheckedInByServer = false;
                isTodayFinished = false;
                isOnBreak = false;
                _breakTimer?.cancel();
                marketingAttendanceMode = false;
                hasDoneMarketingToday = false;
              });
            }
            await prefs.setBool('isCheckedIn', false);
            await prefs.remove('last_checkin_date');
            await prefs.remove('last_checkout_date');
            await prefs.setBool('is_on_break', false);
            await prefs.remove('break_start_time');
            await prefs.setBool('marketing_attendance_mode', false);
            await prefs.setBool('has_done_marketing_today', false);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching checkin status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    bool isTablet = w >= 600 && w < 1024;
    bool isDesktop = w >= 1024;

    double padding = w * 0.04;
    double boxRadius = w * 0.03;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isEmbedded ? null : AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        title: Text(
          "Welcome $userName",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: isTablet ? 26 : (isDesktop ? 28 : 20),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, size: w * 0.07, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementScreen(userName: userName),
                ),
              );
            },
            icon: Image.asset(
              "assets/icons/announcement.png",
              color: Colors.white,
              width: isTablet ? 30 : 25,
              height: isTablet ? 30 : 25,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationApp()),
              );
            },
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: isTablet ? 30 : 26,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: CircleAvatar(
              radius: isTablet ? 18 : 16,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: isTablet ? 24 : 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your HR Management Hub",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 22 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: h * 0.02),
            if (!isCheckedIn && !isTodayFinished) ...[
              _buildCheckInReminderCard(context, w),
              SizedBox(height: h * 0.02),
            ],
            if (isCheckedIn &&
                !isTodayFinished &&
                marketingAttendanceMode &&
                !hasDoneMarketingToday) ...[
              _buildMarketingCheckInReminderCard(context, w),
              SizedBox(height: h * 0.02),
            ],
            if (isOnBreak) ...[
              _buildBreakInProgressCard(context, w),
              SizedBox(height: h * 0.02),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                double boxWidth = (constraints.maxWidth - 12) / 2;
                return Column(
                  children: [
                    Row(
                      children: [
                        menuBox(
                          context,
                          boxWidth,
                          "Employee",
                          "assets/businessman.png",
                          const LinearGradient(
                            colors: [Colors.white, Color(0xFFFAFFB8)],
                          ),
                        ),
                        const SizedBox(width: 12),
                        menuBox(
                          context,
                          boxWidth,
                          "Leave",
                          "assets/leave.png",
                          const LinearGradient(
                            colors: [Colors.white, Color(0xFFA3DCFF)],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    Row(
                      children: [
                        menuBox(
                          context,
                          boxWidth,
                          "Marketing",
                          "assets/marketing.png",
                          const LinearGradient(
                            colors: [
                              Colors.white,
                              Color.fromRGBO(255, 202, 141, 0.75),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        menuBox(
                          context,
                          boxWidth,
                          "Performance",
                          "assets/performance.png",
                          const LinearGradient(
                            colors: [
                              Colors.white,
                              Color.fromRGBO(255, 152, 154, 0.53),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    menuBox(
                      context,
                      constraints.maxWidth,
                      "Reports",
                      "assets/reports.png",
                      const LinearGradient(
                        colors: [Colors.white, Color(0xFFAEFFE3)],
                      ),
                      isFullWidth: true,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: h * 0.02),
            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2C61),
                borderRadius: BorderRadius.circular(boxRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.campaign,
                    color: Colors.white,
                    size: isTablet ? 36 : 30,
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Text(
                      "Company Announcement\nNew HR policy updates available.",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isTablet ? 18 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1B2C61),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "View",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Task",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TasksListScreen(),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Color(0xFF26A69A),
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.01),
            taskCard(),
            SizedBox(height: h * 0.02),
            Text(
              "Your Target",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: h * 0.01),
            targetBox(),
            SizedBox(height: h * 0.02),
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFF24D7B3)],
                ),
                borderRadius: BorderRadius.circular(boxRadius),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 5,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/frame.png",
                    height: isTablet ? 90 : 70,
                    width: isTablet ? 50 : 35,
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: Text(
                      "Almost there! Push through the last 25% and claim your success!!",
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18 : 14,
                        color: const Color(0xff1B2C61),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            Text(
              "Leave Summary",
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: h * 0.01),
            leaveReport(),
            if (leaveHistory.isNotEmpty) ...[
              SizedBox(height: h * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Activity",
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveManagementScreen(),
                      ),
                    ).then((_) => _initializeApp()),
                    child: Text(
                      "View All",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF26A69A),
                      ),
                    ),
                  ),
                ],
              ),
              isLeaveHistoryLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF26A69A),
                        ),
                      ),
                    )
                  : _buildRecentLeaveHistory(w),
            ],
            SizedBox(height: h * 0.03),
          ],
        ),
      ),
    );
  }

  Widget menuBox(
    BuildContext context,
    double width,
    String title,
    String asset,
    Gradient gradient, {
    bool isFullWidth = false,
  }) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        Widget? target;
        if (title == "Employee")
          target = const EmployeeDetailsScreen();
        else if (title == "Marketing")
          target = const MarketingSelectionScreen();
        else if (title == "Performance")
          target = const PerformanceScreen();
        else if (title == "Reports")
          target = const ReportsScreen();
        else if (title == "Leave")
          target = const LeaveManagementScreen();
        if (target != null)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target!),
          ).then((_) => _initializeApp());
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(isFullWidth ? w * 0.06 : w * 0.03),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(w * 0.03),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: isFullWidth
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(asset, height: w * 0.15),
                  SizedBox(width: w * 0.04),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Image.asset(asset, height: w * 0.12),
                  SizedBox(height: w * 0.02),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCheckInReminderCard(BuildContext context, double w) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE57373), Color(0xFFEF5350)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFEF5350),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance Pending",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You haven't checked in for today yet.",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttendanceScreen()),
            ).then((_) => _initializeApp()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFEF5350),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Check-in",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketingCheckInReminderCard(BuildContext context, double w) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFA726),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Marketing Attendance Pending",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You must check-in for Marketing Task",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MarketingSelectionScreen(),
              ),
            ).then((_) => _initializeApp()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFFA726),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Check-in",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 6,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Task Completion Rate",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${_monthlyRate.toStringAsFixed(0)}%",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) => _buildDashboardProgressBar(
              progress: _monthlyRate / 100,
              color: const Color(0xFF26A69A),
              width: constraints.maxWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _monthlyRate >= 80
                ? "Excellent performance! Keep it up!"
                : (_monthlyRate >= 50
                      ? "Good progress, keep pushing!"
                      : "Tasks need more focus this month."),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget targetBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/target.png", height: 25, width: 25),
              const SizedBox(width: 8),
              Text(
                "Your Target Completion",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) => _buildDashboardProgressBar(
              progress: _monthlyRate / 100,
              color: const Color(0xffEC6E2D),
              width: constraints.maxWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${_monthlyRate.toStringAsFixed(0)}% Completed",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xffEC6E2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardProgressBar({
    required double progress,
    required Color color,
    required double width,
  }) {
    const double barHeight = 10;
    const double iconSize = 24;
    return SizedBox(
      height: iconSize,
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: barHeight,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(barHeight / 2),
            ),
          ),
          Container(
            height: barHeight,
            width: width * (progress > 1 ? 1 : (progress < 0 ? 0 : progress)),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barHeight / 2),
            ),
          ),
          Positioned(
            left:
                (width * (progress > 1 ? 1 : (progress < 0 ? 0 : progress))) -
                (iconSize / 2),
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.local_fire_department,
                  size: 14,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget leaveReport() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: leaveBalanceData
            .where(
              (item) =>
                  item['type'] == 'Casual' ||
                  item['type'] == 'Sick' ||
                  item['type'] == 'Unpaid',
            )
            .map((item) {
              String displayType;
              String asset = "assets/casual_leave.png";
              if (item['type'] == "Sick")
                displayType = "Medical Leave";
              else if (item['type'] == "Unpaid")
                displayType = "Unpaid Leave (LOP)";
              else
                displayType = "${item['type']} Leave";
              num taken = item['taken'] as num;
              String balanceLine = item['type'] == 'Unpaid'
                  ? "LOP Days: $taken"
                  : "Balance: ${((item['total'] as num? ?? 12) - taken).clamp(0, 99)} / ${item['total'] ?? 12} Days";
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Image.asset(
                      asset,
                      height: 60,
                      width: 60,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.event_busy,
                        size: 48,
                        color: Color(0xFF26A69A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "$displayType:\nTaken: $taken Day\n$balanceLine",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              );
            })
            .toList(),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _startBreakTimer(DateTime startTime) {
    _breakTimer?.cancel();
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() => breakDuration = DateTime.now().difference(startTime));
    });
  }

  Widget _buildBreakInProgressCard(BuildContext context, double w) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: w * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.yellow.shade700.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.shade700.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceScreen()),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/cup.png",
                width: 24,
                height: 24,
                color: Colors.orange.shade800,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "On Break (${formatDuration(breakDuration)})",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  Text(
                    "Purpose: $breakPurpose",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.brown.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.brown.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLeaveHistory(double w) {
    final recentItems = leaveHistory.take(3).toList();
    return Column(
      children: recentItems.map((item) {
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
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['leave_type'] ?? "General Leave",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B2C61),
                      ),
                    ),
                    Text(
                      "${item['leave_start_date']} to ${item['leave_end_date']}",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
