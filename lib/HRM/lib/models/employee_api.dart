import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class EmployeeApi {
  static final ApiClient _apiClient = ApiClient();

  static Future<Map<String, dynamic>> getEmployeeDetails({
    required String uid,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
    String? token,
  }) async {
    try {
      final body = {
        "type": "2048",
        "cid": cid,
        "uid": uid,
        "id": uid, // Sending both to ensure backward compatibility
        "device_id": deviceId,
        "lt": lat,
        "ln": lng,
        if (token != null && token.isNotEmpty) "token": token,
      };

      final response = await _apiClient.post(body);
      debugPrint("Employee Details API Response (2048) => ${response.body}");
      final data = jsonDecode(response.body);

      // ✅ TOKEN ROTATION: Update stored token if server provides a new one
      final newToken = data["token"]?.toString();
      if (newToken != null && newToken.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", newToken);
        debugPrint("Employee Detail API Token Update => $newToken");
      }

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          "error": true,
          "error_msg": "Server returned status code ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Employee Details API Error: $e");
      return {"error": true, "error_msg": e.toString()};
    }
  }
}
