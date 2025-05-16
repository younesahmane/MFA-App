import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'otp_screen.dart';     // ➜ expects (email, flow) – see note below
import 'signup_page.dart';

const String _baseUrl = 'http://192.168.222.137:8001';       // change to your host:port

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl    = TextEditingController();
    final passwordCtrl = TextEditingController();

    Future<void> _login() async {
      final email    = emailCtrl.text.trim();
      final password = passwordCtrl.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      try {
        final res = await http.post(
          Uri.parse('$_baseUrl/auth/login/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        if (res.statusCode == 200) {
          // First factor accepted ➜ show OTP screen
          // We *don’t* have a JWT yet; OTP screen will fetch it.
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OTPScreen(
                  email: email,
                  flow: OtpFlow.login,
                ),
              ),
            );
          }
        } else {
          final msg =
              jsonDecode(res.body)['detail'] ?? 'Login failed – check credentials';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg.toString())));
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error – try again')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
