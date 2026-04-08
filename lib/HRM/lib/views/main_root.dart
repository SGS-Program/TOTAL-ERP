import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrm/views/chat/chat.dart';
import 'package:hrm/views/widgets/bottom_nav.dart';
import 'attendance_history/attendance.dart';
import 'home/payroll.dart';
import 'home_screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrm/models/employee_api.dart';
import 'package:flutter/foundation.dart';

class MainRoot extends StatefulWidget {
  final bool isEmbedded;
  const MainRoot({super.key, this.isEmbedded = false});

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _preFetchUserProfile();
  }

  Future<void> _preFetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // ✅ SESSION UID: Use login_cus_id for authentication
      // ✅ Standardized Identifier lookup
      final String sessionUid = prefs.getString('uid') ?? 
                                prefs.getString('login_cus_id') ?? 
                                prefs.getString('employee_table_id') ?? 
                                "84";

      final String lat = prefs.getDouble('lat')?.toString() ?? "145";
      final String lng = prefs.getDouble('lng')?.toString() ?? "145";
      final String deviceId = prefs.getString('device_id') ?? "123456";
      final String cid = prefs.getString('cid') ?? prefs.getString('cid_str') ?? "21472147";
      final String token = prefs.getString('token') ?? "";
      
      final response = await EmployeeApi.getEmployeeDetails(
        uid: sessionUid,
        cid: cid,
        deviceId: deviceId,
        lat: lat,
        lng: lng,
        token: token,
      );

      debugPrint("MainRoot Employee API Response => $response");

      if (response["error"] == false || response["error"] == "false") {
        final profileData = response["data"] ?? {};
        // Save profile data for all screens to use immediately
        await prefs.setString('name', profileData["name"]?.toString() ?? "User");
        await prefs.setString('employee_code', profileData["employee_code"]?.toString() ?? "");
        await prefs.setString('mobile', profileData["contact_number"]?.toString() ?? profileData["mobile"]?.toString() ?? "");
        await prefs.setString('profile_photo', profileData["profile_photo"]?.toString() ?? "");
        
        // Sync Internal UID
        final dynamic returnedCusId = profileData["cus_id"] ?? profileData["id"] ?? response["uid"];
        if (returnedCusId != null) {
          final String returnedUidStr = returnedCusId.toString();
          await prefs.setString('employee_table_id', returnedUidStr);
          await prefs.setString('assign_to', returnedUidStr);
          await prefs.setInt('uid_int', int.tryParse(returnedUidStr) ?? 0);
          await prefs.setString('uid', returnedUidStr);
        }
        debugPrint("MainRoot => Profile Persisted: ${profileData["name"]}");
      }
    } catch (e) {
      debugPrint("MainRoot Prefetch Error => $e");
    }
  }

  late final List<Widget> _screens = [
    Dashboard(isEmbedded: widget.isEmbedded),
    AttendanceScreen(),
    PayrollScreen(),
    ChatProjectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    assert(_screens.length == 4);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
