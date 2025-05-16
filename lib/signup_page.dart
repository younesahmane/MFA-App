import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_screen.dart';
import 'login_page.dart';

const _baseUrl = 'http://192.168.222.137:8001';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl  = TextEditingController();

    Future<void> _register() async {
      final email = emailCtrl.text.trim();
      final pwd   = passCtrl.text;
      if (email.isEmpty || pwd.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Fill in all fields')));
        return;
      }

      final res = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pwd}),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(email: email, flow: OtpFlow.register),
          ),
        );
      } else {
        final msg =
            jsonDecode(res.body)['detail'] ?? 'Registration failed';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _register, child: const Text('Next')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
