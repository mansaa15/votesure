import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'election_list_screen.dart';
import 'blockchain_service.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  final BlockchainService _blockchainService = BlockchainService();

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(username: widget.username),
      ElectionListScreen(username: widget.username),
      ProfileScreen(aadhaar: widget.username),
      _buildVoteCountScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildVoteCountScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
        title: Text(
          'Vote Counts',
          style: GoogleFonts.poppins(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<int>>(
          future: Future.wait([
            _blockchainService.getVoteCount(1),
            _blockchainService.getVoteCount(2),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final counts = snapshot.data ?? [0, 0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Election Results',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildResultCard('Rahul Sharma', counts[0]),
                _buildResultCard('Priya Patel', counts[1]),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(String candidate, int votes) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            candidate,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('$votes votes', style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFE6E6FA),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: const Color(0xFFE6E6FA),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.how_to_vote),
            label: 'Elections',
            backgroundColor: const Color(0xFFE6E6FA),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Profile',
            backgroundColor: const Color(0xFFE6E6FA),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: 'Results',
            backgroundColor: const Color(0xFFE6E6FA),
          ),
        ],
      ),
    );
  }
}
