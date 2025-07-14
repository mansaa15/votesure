import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'vote_verification_screen.dart';

class VoteReceiptScreen extends StatelessWidget {
  final String ipfsHash;

  const VoteReceiptScreen({super.key, required this.ipfsHash});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Vote Receipt',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'Vote Submitted Successfully!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6FA),
                borderRadius: BorderRadius.circular(15),
              ),
              child: QrImageView(
                data:
                    'VoteID:${DateTime.now().millisecondsSinceEpoch}-Election:LokSabha2025-IPFS:$ipfsHash',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Scan this QR code to verify your vote.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VoteVerificationScreen(),
                  ),
                );
              },
              child: Text(
                'Verify Vote',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
