import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verify_with_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import '../../utils/localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum LoginType { sms, whatsapp, email }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginType _currentType = LoginType.email;
  final TextEditingController _controller = TextEditingController();
  String? _errorText; // Holds validation error messages
  bool _isLoading = false; // Add loading state

  void _switchType(LoginType type) {
    setState(() {
      _currentType = type;
      _controller.clear();
      _errorText = null; // Clear error on type switch
    });
  }

  void _validateAndSubmit() async {
    final text = _controller.text.trim();
    setState(() => _errorText = null);

    if (text.isEmpty) {
      setState(() {
        _errorText = _currentType == LoginType.email
            ? AppLocalization.of('Please enter your email address')
            : AppLocalization.of('Please enter your number');
      });
      return;
    }

    if (_currentType == LoginType.email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(text)) {
        setState(() => _errorText = AppLocalization.of('Enter a valid email address'));
        return;
      }
    } else {
      // Handles both SMS and Whatsapp number validation (Typically 10 digits)
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      if (!phoneRegex.hasMatch(text)) {
        setState(() => _errorText = AppLocalization.of('Enter a valid 10-digit number'));
        return;
      }
    }

    if (_isLoading) return; // Prevent dual clicks

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      
      String ln = '145'; // Default fallback
      String lt = '123';
      String deviceId = '1';

      // 1. Get Location
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() => _isLoading = false);
          _showLocationDialog("Location Services Disabled", "Please enable location services to continue securely.");
          return;
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            setState(() => _isLoading = false);
            _showLocationDialog("Permission Denied", "Location permission is required for security checks.");
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          setState(() => _isLoading = false);
          _showLocationDialog("Permission Denied", "Location permissions are permanently denied. Please enable in Settings.");
          return;
        }

        Position? position;
        try {
          if (Platform.isAndroid) {
            position = await Geolocator.getCurrentPosition(
              locationSettings: AndroidSettings(
                accuracy: LocationAccuracy.best,
              ),
            ).timeout(const Duration(seconds: 15));
          } else {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
              ),
            ).timeout(const Duration(seconds: 15));
          }
        } catch (e) {
          debugPrint("getCurrentPosition failed: $e, trying last known...");
          position = await Geolocator.getLastKnownPosition();
        }

        if (position != null) {
          ln = position.longitude.toString();
          lt = position.latitude.toString();
        } else {
          setState(() => _isLoading = false);
          _showLocationDialog("Coordinates Fetch Error", "Could not fetch location. If in Emulator, please set a location in extended controls.");
          return;
        }
      } catch (e) {
        debugPrint("Location error: $e");
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location fetch failed: $e')),
        );
        return;
      }

      // 2. Get Device ID
      try {
        final deviceInfo = DeviceInfoPlugin();
        final battery = Battery();
        int batteryLevel = 0;
        try {
          batteryLevel = await battery.batteryLevel;
        } catch (_) {}

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId = "${androidInfo.brand}|${androidInfo.version.release}|$batteryLevel";
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceId = "Apple|${iosInfo.systemVersion}|$batteryLevel";
        }
      } catch (e) {
        debugPrint("Device ID error: $e");
      }

      // Save to SharedPreferences for downstream popup uses
      await prefs.setString('ln', ln);
      await prefs.setString('lt', lt);
      await prefs.setString('device_id', deviceId);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
      );
      request.fields['type'] = '5001';
      request.fields['ln'] = ln;
      request.fields['lt'] = lt;
      request.fields['device_id'] = deviceId;
      request.fields['mobile'] = text;

      // Print Params in Debug Console
      debugPrint('Login Params: ${request.fields}');

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      
      // Print Response in Debug Console
      debugPrint('Login Response: $responseString');

      var jsonResponse = json.decode(responseString);

      if (jsonResponse['error'] == false) {
        // Save to SharedPreferences for OTP verification
        await prefs.setString('cid', jsonResponse['cid']?.toString() ?? '');
        await prefs.setString('f_token', jsonResponse['f_token']?.toString() ?? '');
        await prefs.setString('mobile', text); // also save mobile if needed

        _openOtpVerification(text, jsonResponse); // Pass loaded response directly
      } else {
        setState(() => _errorText = jsonResponse['error_msg'] ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _errorText = AppLocalization.of('Network error, please try again'));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLocationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          if (title.contains("Disabled"))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Geolocator.openLocationSettings();
              },
              child: const Text("Settings"),
            ),
        ],
      ),
    );
  }

  void _openOtpVerification(String info, Map<String, dynamic> response) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VerifyWithOtp(
          contactInfo: info,
          type: _currentType,
          otp: response['otp']?.toString(), // Pass it so details can verify or debug
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF26A69A);
    const gradientTeal = Color(0xFF00796B);
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent for 3D background
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // --- 3D Background Element ---
            Positioned(
              top: -80,
              right: -100,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/images/animation_object.png',
                  width: 400.w,
                  fit: BoxFit.contain,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(begin: 0, end: 20, duration: 4.seconds, curve: Curves.easeInOut)
              .rotate(begin: 0, end: 0.05, duration: 6.seconds, curve: Curves.easeInOut),
            ),

            Positioned(
              bottom: -50,
              left: -80,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  'assets/images/animation_object.png',
                  width: 300.w,
                  fit: BoxFit.contain,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveX(begin: 0, end: 15, duration: 5.seconds, curve: Curves.easeInOut),
            ),

            // --- Main Content ---
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      
                      // 3D Perspective Logo Section
                      Center(
                        child: Column(
                          children: [
                            Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // perspective
                                ..rotateX(-0.1)
                                ..rotateY(0.1),
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryTeal.withOpacity(0.1),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/smart.png',
                                      width: 200.w,
                                      color: primaryTeal,
                                      colorBlendMode: BlendMode.srcIn,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 4.h),
                                    Image.asset(
                                      'assets/images/TOTAL ERP.png',
                                      width: 120.w,
                                      color: primaryTeal,
                                      colorBlendMode: BlendMode.srcIn,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .scale(begin: const Offset(0.9, 0.9), curve: Curves.elasticOut),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 50.h),
                      
                      // Sign in Header with 3D Slide
                      Text(
                        "Sign in",
                        style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                      
                      SizedBox(height: 8.h),
                      Text(
                        "Manage your customers, sales & business anywhere.",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                      
                      SizedBox(height: 48.h),
                      
                      // Card-style Glassmorphic Container for Input
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: AutofillGroup(
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.phone,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            cursorColor: primaryTeal,
                            style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.w600),
                            onSubmitted: (_) => _validateAndSubmit(),
                            decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                              hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 16.sp),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryTeal, width: 2),
                              ),
                              errorText: _errorText,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                      
                      SizedBox(height: 54.h),
                      
                      // 3D Animated Gradient Button
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryTeal, gradientTeal],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: primaryTeal.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading ? null : _validateAndSubmit,
                            borderRadius: BorderRadius.circular(12.r),
                            child: Center(
                              child: _isLoading 
                                ? SizedBox(height: 24.h, width: 24.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : Text(
                                    "Next",
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutBack),
                      
                      SizedBox(height: 48.h),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "or continue with",
                              style: GoogleFonts.outfit(color: Colors.black45, fontSize: 13.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                        ],
                      ).animate().fadeIn(delay: 600.ms),
                      
                      SizedBox(height: 36.h),
                      
                      // Alternative Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildOutlineSocialButton(
                              "Whatsapp", 
                              'assets/icons/whats app.png',
                              primaryTeal,
                              () => _switchType(LoginType.whatsapp),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _buildOutlineSocialButton(
                              "Via Mail",
                              null,
                              primaryTeal,
                              () => _switchType(LoginType.email),
                              iconData: Icons.mail_outline_rounded,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
                      
                      SizedBox(height: 60.h),
                      
                      // Footer Links with Scale effect
                      Center(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8.r),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.outfit(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w700),
                                children: [
                                  const TextSpan(text: "Don't Have An Account? "),
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: const Color(0xFF0D47A1),
                                      fontWeight: FontWeight.w900,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                      
                      SizedBox(height: 48.h),
                      
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "By Continuing you agree to our",
                              style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13.sp, fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                    color: primaryTeal,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 900.ms),
                      
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineSocialButton(String label, String? imagePath, Color color, VoidCallback onTap, {IconData? iconData}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: const Color(0xFF80CBC4), width: 1.2.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        backgroundColor: color.withOpacity(0.02), // Very subtle tint
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(imagePath, width: 22.w, height: 22.w),
          if (iconData != null)
            Icon(iconData, color: color, size: 22.w),
          SizedBox(width: 10.w),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
