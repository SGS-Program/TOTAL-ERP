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
      final String sessionUid = prefs.getString('login_cus_id') ?? 
                                prefs.getString('employee_table_id') ?? 
                                "84";

      final String lat = prefs.getDouble('lat')?.toString() ?? "";
      final String lng = prefs.getDouble('lng')?.toString() ?? "";
      final String deviceId = prefs.getString('device_id') ?? "";
      
      final response = await EmployeeApi.getEmployeeDetails(
        uid: sessionUid,
        cid: prefs.getString('cid') ?? "21472147",
        deviceId: deviceId,
        lat: lat,
        lng: lng,
        token: prefs.getString('token') ?? "",
      );

      if (response["error"] == false || response["error"] == "false") {
        // Save profile data for all screens to use immediately
        await prefs.setString('name', response["name"] ?? "User");
        await prefs.setString('employee_code', response["employee_code"] ?? "");
        await prefs.setString('mobile', response["contact_number"] ?? response["mobile"] ?? "");
        await prefs.setString('profile_photo', response["profile_photo"] ?? "");
        
        // Sync Internal UID
        if (response["uid"] != null) {
          final returnedUid = response["uid"].toString();
          await prefs.setString('employee_table_id', returnedUid);
          await prefs.setString('assign_to', returnedUid);
          await prefs.setInt('uid', int.tryParse(returnedUid) ?? 0);
        }
        debugPrint("MainRoot => Profile Prefetched & Synced");
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
