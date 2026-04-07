import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class LeaveService {
  static final ApiClient _apiClient = ApiClient();

  /// ===============================
  /// GET EMPLOYEE TABLE ID
  /// ===============================
  static Future<String?> getEmployeeTableId() async {
    final prefs = await SharedPreferences.getInstance();
    final empId = prefs.getString('login_cus_id') ??
                  prefs.getString('server_uid') ??
                  prefs.getString('employee_table_id');
    return empId;
  }

  /// ===============================
  /// GET LEAVE TYPES (Type: 2044)
  /// ===============================
  static Future<List<String>> getLeaveTypes() async {
    final prefs = await SharedPreferences.getInstance();
    
    final res = await _apiClient.post({
        "type": "2044",
        "cid": prefs.getString('cid') ?? "",
        "device_id": prefs.getString('device_id') ?? "",
        "lt": (prefs.getDouble('lat') ?? 145).toString(),
        "ln": (prefs.getDouble('lng') ?? 145).toString(),
    });

    final data = jsonDecode(res.body);

    if (data["error"] == false) {
      return List<String>.from(
        data["data"]["leave_types"].map((e) => e["leave_type_name"].toString()),
      );
    }
    return [];
  }

  /// ===============================
  /// APPLY LEAVE (Type: 2043)
  /// ===============================
  static Future<Map<String, dynamic>> applyLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final empId = await getEmployeeTableId();

    if (empId == null || empId.isEmpty) {
      return {
        "error": true,
        "error_msg": "Employee not found. Please re-login.",
      };
    }

    final prefs = await SharedPreferences.getInstance();
    final res = await _apiClient.post({
        "type": "2043",
        "uid": empId,
        "id": empId, // Alias for backward compatibility
        "token": prefs.getString('token') ?? "",
        "leave_type": leaveType,
        "leave_start_date": fromDate,
        "leave_end_date": toDate,
        "reason": reason,
        "cid": prefs.getString('cid') ?? "",
        "device_id": prefs.getString('device_id') ?? "",
        "lt": (prefs.getDouble('lat') ?? 145).toString(),
        "ln": (prefs.getDouble('lng') ?? 145).toString(),
    });

    return jsonDecode(res.body);
  }
}
