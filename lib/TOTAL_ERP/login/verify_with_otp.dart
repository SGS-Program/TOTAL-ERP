import 'dart:async';
import 'package:flutter/material.dart';
import 'login_types.dart';
import '../home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Models/erp_login_api.dart';

class VerifyWithOtp extends StatefulWidget {
  final String contactInfo;
  final LoginType type;
  final String? otp;
  final VoidCallback? onVerified;

  const VerifyWithOtp({
    super.key,
    required this.contactInfo,
    required this.type,
    this.otp,
    this.onVerified,
  });

  @override
  State<VerifyWithOtp> createState() => _VerifyWithOtpState();
}

class _VerifyWithOtpState extends State<VerifyWithOtp> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _timerSeconds = 57;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.otp != null && (widget.otp?.length ?? 0) == 6) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (int i = 0; i < 6; i++) {
          _controllers[i].text = (widget.otp ?? '')[i];
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        if (mounted) setState(() => _timerSeconds--);
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
    if (_timerSeconds > 0 || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String ln = prefs.getString('ln') ?? '145';
      String lt = prefs.getString('lt') ?? '123';
      final deviceId = prefs.getString('device_id') ?? '1';
      final cid = prefs.getString('cid') ?? '21472147';

      final response = await ErpLoginApi.sendOtp(
        mobile: widget.contactInfo,
        cid: cid,
        deviceId: deviceId,
        lat: lt,
        lng: ln,
      );

      if (response['error'] == false) {
        setState(() => _timerSeconds = 57);
        _startTimer();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('OTP Resent Successfully'), backgroundColor: Colors.green)
           );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error_msg'] ?? 'Resend failed'), backgroundColor: Colors.redAccent)
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error, please try again'), backgroundColor: Colors.redAccent)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => Navigator.pop(context)),
              Text('Verify with OTP', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          Text("Waiting to automatically detect OTP sent to ${widget.contactInfo}", style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (i) => _buildOtpField(i))),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: _timerSeconds == 0 ? _resendOtp : null, child: Text('Resend OTP', style: TextStyle(color: _timerSeconds == 0 ? tealColor : Colors.grey))),
              Text(_formattedTimer, style: const TextStyle(color: tealColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: tealColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Verify', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) return;
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      String ln = prefs.getString('ln') ?? '145';
      String lt = prefs.getString('lt') ?? '123';
      final deviceId = prefs.getString('device_id') ?? '1';
      final cid = prefs.getString('cid') ?? '';
      final token = prefs.getString('f_token') ?? '';

      final response = await ErpLoginApi.verifyOtp(
        mobile: prefs.getString('mobile') ?? widget.contactInfo,
        otp: enteredOtp,
        cid: cid,
        token: token,
        deviceId: deviceId,
        lat: lt,
        lng: ln,
      );

      if (response['error'] == false) {
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('token', response['token']?.toString() ?? token);
        final String resolvedUid = response['cus_id']?.toString() ?? 
                                 response['data']?['cus_id']?.toString() ?? 
                                 response['user_id']?.toString() ?? 
                                 "54";
        final String resolvedCid = response['cid']?.toString() ?? 
                                 response['data']?['cid']?.toString() ?? 
                                 "21472147";

        await prefs.setString('login_cus_id', resolvedUid);
        await prefs.setString('uid', resolvedUid);
        await prefs.setString('cid', resolvedCid);
        await prefs.setString('cid_str', resolvedCid);
        await prefs.setString('name', response['data']?['name']?.toString() ?? '');
        
        if (mounted) {
          if (widget.onVerified != null) {
            Navigator.pop(context);
            widget.onVerified?.call();
          } else {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (r) => false);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Invalid OTP')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification failed')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
          if (v.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
        },
      ),
    );
  }
}
