import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome 🎉',
          style: TextStyle(fontSize: 32, color: Colors.deepPurpleAccent),
        ),
      ),
    );
  }
}
