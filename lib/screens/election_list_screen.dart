import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ballot_screen.dart';
import 'election_details_screen.dart';

class ElectionListScreen extends StatelessWidget {
  final String username;

  const ElectionListScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Elections',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
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
    );
  }

  Widget _buildElectionCard(
    BuildContext context, {
    required String title,
    required String date,
    required String status,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElectionDetailsScreen(username: username),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
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
                Text(
                  'Date: $date',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: status == 'Active' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                if (status == 'Active')
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BallotScreen(username: username),
                          ),
                        );
                      },
                      child: Text('Vote!', style: GoogleFonts.poppins()),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
