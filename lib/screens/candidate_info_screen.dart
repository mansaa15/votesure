import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ballot_screen.dart';

class CandidateInfoScreen extends StatelessWidget {
  final String username;

  const CandidateInfoScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Candidates',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildCandidateCard(
              context,
              name: 'Rahul Sharma',
              party: 'Progressive Party',
              agenda: 'Education for All',
            ),
            _buildCandidateCard(
              context,
              name: 'Priya Patel',
              party: 'Unity Alliance',
              agenda: 'Healthcare Reform',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE6E6FA),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BallotScreen(username: username),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }

  Widget _buildCandidateCard(
    BuildContext context, {
    required String name,
    required String party,
    required String agenda,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE6E6FA),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Party: $party',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Agenda: $agenda',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
