import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'dashboard_screen.dart';

class BiometricAuthScreen extends StatefulWidget {
  final String aadhaar;

  const BiometricAuthScreen({super.key, required this.aadhaar});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(username: widget.aadhaar),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Authentication failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Verify Your Identity',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Use Fingerprint or Face ID',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(
                'Authenticate',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
