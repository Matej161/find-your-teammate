import 'package:flutter/material.dart';

class GameServerScreen extends StatelessWidget {
  // Parameter to receive the game name from the selection screen
  final String gameName;

  const GameServerScreen({
    super.key,
    required this.gameName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gameName),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
    
    );
  }
}