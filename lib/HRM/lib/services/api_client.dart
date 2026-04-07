import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  final http.Client _client = http.Client();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  static const String baseUrl = "https://erpsmart.in/total/api/m_api/";

  Future<http.Response> post(Map<String, dynamic> body) async {
    Map<String, String> finalBody = {};
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Inject global params if not explicitly provided in body
      finalBody = Map<String, String>.from(
        body.map((key, value) => MapEntry(key, value.toString()))
      );

      if (!finalBody.containsKey('lt')) finalBody['lt'] = prefs.getDouble('lat')?.toString() ?? "0.0";
      if (!finalBody.containsKey('ln')) finalBody['ln'] = prefs.getDouble('lng')?.toString() ?? "0.0";
      if (!finalBody.containsKey('device_id')) finalBody['device_id'] = prefs.getString('device_id') ?? "Unknown";

      final response = await _client.post(
        Uri.parse(baseUrl),
        body: finalBody,
      ).timeout(const Duration(seconds: 30));
      return response;
    } catch (e) {
      debugPrint("API POST ERROR => $finalBody");
      debugPrint("DETAILED ERROR => $e");
      rethrow;
    }
  }

  Future<http.Response> postJson(Map<String, dynamic> body) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> finalBody = Map<String, dynamic>.from(body);

      if (!finalBody.containsKey('lt')) finalBody['lt'] = prefs.getDouble('lat') ?? 0.0;
      if (!finalBody.containsKey('ln')) finalBody['ln'] = prefs.getDouble('lng') ?? 0.0;
      if (!finalBody.containsKey('device_id')) finalBody['device_id'] = prefs.getString('device_id') ?? "Unknown";

      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(finalBody),
      ).timeout(const Duration(seconds: 30));
      return response;
    } catch (e) {
      debugPrint("API POST JSON ERROR => $e");
      rethrow;
    }
  }

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      return await _client.send(request).timeout(const Duration(seconds: 60));
    } catch (e) {
      debugPrint("API SEND ERROR => $e");
      rethrow;
    }
  }

  // Closes the client when the application is finished.
  void dispose() {
    _client.close();
  }
}
