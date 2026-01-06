import 'package:flutter/material.dart';
import 'game_server_screen.dart';
import '../widgets/game_selection_widget.dart';
import '../widgets/navbar_widget.dart'; // Import your new widget

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors: Professional Ice Blue palette
    const Color brandNavy = Color(0xFF102060);
    const Color iceBackground = Color(0xFFE8F1F9); 
    const Color brandBlue = Color(0xFF1E88E5);

    final List<Map<String, dynamic>> games = [
      {'name': 'League of Legends', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/21779-285x380.jpg'},
      {'name': 'Fortnite', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/33214-285x380.jpg'},
      {'name': 'Minecraft', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/27471_IGDB-285x380.jpg'},
      {'name': 'Rocket League', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/30921-285x380.jpg'},
      {'name': 'Valorant', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/516575-285x380.jpg'},
      {'name': 'Counter-Strike 2', 'url': 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/library_600x900_2x.jpg'},
      {'name': 'Overwatch 2', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/515025-285x380.jpg'},
      {'name': 'Apex Legends', 'url': 'https://static-cdn.jtvnw.net/ttv-boxart/511224-285x380.jpg'},
    ];

    return Scaffold(
      backgroundColor: iceBackground,
      // REPLACED: Hardcoded AppBar is now your reusable widget
      appBar: const NavbarWidget(title: 'SQUADUP'), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TOP BANNER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [brandBlue, brandNavy],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your Squad',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select a lobby and start gaming.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- GRID SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return GameSelectionWidget(
                    name: games[index]['name'],
                    bannerUrl: games[index]['url'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameServerScreen(gameName: games[index]['name']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}