import 'package:flutter/material.dart';
import 'game_server_screen.dart'; // Sibling screen in the 'screens' folder
import '../widgets/game_selection_widget.dart'; // Import the reusable widget

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  // Updated to pass the gameName when navigating
  void _navigateToGameServer(BuildContext context, String gameName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Pass the selected gameName to the GameServerScreen constructor
        builder: (context) => GameServerScreen(gameName: gameName),
      ),
    );
  }

  // --- Profile Button Action ---
  void _navigateToProfile(BuildContext context) {
    // Assuming a /profile route exists, or just show a message for now
    print('Navigating to User Profile...');
  }

  // --- Logout Action (Navigates to /home) ---
  void _logout(BuildContext context) {
    // Navigate to the /home route and clear navigation stack (logging out)
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Colors referenced from your Home Screen for consistency
    const Color primaryBlue = Color(0xFF1565C0); // Dark Blue
    const Color accentBlue = Color(0xFF90CAF9);  // Medium Blue

    final List<Map<String, dynamic>> games = [
      {'name': 'League of Legends', 'icon': Icons.security, 'color': Colors.blue},
      {'name': 'Fortnite', 'icon': Icons.sports_esports, 'color': Colors.purpleAccent},
      {'name': 'Minecraft', 'icon': Icons.landscape, 'color': Colors.lightGreen},
      {'name': 'Rocket League', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    ];

    return Scaffold(
      // Using a Container for the AppBar background to allow for gradients if desired later,
      // but for now applying the solid primaryBlue to match the theme.
      appBar: AppBar(
        title: const Text(
          'Game Selection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        
        // --- ADDED NAVIGATION BUTTONS ---
        automaticallyImplyLeading: false, 
        toolbarHeight: 70, // Slightly taller app bar for bigger buttons
        actions: [
          // 1. Profile Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Subtle background for hit area
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => _navigateToProfile(context),
              tooltip: 'Profile',
              iconSize: 32.0, // Big icon for easy tapping
              padding: const EdgeInsets.all(8.0),
            ),
          ),
          
          const SizedBox(width: 12.0), 

          // 2. Logout Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1), // Subtle red tint for logout
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
              tooltip: 'Logout',
              iconSize: 32.0, // Big icon for easy tapping
              color: Colors.redAccent.shade100, // Distinct color for logout
              padding: const EdgeInsets.all(8.0),
            ),
          ),
          
          const SizedBox(width: 16.0), 
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout logic
          // Use 2 columns for phones (width < 600), 3 for wider screens
          int crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
          double paddingValue = constraints.maxWidth * 0.05; // 5% padding on sides

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingValue), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 25.0), 
                  child: Text(
                    'Find Your Teammates!',
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.w900, 
                      fontStyle: FontStyle.italic, // Added italic for flair
                      color: Colors.white,
                      letterSpacing: 1.2, // Increased spacing for a header look
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4.0,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                Divider(
                  color: accentBlue.withOpacity(0.5), // Using the Medium Blue accent
                  height: 30,
                  thickness: 2,
                  indent: 60,
                  endIndent: 60,
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), 
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(), // Better feel on phone
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, 
                        crossAxisSpacing: 20.0, 
                        mainAxisSpacing: 20.0, 
                        // Adjust ratio slightly to ensure cards are substantial
                        childAspectRatio: 0.9, 
                      ),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return GameSelectionWidget(
                          name: game['name'] as String,
                          icon: game['icon'] as IconData,
                          color: game['color'] as Color,
                          onTap: () => _navigateToGameServer(context, game['name'] as String),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}