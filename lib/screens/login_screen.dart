import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'biometric_auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String? _loggedInAadhaar;
  static String? getLoggedInAadhaar() => _loggedInAadhaar;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _aadhaarController = TextEditingController();
  bool _isLogin = true;

  String _hashAadhaar(String aadhaar) {
    return sha256.convert(utf8.encode(aadhaar)).toString();
  }

  Future<bool> _isRegistered(String aadhaar) async {
    final prefs = await SharedPreferences.getInstance();
    final aadhaarHash = _hashAadhaar(aadhaar);
    return prefs.getBool('registered_$aadhaarHash') ?? false;
  }

  Future<void> _register(String aadhaar) async {
    final prefs = await SharedPreferences.getInstance();
    final aadhaarHash = _hashAadhaar(aadhaar);
    await prefs.setBool('registered_$aadhaarHash', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          _isLogin ? 'Login' : 'Register',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _aadhaarController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: InputDecoration(
                labelText: 'Aadhaar Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final aadhaar = _aadhaarController.text;
                if (aadhaar.length == 12 &&
                    RegExp(r'^\d+$').hasMatch(aadhaar)) {
                  if (_isLogin) {
                    // Check if Aadhaar is registered for login
                    bool isRegistered = await _isRegistered(aadhaar);
                    if (!isRegistered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Aadhaar not registered. Please register first.',
                          ),
                        ),
                      );
                      return;
                    }
                  } else {
                    await _register(aadhaar);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration successful! Please login.'),
                      ),
                    );
                    setState(() {
                      _isLogin = true;
                    });
                    return;
                  }

                  LoginScreen._loggedInAadhaar = aadhaar;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BiometricAuthScreen(aadhaar: aadhaar),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid 12-digit Aadhaar number',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin ? 'New User? Register' : 'Already Registered? Login',
                style: GoogleFonts.poppins(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    super.dispose();
  }
}
