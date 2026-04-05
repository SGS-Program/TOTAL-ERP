import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart'; // Handles tapping on sublinks
import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import '../home/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/localization.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VerifyWithOtp extends StatefulWidget {
  final String contactInfo;
  final LoginType type;
  final String? otp; // Add otp parameter

  const VerifyWithOtp({
    super.key,
    required this.contactInfo,
    required this.type,
    this.otp,
  });

  @override
  State<VerifyWithOtp> createState() => _VerifyWithOtpState();
}

class _VerifyWithOtpState extends State<VerifyWithOtp> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _timerSeconds = 57;
  Timer? _timer;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-fill OTP if passed (for debugging/convenience)
    if (widget.otp != null && widget.otp!.length == 6) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (int i = 0; i < 6; i++) {
          _controllers[i].text = widget.otp![i];
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        if (mounted) {
          setState(() {
            _timerSeconds--;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _formattedTimer {
    final minutes = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _resendOtp() async {
    if (_timerSeconds > 0) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      String ln = '145'; // Default fallback
      String lt = '123';

      final savedLn = prefs.getString('ln');
      final savedLt = prefs.getString('lt');
      if (savedLn != null) ln = savedLn;
      if (savedLt != null) lt = savedLt;

      final deviceId = prefs.get('device_id')?.toString() ?? '1';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://erpsmart.in/total/api/m_api/'),
      );
      request.fields['type'] = '5001';
      request.fields['ln'] = ln;
      request.fields['lt'] = lt;
      request.fields['device_id'] = deviceId;
      request.fields['mobile'] = widget.contactInfo;

      debugPrint('Resend OTP Params: ${request.fields}');

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      debugPrint('Resend OTP Response: $responseString');
      var jsonResponse = json.decode(responseString);

      if (jsonResponse['error'] == false) {
        setState(() {
          _timerSeconds = 57;
        });
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalization.of('OTP Resent Successfully')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        for (var c in _controllers) {
          c.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonResponse['error_msg'] ?? 'Resend failed'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of('Network error, please try again')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    const darkBlueLink = Color(0xFF0000A5);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Back Button & Title
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).iconTheme.color,
                    size: 32,
                  ),
                ),
              )
                  .animate()
                  .scale(
                      delay: 100.ms,
                      duration: 400.ms,
                      curve: Curves.easeOutBack)
                  .fadeIn(),
              const SizedBox(width: 16),
              Text(
                AppLocalization.of('Verify with OTP'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideX(begin: 0.2, curve: Curves.easeOutCubic),
            ],
          ),
          const SizedBox(height: 32),
          // Subtitle
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
                fontSize: 16,
                height: 1.5,
              ),
              children: [
                TextSpan(
                    text: AppLocalization.of(
                            "Waiting to automatically detect an OTP sent to") +
                        "\n"),
                TextSpan(
                  text:
                      "${widget.type == LoginType.email ? "" : "+91 "}${widget.contactInfo}. ",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                TextSpan(
                  text: widget.type == LoginType.email
                      ? AppLocalization.of("Wrong mail?")
                      : AppLocalization.of("Wrong Number?"),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pop(context),
                  style: const TextStyle(
                    color: tealColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          const SizedBox(height: 32),
          // OTP Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return _buildOtpField(index)
                  .animate(delay: (400 + (index * 50)).ms)
                  .fadeIn()
                  .scale(
                      begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
            }),
          ),
          const SizedBox(height: 24),
          // Resend & Timer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _timerSeconds == 0 && !_isLoading ? _resendOtp : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _timerSeconds == 0 ? 1.0 : 0.5,
                  child: Text(
                    AppLocalization.of('Resend OTP'),
                    style: TextStyle(
                      color: _timerSeconds == 0 ? tealColor : Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tealColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 16, color: tealColor),
                    const SizedBox(width: 4),
                    Text(
                      _formattedTimer,
                      style: const TextStyle(
                        color: tealColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 48),
          // Verify Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: tealColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                // Validates that all index buffers hold inputs before shifting pages
                bool isFilled = _controllers.every((c) => c.text.isNotEmpty);
                if (!isFilled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          AppLocalization.of('Please enter all 6 OTP digits')),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  return;
                }

                if (_isLoading) return;

                setState(() => _isLoading = true);

                try {
                  final prefs = await SharedPreferences.getInstance();

                  String ln = '145'; // Default fallback
                  String lt = '123';
                  final deviceId = prefs.get('device_id')?.toString() ?? '1';
                  final cid = prefs.getString('cid') ?? '';
                  final token = prefs.getString('f_token') ?? '';
                  final mobile =
                      prefs.getString('mobile') ?? widget.contactInfo;

                  // 1. Get Location Real-Time
                  try {
                    bool serviceEnabled =
                        await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please enable Location Services to continue')),
                      );
                      return;
                    }

                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Location permission is denied')),
                        );
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Location permissions are permanently denied. Please enable in Settings')),
                      );
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
                      debugPrint(
                          "getCurrentPosition failed: $e, trying last known...");
                      position = await Geolocator.getLastKnownPosition();
                    }

                    if (position != null) {
                      ln = position.longitude.toString();
                      lt = position.latitude.toString();
                    } else {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Could not fetch location. If in Emulator, please set a location in extended controls.')),
                      );
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

                  final enteredOtp = _controllers.map((c) => c.text).join();

                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('https://erpsmart.in/total/api/m_api/'),
                  );
                  request.fields['type'] = '5002';
                  request.fields['ln'] = ln;
                  request.fields['lt'] = lt;
                  request.fields['device_id'] = deviceId;
                  request.fields['mobile'] = mobile;
                  request.fields['cid'] = cid;
                  request.fields['otp'] = enteredOtp;
                  request.fields['token'] = token;

                  // Print Params in Debug Console
                  debugPrint('OTP Verification Params: ${request.fields}');

                  var response = await request.send();
                  var responseString = await response.stream.bytesToString();
                  debugPrint('OTP Verification Response: $responseString');
                  var jsonResponse = json.decode(responseString);

                  if (jsonResponse['error'] == false) {
                    // Save logged in status for Session Persistence
                    await prefs.setBool('is_logged_in', true);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(jsonResponse['message'] ??
                            'Invalid or expired OTP'),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Network error, please try again'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tealColor,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      AppLocalization.of('Verify'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index) {
    const tealColor = Color(0xFF26A69A);
    double availableWidth =
        MediaQuery.of(context).size.width - 48; // Padding horizontal
    double fieldWidth = (availableWidth - (5 * 10)) / 6;
    if (fieldWidth > 54) fieldWidth = 54;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {}); // Trigger rebuild for focus color change
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: fieldWidth,
        height: 60,
        decoration: BoxDecoration(
          color: _focusNodes[index].hasFocus
              ? tealColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focusNodes[index].hasFocus
                ? tealColor
                : Colors.grey.withOpacity(0.3),
            width: _focusNodes[index].hasFocus ? 2.0 : 1.2,
          ),
          boxShadow: _focusNodes[index].hasFocus
              ? [
                  BoxShadow(
                    color: tealColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          cursorColor: tealColor,
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
