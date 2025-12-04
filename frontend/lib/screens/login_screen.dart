import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';
import '../widgets/go_home_button.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Define the friendly light gradient colors
  final List<Color> backgroundColors = const [
    Color(0xFFBDE0FE), // Light Blue - top/left
    Color(0xFFA0C4FF), // Slightly darker blue - bottom/right
  ];

  @override
  Widget build(BuildContext context) {
    // Get media query data once
    final mediaQuery = MediaQuery.of(context);
    
    // Calculate responsive padding:
    // 1. top: Use the system's safe area padding (status bar height) 
    //    plus a small responsive margin (e.g., 2% of screen height)
    final double safeTopPadding = mediaQuery.padding.top;
    final double verticalMargin = mediaQuery.size.height * 0.02; // 2% of screen height
    final double topPadding = safeTopPadding + verticalMargin;

    // 2. left: Use a small responsive margin (e.g., 3% of screen width)
    final double leftPadding = mediaQuery.size.width * 0.03; // 3% of screen width

    return Scaffold(
      // Ensure Scaffold background is transparent so the Container gradient shows
      backgroundColor: Colors.transparent, 
      
      // Use the body to create a full-screen gradient effect
      body: Container(
        // Apply the pleasant linear gradient to the entire background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Use Stack to layer the back button over the centered form
        child: Stack(
          children: [
            // 1. Centered Login Form
            const Center(
              // SingleChildScrollView handles keyboard display gracefully
              child: SingleChildScrollView(
                child: LoginWidget(),
              ),
            ),
            
            // 2. Go Home Button positioned on top left with dynamic padding
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                // Use the calculated responsive and safe area padding
                padding: EdgeInsets.only(top: topPadding, left: leftPadding),
                child: GoHomeButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}