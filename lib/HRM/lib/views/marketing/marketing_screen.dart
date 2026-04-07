import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Added for address
import 'marketing_checkout.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  String checkInTime = "00.00.00";
  String checkOutTime = "00.00.00";
  bool isLoading = false;
  List<dynamic> historyRecords = []; // Added for dynamic history

  String? employeeName;
  String? employeeCode;
  String? profilePhoto;
  String? deviceId;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String lastDate =
        prefs.getString('marketing_last_action_date_local') ?? "";

    if (lastDate != today && lastDate.isNotEmpty) {
      // RESET FOR NEW DAY
      await prefs.remove('is_marketing_checked_in_local');
      await prefs.remove('marketing_check_in_time_local');
      await prefs.remove('has_done_marketing_today');
      await prefs.remove('is_marketing_checked_out_local');
      await prefs.remove('marketing_check_out_time_local');
      await prefs.remove('current_marketing_id');
    }

    setState(() {
      isCheckedIn = prefs.getBool('is_marketing_checked_in_local') ?? false;
      checkInTime =
          prefs.getString('marketing_check_in_time_local') ?? "00.00.00";
      isCheckedOut = prefs.getBool('is_marketing_checked_out_local') ?? false;
      checkOutTime =
          prefs.getString('marketing_check_out_time_local') ?? "00.00.00";

      employeeName = prefs.getString('name');
      employeeCode = prefs.getString('employee_code');
      profilePhoto = prefs.getString('profile_photo');
    });
    _getDeviceId();
    _fetchServerStatus(); // Fetch real-time status from DB
  }

  Future<void> _fetchServerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final String cid = prefs.getString('cid') ?? "21472147";
      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "0";
      final String token = prefs.getString('token') ?? "";
      final String lat = prefs.getDouble('lat')?.toString() ?? "145";
      final String lng = prefs.getDouble('lng')?.toString() ?? "145";
      final String dId = deviceId ?? prefs.getString('device_id') ?? "123456";

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "2062", // Marketing history type
          "cid": cid,
          "uid": uid,
          "device_id": dId,
          "lt": lat,
          "ln": lng,
          if (token.isNotEmpty) "token": token,
        },
      );

      final data = jsonDecode(response.body);
      if (data["error"] == false) {
        final List<dynamic> records = data["data"] ?? [];
        final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final openCheckin = records.firstWhere(
          (e) =>
              e["date"] == today &&
              e["status"]?.toString().toLowerCase() == "open",
          orElse: () => null,
        );

        if (mounted) {
          setState(() {
            if (openCheckin != null) {
              isCheckedIn = true;
              checkInTime = openCheckin["check_in_time"] ?? "00.00.00";
              isCheckedOut = false;
              checkOutTime = "00.00.00";
            } else {
              isCheckedIn = false;
              checkInTime = "00.00.00";
              isCheckedOut = false;
              checkOutTime = "00.00.00";
            }
            historyRecords = records; // Sync history list
          });
          // Update local storage to match server
          await prefs.setBool('is_marketing_checked_in_local', isCheckedIn);
          await prefs.setString('marketing_check_in_time_local', checkInTime);
        }
      }
    } catch (e) {
      debugPrint("Error fetching marketing server status: $e");
    }
  }

  Future<void> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      deviceId = "123456";
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _performCheckIn() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final Position? pos = await _getCurrentLocation();

      final String uid =
          prefs.getString('login_cus_id') ??
          prefs.getString('server_uid') ??
          prefs.getString('employee_table_id') ??
          prefs.getInt('uid')?.toString() ??
          "2";

      final String cid = prefs.getString('cid') ?? "21472147";
      final String lt = pos?.latitude.toString() ?? "145";
      final String ln = pos?.longitude.toString() ?? "145";
      final String dId = deviceId ?? prefs.getString('device_id') ?? "123456";
      final String? token = prefs.getString('token');

      // Get readable address
      String checkInLocation = "0";
      try {
        if (pos != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            checkInLocation =
                "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          }
        }
      } catch (e) {
        debugPrint("Geocoding error: $e");
      }

      final body = {
        "cid": cid,
        "device_id": dId,
        "uid": uid,
        "lt": lt,
        "ln": ln,
        "check_in_location": checkInLocation, // Added param
        "type": "2054",
        if (token != null) "token": token,
      };

      debugPrint("Marketing Check-in Request Body => $body");

      final response = await http
          .post(Uri.parse("https://erpsmart.in/total/api/m_api/"), body: body)
          .timeout(const Duration(seconds: 15));

      debugPrint("Marketing Check-in Response: ${response.body}");
      final data = jsonDecode(response.body);

      if (data['error'] == false) {
        // Refresh from server to sync state immediately
        await _fetchServerStatus();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Checked in successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${data['error_msg'] ?? "Check-in failed"} (UID: $uid)",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Check-in error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showCheckInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure want to Check in?",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.black87),
                        ),
                        child: Text(
                          "NO",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _performCheckIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E2F5E,
                          ), // Navy blue from pic
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "YES",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Marketing",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Check-in",
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('is_marketing_checked_in_local');
              await prefs.remove('marketing_check_in_time_local');
              await prefs.remove('has_done_marketing_today');
              await prefs.remove('is_marketing_checked_out_local');
              await prefs.remove('marketing_check_out_time_local');
              await prefs.remove('current_marketing_id');

              setState(() {
                isCheckedIn = false;
                isCheckedOut = false;
                checkInTime = "00.00.00";
                checkOutTime = "00.00.00";
              });

              if (mounted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Marketing status reset successfully"),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
            ],
            if (isCheckedIn)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF98D1C1), // Light teal/green from pic
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/tick.gif', width: 24, height: 24),
                    const SizedBox(width: 12),
                    Text(
                      "Check in Successfully",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

            // Check In and Check Out section
            Row(
              children: [
                Expanded(
                  child: _buildTimeBox(
                    "Check In",
                    checkInTime,
                    isCheckedIn: isCheckedIn,
                    onTap: !isCheckedIn ? _showCheckInDialog : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTimeBox(
                    "Check Out",
                    checkOutTime,
                    isCheckedIn:
                        isCheckedOut, // Use same green color logic for checked out
                    onTap: () async {
                      if (!isCheckedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please Check In first"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (isCheckedOut) return;

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ),
                      );

                      if (result == true) {
                        setState(() {
                          // Allow new check-in after checkout
                          isCheckedIn = false;
                          isCheckedOut = false;
                          checkInTime = "00.00.00";
                          checkOutTime = "00.00.00";
                        });
                        _fetchServerStatus(); // Fresh fetch
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              "History",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // History list - Dynamic items from server
            if (historyRecords.isEmpty && !isCheckedIn)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "No history found for today",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: historyRecords.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final record = historyRecords[index];
                  final String client = record["client_name"] ?? "Unknown";
                  final String inT = record["check_in_time"] ?? "--:--";
                  final String outT = record["check_out_time"] ?? "--:--";
                  final String status =
                      record["status"]?.toString().toLowerCase() ?? "open";
                  final bool isClosed = status == "closed";

                  return _buildHistoryItem(
                    client,
                    isClosed ? "$inT - $outT" : inT,
                    isClosed ? "Completed" : "In Progress",
                    isClosed
                        ? const Color(0xFFA8E6CF)
                        : const Color(0xFFFFB38E),
                    isClosed
                        ? const Color(0xFF2ECC71)
                        : const Color(0xFFE67E22),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(
    String label,
    String time, {
    bool isCheckedIn = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isCheckedIn
              ? const Color(0xFF76C73F)
              : const Color(0xFFE0E0E0), // Green if checked in
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCheckedIn ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCheckedIn ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    String company,
    String time,
    String status,
    Color badgeBg,
    Color badgeText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.person_pin_circle_outlined, // Closer to the image icon
              color: status == "Completed"
                  ? const Color(0xFF2ECC71)
                  : const Color(0xFFE67E22),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
