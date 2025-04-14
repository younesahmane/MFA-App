import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'otp_screen.dart';

class QRPage extends StatelessWidget {
  final String email;
  final String secret;

  const QRPage({super.key, required this.email, required this.secret});

  @override
  Widget build(BuildContext context) {
    final otpUrl = 'otpauth://totp/MFA-App:$email?secret=$secret&issuer=MFA-App';

    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR in Authenticator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Scan this QR code using Google Authenticator or Aegis:'),
            const SizedBox(height: 20),
            QrImageView(
              data: otpUrl,
              size: 250.0,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => OTPScreen(secret: secret)),
                );
              },
              child: const Text('Continue to OTP'),
            )
          ],
        ),
      ),
    );
  }
}
