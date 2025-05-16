import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finger_print_test/page/fingerprrint_page.dart';
import 'welcome_page.dart';   // <— make sure this file exists

/// Which API endpoint to hit.
enum OtpFlow { login, register }

class OTPScreen extends StatefulWidget {
  final String email;
  final OtpFlow flow;
  const OTPScreen({super.key, required this.email, required this.flow});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  bool _loading = false;

  /// Push WelcomePage and throw away the whole auth stack
  void _gotoWelcome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => FingerprintPage()),
      (route) => false,
    );
  }

  Future<void> _verify() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a 6-digit code')));
      return;
    }

    setState(() => _loading = true);
    final endpoint = widget.flow == OtpFlow.login
        ? '/auth/login/verify-otp'
        : '/auth/register/verify-otp';

    final res = await http.post(
      Uri.parse('http://192.168.222.137:8001$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.email, 'otp': otp}),
    );

    setState(() => _loading = false);

    if (res.statusCode == 200) {
      final jwt = jsonDecode(res.body)['token'];
      // TODO: securely persist JWT, e.g. using flutter_secure_storage
      if (!mounted) return;
      _gotoWelcome();
    } else {
      final msg =
          jsonDecode(res.body)['detail'] ?? 'OTP verification failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg.toString())));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Enter OTP')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'We sent a 6-digit code to ${widget.email}.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'OTP'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _verify,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Verify'),
              ),
            ],
          ),
        ),
      );
}
