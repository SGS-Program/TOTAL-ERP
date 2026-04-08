import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class LeaveService {
  static final ApiClient _apiClient = ApiClient();

  /// ===============================
  /// GET EMPLOYEE TABLE ID
  /// ===============================
  static Future<String?> getEmployeeTableId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_cus_id') ??
           prefs.get('uid')?.toString() ??
           "54";
  }

  /// ===============================
  /// GET LEAVE TYPES (Type: 2044)
  /// ===============================
  static Future<List<String>> getLeaveTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final empId = await getEmployeeTableId();
    
    final body = {
      "type": "2044",
      "uid": empId ?? "54",
      "id": empId ?? "54",
      "token": prefs.getString('token') ?? "",
      "cid": prefs.getString('cid') ?? prefs.getString('cid_str') ?? "21472147",
      "device_id": prefs.getString('device_id') ?? "123456",
      "lt": (prefs.getDouble('lat') ?? 145).toString(),
      "ln": (prefs.getDouble('lng') ?? 145).toString(),
    };

  debugPrint("FETCHING LEAVE TYPES PARAMS => $body");
    
    final res = await _apiClient.post(body);
    
    debugPrint("LEAVE TYPES API RESPONSE => ${res.body}");

    final data = jsonDecode(res.body);

    if (data["error"].toString() == "false") {
      final List? rawList = data["data"] is Map ? data["data"]["leave_types"] : (data["leave_types"] ?? data["data"]);
      if (rawList is List) {
        return rawList.map((e) => (e["leave_type_name"] ?? e["leave_type"] ?? e.toString()).toString()).toList();
      }
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
        "cid": prefs.getString('cid') ?? prefs.getString('cid_str') ?? "",
        "device_id": prefs.getString('device_id') ?? "",
        "lt": (prefs.getDouble('lat') ?? 145).toString(),
        "ln": (prefs.getDouble('lng') ?? 145).toString(),
    });

    return jsonDecode(res.body);
  }
}
