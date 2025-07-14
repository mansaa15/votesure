import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'candidate_info_screen.dart';

class ElectionDetailsScreen extends StatelessWidget {
  final String username;

  const ElectionDetailsScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Election Details',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lok Sabha 2025',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE6E6FA), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: 15th March 2025',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  Text(
                    'Region: Nationwide',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  Text(
                    'Status: Upcoming',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CandidateInfoScreen(username: username),
                  ),
                );
              },
              child: Text(
                'View Candidates',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
