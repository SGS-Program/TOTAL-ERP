import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../services/api_client.dart';

class MarketingApi {
  static final ApiClient _apiClient = ApiClient();

  // Marketing Check-In (Type: 2054)
  static Future<Map<String, dynamic>> checkIn({
    required String uid,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
    required String type, // Default: 2054 from UI side request
    String? token,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiClient.baseUrl));
      request.fields.addAll({
        'cid': cid,
        'device_id': deviceId,
        'uid': uid,
        'id': uid, // Mirror for legacy backend compatibility
        'ln': lng,
        'lt': lat,
        'type': type,
      });

      if (token != null && token.isNotEmpty) {
        request.fields['token'] = token;
      }

      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Marketing Check-In Error: $e");
      return {"error": true, "message": e.toString()};
    }
  }

  // Marketing Check-Out (Type: 2053)
  static Future<Map<String, dynamic>> checkOut({
    required String uid,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
    required String type, // Default: 2053
    required String clientName,
    required String date,
    required String remarks,
    required String purposeOfVisitId,
    required String location,
    String? token,
    File? attachment,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiClient.baseUrl));
      request.fields.addAll({
        'cid': cid,
        'device_id': deviceId,
        'uid': uid,
        'id': uid, // Mirror for legacy backend compatibility
        'ln': lng,
        'lt': lat,
        'type': type,
        'client_name': clientName,
        'date': date,
        'remarks': remarks,
        'purpose_of_visit_id': purposeOfVisitId,
        'location': location,
      });

      if (token != null && token.isNotEmpty) {
        request.fields['token'] = token;
      }

      if (attachment != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachments[]',
            attachment.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "error": true,
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Marketing Check-Out Error: $e");
      return {"error": true, "message": e.toString()};
    }
  }

  // Fetch Marketing Enquiries (Type: 2076)
  static Future<Map<String, dynamic>> fetchEnquiries({
    required String uid,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
    required String assignTo,
    String? token,
    String type = "2076",
  }) async {
    try {
      final Map<String, String> body = {
        'cid': cid,
        'uid': uid,
        'id': uid, // Mirror for backward compatibility
        'device_id': deviceId,
        'lt': lat,
        'ln': lng,
        'assign_to': assignTo,
        'type': type,
      };

      if (token != null && token.isNotEmpty) {
        body['token'] = token;
      }

      debugPrint("Marketing Enquiries Request Params: $body");

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
      debugPrint("Fetch Enquiries Error: $e");
      return {"error": true, "error_msg": e.toString()};
    }
  }

  // Fetch History (Type: 2062)
  static Future<Map<String, dynamic>> fetchHistory({
    required String uid,
    required String cid,
    required String deviceId,
    required String lat,
    required String lng,
    String? token,
    String type = "2062",
  }) async {
    try {
      final body = {
        'cid': cid,
        'device_id': deviceId,
        'uid': uid,
        'id': uid, // Mirror for legacy backend compatibility
        'ln': lng,
        'lt': lat,
        'type': type,
        if (token != null) 'token': token,
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
      debugPrint("Fetch Marketing History Error: $e");
      return {"error": true, "error_msg": e.toString()};
    }
  }
}
