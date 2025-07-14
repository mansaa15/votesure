import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ballot_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'VoteSure Home',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      radius: 30,
                      backgroundColor: Color(0xFFE6E6FA),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Voter!',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ready to make your voice heard?',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Upcoming Elections',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildElectionCard(
                context,
                title: 'Lok Sabha 2025',
                date: '15th March 2025',
                status: 'Upcoming',
              ),
              _buildElectionCard(
                context,
                title: 'Delhi Assembly 2025',
                date: '20th Feb 2025',
                status: 'Active',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElectionCard(
    BuildContext context, {
    required String title,
    required String date,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE6E6FA), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Starts: $date', style: GoogleFonts.poppins(fontSize: 12)),
            ],
          ),
          if (status == 'Active')
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BallotScreen(username: username),
                  ),
                );
              },
              child: Text('Vote Now', style: GoogleFonts.poppins()),
            ),
        ],
      ),
    );
  }
}
