import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class VoteVerificationScreen extends StatelessWidget {
  const VoteVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'Vote Verified!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Election: Lok Sabha 2025',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Text(
                      'Vote ID: 12345',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Text(
                      'Status: Recorded on Blockchain',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DashboardScreen(
                            username:
                                LoginScreen.getLoggedInAadhaar() ?? 'Unknown',
                          ),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  'Back to Home',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
