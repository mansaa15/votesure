import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String aadhaar;

  const ProfileScreen({super.key, required this.aadhaar});

  String _getMaskedAadhaar(String aadhaar) {
    final hash = sha256.convert(utf8.encode(aadhaar)).toString();
    final lastFour = aadhaar.substring(aadhaar.length - 4);
    return '${hash.substring(0, 8)}...$lastFour';
  }

  Future<String> _getVotingHistory(String aadhaar) async {
    final prefs = await SharedPreferences.getInstance();
    final usernameHash = sha256.convert(utf8.encode(aadhaar)).toString();
    final hasVoted = prefs.getBool(usernameHash) ?? false;

    print("🔍 Checking voting history for hash: $usernameHash");
    print("ℹ️ Has voted: $hasVoted");

    if (hasVoted) {
      final voteTimestamp = prefs.getString(
        '${usernameHash}_timestamp',
      ); // Matches blockchain_service.dart
      print("🕒 Retrieved timestamp: $voteTimestamp");

      if (voteTimestamp != null) {
        final dateTime = DateTime.parse(voteTimestamp);
        final formatter = DateFormat(
          'MMM d, yyyy, h:mm a',
        ); // e.g., Apr 2, 2025, 2:30 PM
        return 'Voted on ${formatter.format(dateTime)}';
      } else {
        return 'Voted (timestamp not available)';
      }
    }
    return 'Not Voted Yet';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Your Profile',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE6E6FA),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhaar: ${_getMaskedAadhaar(aadhaar)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Verified Voter',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFFE6E6FA)),
              title: Text(
                'Change Biometric Settings',
                style: GoogleFonts.poppins(),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFFE6E6FA)),
              title: Text('Voting History', style: GoogleFonts.poppins()),
              subtitle: FutureBuilder<String>(
                future: _getVotingHistory(aadhaar),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Loading...',
                      style: GoogleFonts.poppins(fontSize: 12),
                    );
                  }
                  return Text(
                    snapshot.data ?? 'Not Voted Yet',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: Text('Logout', style: GoogleFonts.poppins()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
