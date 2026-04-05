import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Screens/SignIn/splash.dart';
import '../Services/preference_service.dart';

class LoginApi {
  static const String baseUrl = 'https://erpsmart.in/total/api/m_api/';

  /// Handles user sign-in by requesting an OTP.
  static Future<Map<String, dynamic>> signIn({
    required String mobile,
  }) async {
    final String deviceId = SplashScreen.deviceId ?? '';
    final String ln = SplashScreen.ln ?? '';
    final String lt = SplashScreen.lt ?? '';
    final String appSignature = await PreferenceService.getAppSignature();

    final Map<String, String> body = {
      'type': '3001',
      'device_id': deviceId,
      'ln': ln,
      'lt': lt,
      'mobile': mobile,
      'app_signature': appSignature,
    };

    final response = await http.post(Uri.parse(baseUrl), body: body);
    return json.decode(response.body);
  }

  /// Verifies the OTP provided by the user.
  static Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String mobile,
    required String cid,
  }) async {
    final String deviceId = SplashScreen.deviceId ?? '';
    final String ln = SplashScreen.ln ?? '';
    final String lt = SplashScreen.lt ?? '';
    final String appSignature = await PreferenceService.getAppSignature();

    final Map<String, String> body = {
      'type': '3002',
      'cid': cid,
      'device_id': deviceId,
      'lt': lt,
      'ln': ln,
      'mobile': mobile,
      'otp': otp,
      'app_signature': appSignature,
    };

    final response = await http.post(Uri.parse(baseUrl), body: body);
    return json.decode(response.body);
  }

  /// Handles user registration.
  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String mobile,
  }) async {
    final String deviceId = SplashScreen.deviceId ?? '';
    final String ln = SplashScreen.ln ?? '';
    final String lt = SplashScreen.lt ?? '';
    final String appSignature = await PreferenceService.getAppSignature();
    String currentCid = await PreferenceService.getCid();
    if (currentCid.isEmpty) currentCid = '21472147';

    final Map<String, String> body = {
      'type': '3000',
      'cid': currentCid,
      'device_id': deviceId,
      'name': name,
      'lt': lt,
      'ln': ln,
      'email': email,
      'mobile': mobile,
      'app_signature': appSignature,
    };

    final response = await http.post(Uri.parse(baseUrl), body: body);
    return json.decode(response.body);
  }
}
