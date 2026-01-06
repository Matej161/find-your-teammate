import 'package:flutter/material.dart';
import 'package:frontend/widgets/login_button_widget.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String? _userName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userName = await _authService.getUserName();
    setState(() {
      _userName = userName;
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Blue Gradient Background (Matches your reference)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD), // Light Blue
              Color(0xFF90CAF9), // Medium Blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // --- CENTERED CARD ---
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24, 
                        vertical: screenHeight * 0.04
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. HEADING
                          const Text(
                            'Find Your Squad',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1565C0), // Dark Blue
                              letterSpacing: 0.5,
                            ),
                          ),
                          
                          const SizedBox(height: 10),
                          
                          const Text(
                            'The ultimate platform for gamers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF546E7A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 2. FEATURE LIST (Fills the empty space)
                          // I created a helper method below to keep this clean
                          _buildFeatureItem(
                            icon: Icons.groups_rounded, 
                            title: "Find Teammates",
                            subtitle: "Connect with players instantly.",
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 20),
                          _buildFeatureItem(
                            icon: Icons.gamepad_rounded, 
                            title: "Explore Games",
                            subtitle: "Discover new lobbies to join.",
                            color: Colors.purple,
                          ),
                          const SizedBox(height: 20),
                          _buildFeatureItem(
                            icon: Icons.chat_bubble_rounded, 
                            title: "Real-time Chat",
                            subtitle: "Strategize before you play.",
                            color: Colors.teal,
                          ),

                          const SizedBox(height: 40),

                          // 3. GRADIENT BUTTON
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'GET STARTED',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- TOP RIGHT LOGIN/LOGOUT BUTTON ---
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: _isLoading
                    ? const SizedBox.shrink()
                    : _userName != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Welcome, $_userName!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _handleLogout,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.4),
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Color(0xFF1565C0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const HomeNavButtonWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGET FOR THE FEATURE LIST ---
  // This creates the Icon + Text rows
  Widget _buildFeatureItem({
    required IconData icon, 
    required String title, 
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        // Circular Icon Background
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Light pastel background
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        // Text Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}