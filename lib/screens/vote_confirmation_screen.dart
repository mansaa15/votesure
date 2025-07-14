import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vote_receipt_screen.dart';

class VoteConfirmationScreen extends StatelessWidget {
  final String selectedCandidate;
  final String ipfsHash;

  const VoteConfirmationScreen({
    super.key,
    required this.selectedCandidate,
    required this.ipfsHash,
  });

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
              const Icon(Icons.how_to_vote, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'Confirm Your Vote',
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
                      'Candidate: $selectedCandidate',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    // Optionally display ipfsHash here for confirmation
                    Text(
                      'Vote Hash: $ipfsHash',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VoteReceiptScreen(
                            ipfsHash: ipfsHash,
                          ), // Pass ipfsHash forward
                    ),
                  );
                },
                child: Text(
                  'Submit Vote',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go Back',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
