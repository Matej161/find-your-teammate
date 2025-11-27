import 'package:flutter/material.dart';
import 'package:frontend/widgets/home_nav_button_widget.dart';
// Import the specific widget you want to place in the top right
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The Scaffold provides the basic structure (like the background).
    // The body uses a Stack to layer multiple widgets on top of each other.
    return const Scaffold( 
      backgroundColor: Color(0xFFFFEEDD),
      body: Stack(
        children: [
          // 1. Main Content: This widget is centered and serves as the main screen body.
          Center(
            child: Text(
              'Hello, welcome to our app!',
              style: TextStyle(fontSize: 24, color: Colors.indigo),
            ),
          ),
          
          // 2. Positioned Button: The Align widget places its child 
          // (your button) relative to the Stack.
          Align(
            alignment: Alignment.topRight,
            child: HomeNavButtonWidget(),
          ),
        ],
      ),
    );
  }
}