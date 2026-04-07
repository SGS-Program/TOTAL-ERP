import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ErpLoginApi {
  static const String baseUrl = "https://erpsmart.in/total/api/m_api/";

  /// 1. Type 2087: Login with Username & Password
  static Future<Map<String, dynamic>> loginWithUserPass({
    required String username,
    required String password,
    required String deviceId,
    required String lat,
    required String lng,
  }) async {
    final Map<String, String> body = {
      "type": "2087",
      "username": username,
      "password": password,
      "device_id": deviceId,
      "lt": lat,
      "ln": lng,
    };

    debugPrint("\n================ LOGIN REQUEST ================");
    debugPrint("URL: $baseUrl");
    debugPrint("BODY: $body");
    debugPrint("===============================================\n");

    try {
      final response = await http.post(Uri.parse(baseUrl), body: body);
      final decoded = json.decode(response.body);
      debugPrint("\n================ LOGIN RESPONSE ================");
      debugPrint("RESULT: $decoded");
      debugPrint("================================================\n");
      return decoded;
    } catch (e) {
      debugPrint("ErpLoginApi => ERROR [Type 2087]: $e");
      return {"error": true, "message": "Connection Failed"};
    }
  }

  /// 2. Type 2088: Send OTP
  static Future<Map<String, dynamic>> sendOtp({
    required String mobile,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
  }) async {
    final Map<String, String> body = {
      "type": "2088",
      "cid": cid,
      "mobile": mobile,
      "device_id": deviceId,
      "lt": lat,
      "ln": lng,
    };

    debugPrint("\n================ SEND OTP REQUEST ================");
    debugPrint("URL: $baseUrl");
    debugPrint("BODY: $body");
    debugPrint("==================================================\n");

    try {
      final response = await http.post(Uri.parse(baseUrl), body: body);
      final decoded = json.decode(response.body);
      debugPrint("\n================ SEND OTP RESPONSE ================");
      debugPrint("RESULT: $decoded");
      debugPrint("===================================================\n");
      return decoded;
    } catch (e) {
      debugPrint("ErpLoginApi => ERROR [Type 2088]: $e");
      return {"error": true, "message": "Connection Failed"};
    }
  }

  /// 3. Type 2089: Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
    required String cid,
    required String token,
    required String deviceId,
    required String lat,
    required String lng,
  }) async {
    final Map<String, String> body = {
      "type": "2089",
      "cid": cid,
      "mobile": mobile,
      "otp": otp,
      "token": token,
      "device_id": deviceId,
      "lt": lat,
      "ln": lng,
    };

    debugPrint("\n================ VERIFY OTP REQUEST ================");
    debugPrint("URL: $baseUrl");
    debugPrint("BODY: $body");
    debugPrint("===================================================\n");

    try {
      final response = await http.post(Uri.parse(baseUrl), body: body);
      final decoded = json.decode(response.body);
      debugPrint("\n================ VERIFY OTP RESPONSE ================");
      debugPrint("RESULT: $decoded");
      debugPrint("====================================================\n");
      return decoded;
    } catch (e) {
      debugPrint("ErpLoginApi => ERROR [Type 2089]: $e");
      return {"error": true, "message": "Connection Failed"};
    }
  }
}
