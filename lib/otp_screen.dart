import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'welcome_page.dart';

class OTPScreen extends StatefulWidget {
  final String secret;
  const OTPScreen({super.key, required this.secret});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  late Timer _timer;
  late int _remaining;
  late String _generatedOTP;

  @override
  void initState() {
    super.initState();
    _generateOTP();
    _startTimer();
  }

  void _startTimer() {
    _remaining = 30 - (DateTime.now().second % 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remaining--;
        if (_remaining <= 0) {
          _generateOTP();
          _remaining = 30;
        }
      });
    });
  }

  void _generateOTP() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _generatedOTP = OTP.generateTOTPCodeString(widget.secret, now, interval: 30);
    debugPrint('Generated OTP: $_generatedOTP');
  }

  void _verifyOTP() {
    if (otpController.text.trim() == _generatedOTP) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect OTP')),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = _remaining / 30.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Enter the OTP from your authenticator app:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: percent,
              center: Text(
                '$_remaining s',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.deepPurple,
              backgroundColor: Colors.white10,
              animation: true,
              animateFromLastPercent: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
