import 'package:flutter/material.dart';
import 'qr_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void login() {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email == 'user@example.com' && password == '123456') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRPage(email: email, secret: 'JBSWY3DPEHPK3PXP'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Try again')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
