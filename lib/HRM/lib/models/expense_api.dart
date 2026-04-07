import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../services/api_client.dart';

class ExpenseRepo {
  static final ApiClient _apiClient = ApiClient();

  // Add Expense API
  static Future<Map<String, dynamic>> addExpense({
    required String cid,
    required String uid,
    required String amount,
    required String description,
    required String expenseDate,
    required String deviceId,
    required String lat,
    required String lng,
    required String purpose,
    String? token,
    File? receiptImage,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiClient.baseUrl));

      request.fields.addAll({
        "cid": cid,
        "uid": uid,
        "id": uid, // Mirror for legacy backend compatibility
        "amount": amount,
        "description": description,
        "type": "2059",
        "expense_date": expenseDate,
        "device_id": deviceId,
        "lt": lat,
        "ln": lng,
        "purpose": purpose,
        if (token != null && token.isNotEmpty) "token": token,
      });

      if (receiptImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('receipt', receiptImage.path),
        );
      }

      var streamedResponse = await _apiClient.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "error_msg": "Server returned status code ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Add Expense API Error: $e");
      return {"error": true, "error_msg": e.toString()};
    }
  }

  // View Expense API
  static Future<Map<String, dynamic>> getExpenses({
    required String cid,
    required String uid,
    required String month,
    required String year,
    required String deviceId,
    required String lat,
    required String lng,
    String? token,
  }) async {
    try {
      final body = {
        "cid": cid,
        "uid": uid,
        "id": uid, // Mirror for legacy backend compatibility
        "month": month,
        "year": year,
        "type": "2060",
        "device_id": deviceId,
        "lt": lat,
        "ln": lng,
        if (token != null && token.isNotEmpty) "token": token,
      };

      final response = await _apiClient.post(body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "error_msg": "Server returned status code ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Get Expenses API Error: $e");
      return {"error": true, "error_msg": e.toString()};
    }
  }
}
