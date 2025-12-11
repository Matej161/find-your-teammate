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
    // If you had a /profile route: Navigator.of(context).pushNamed('/profile');
  }

  // --- Logout Action (Navigates to /home) ---
  void _logout(BuildContext context) {
    // Navigate to the /home route and clear navigation stack (logging out)
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> games = [
      {'name': 'League of Legends', 'icon': Icons.security, 'color': Colors.blue},
      {'name': 'Fortnite', 'icon': Icons.sports_esports, 'color': Colors.purpleAccent},
      {'name': 'Minecraft', 'icon': Icons.landscape, 'color': Colors.lightGreen},
      {'name': 'Rocket League', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Selection'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        
        // --- ADDED NAVIGATION BUTTONS ---
        // By setting automaticallyImplyLeading to false, we remove the default back arrow.
        automaticallyImplyLeading: false, 
        actions: [
          // 1. Profile Button
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _navigateToProfile(context),
            tooltip: 'Profile',
            iconSize: 30.0, // Made the icon bigger
          ),
          
          // Added spacing between buttons
          const SizedBox(width: 15.0), 

          // 2. Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
            iconSize: 30.0, // Made the icon bigger
          ),
          // Added a small margin for the edge of the screen
          const SizedBox(width: 8.0), 
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 25.0), 
              child: Text(
                'Choose Your Adventure!',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: Colors.white,
                  letterSpacing: 0.5, 
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const Divider(
              color: Colors.white30,
              height: 20,
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            
            const SizedBox(height: 10), 
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0), 
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 18.0, 
                    mainAxisSpacing: 18.0, 
                    childAspectRatio: 0.95, 
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
      ),
    );
  }
}