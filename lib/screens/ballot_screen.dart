import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vote_confirmation_screen.dart';
import 'blockchain_service.dart';

class BallotScreen extends StatefulWidget {
  final String username;

  const BallotScreen({super.key, required this.username});

  @override
  State<BallotScreen> createState() => _BallotScreenState();
}

class _BallotScreenState extends State<BallotScreen> {
  String? _selectedCandidate;
  final BlockchainService _blockchainService = BlockchainService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Cast Your Vote',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCandidateOption('Rahul Sharma', 1),
            _buildCandidateOption('Priya Patel', 2),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _selectedCandidate != null
                      ? () async {
                        try {
                          final ipfsHash = await _blockchainService.castVote(
                            widget.username,
                            int.parse(_selectedCandidate!),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VoteConfirmationScreen(
                                    selectedCandidate:
                                        _selectedCandidate == '1'
                                            ? 'Rahul Sharma'
                                            : 'Priya Patel',
                                    ipfsHash: ipfsHash,
                                  ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                      : null,
              child: Text(
                'Confirm Vote',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateOption(String name, int candidateId) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCandidate = candidateId.toString();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:
              _selectedCandidate == candidateId.toString()
                  ? const Color(0xFFE6E6FA)
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: candidateId.toString(),
              groupValue: _selectedCandidate,
              onChanged: (value) {
                setState(() {
                  _selectedCandidate = value;
                });
              },
            ),
            Text(name, style: GoogleFonts.poppins(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
