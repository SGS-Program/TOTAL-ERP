import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import 'verify_with_otp.dart';
import 'login_types.dart';
import '../../Models/erp_login_api.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isMobileLogin = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
  }

  void _validateAndSubmit() async {
    setState(() => _errorText = null);

    if (_isMobileLogin) {
      final mobile = _mobileController.text.trim();
      if (mobile.isEmpty || mobile.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid 10-digit mobile number')),
        );
        return;
      }
      _handleMobileLogin(mobile);
    } else {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter both username and password')),
        );
        return;
      }
      // Directly proceed to password login using the default/last-saved URL
      _handlePasswordLogin(username, password);
    }
  }

  void _handlePasswordLogin(String username, String password) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Fetch dynamic location and device info
      String ln = prefs.getString('ln') ?? '145';
      String lt = prefs.getString('lt') ?? '123';
      String deviceId = prefs.getString('device_id') ?? '1';

      final response = await ErpLoginApi.loginWithUserPass(
        username: username,
        password: password,
        deviceId: deviceId,
        lat: lt,
        lng: ln,
      );

      if (response['error'] == false) {
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('username', username);
        await prefs.setString(
            'login_cus_id', response['cus_id']?.toString() ?? '');
        await prefs.setString('token', response['token']?.toString() ?? '');

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        setState(() {
          _errorText = response['message'] ??
              'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Login failed. Please check your connection.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleMobileLogin(String mobile) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      String ln = '145';
      String lt = '123';
      String deviceId = '1';

      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.low),
        ).timeout(const Duration(seconds: 5));
        ln = position.longitude.toString();
        lt = position.latitude.toString();
      } catch (_) {}

      try {
        final deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId = "Android|${androidInfo.model}";
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceId = "iOS|${iosInfo.model}";
        }
      } catch (_) {}

      await prefs.setString('ln', ln);
      await prefs.setString('lt', lt);
      await prefs.setString('device_id', deviceId);
      await prefs.setString('mobile', mobile);

      final String cid = prefs.getString('cid') ?? '21472147';

      final response = await ErpLoginApi.sendOtp(
        mobile: mobile,
        cid: cid,
        deviceId: deviceId,
        lat: lt,
        lng: ln,
      );

      if (response['error'] == false) {
        await prefs.setString('cid', response['cid']?.toString() ?? cid);
        await prefs.setString('f_token', response['f_token']?.toString() ?? '');

        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: VerifyWithOtp(
                contactInfo: mobile,
                type: LoginType.sms,
                otp: response['otp']?.toString(),
                onVerified: () {
                  // Navigate directly to HomeScreen after OTP verification
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorText = response['error_msg'] ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Authentication failed. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF26A69A);
    const darkTeal = Color(0xFF00695C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(Icons.business_center_rounded,
                          size: 48.sp, color: primaryTeal),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "TOTAL ERP",
                      style: GoogleFonts.outfit(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: darkTeal,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              _buildStep0(primaryTeal, darkTeal),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep0(Color primaryTeal, Color darkTeal) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleButton("Password", !_isMobileLogin,
                    () => setState(() => _isMobileLogin = false)),
                _buildToggleButton("Mobile", _isMobileLogin,
                    () => setState(() => _isMobileLogin = true)),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
        if (!_isMobileLogin) ...[
          _buildLabel("Username / Email"),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: _usernameController,
            hintText: "Enter your username",
            icon: Icons.person_outline_rounded,
          ),
          SizedBox(height: 20.h),
          _buildLabel("Password"),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: _passwordController,
            hintText: "Enter your password",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ] else ...[
          _buildLabel("Mobile Number"),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: _mobileController,
            hintText: "Enter 10-digit number",
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
        ],
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: primaryTeal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r)),
                  onChanged: (val) =>
                      setState(() => _rememberMe = val ?? false),
                ),
                Text(
                  "Remember Me",
                  style: GoogleFonts.outfit(
                      fontSize: 14.sp, color: Colors.grey.shade700),
                ),
              ],
            ),
            if (!_isMobileLogin)
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTeal),
                ),
              ),
          ],
        ),
        SizedBox(height: 32.h),
        if (_errorText != null)
          Center(
            child: Text(
              _errorText ?? '',
              style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
        SizedBox(height: 40.h),
        _buildPrimaryButton(primaryTeal, _isMobileLogin ? "Get OTP" : "Login"),
        SizedBox(height: 50.h),
        Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                  color: Colors.grey.shade700, fontSize: 15.sp),
              children: [
                const TextSpan(text: "New to Smart ERP? "),
                TextSpan(
                  text: "Get Access",
                  style: TextStyle(
                      color: primaryTeal,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(Color primaryTeal, String text) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _validateAndSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 4,
          shadowColor: primaryTeal.withOpacity(0.4),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(
                text,
                style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1),
              ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    const primaryTeal = Color(0xFF26A69A);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? primaryTeal : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.outfit(fontSize: 16.sp, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22.sp),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          hintText: hintText,
          hintStyle:
              GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 15.sp),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
      ),
    );
  }
}
