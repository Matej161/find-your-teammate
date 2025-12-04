import 'package:flutter/material.dart';

class HomeNavButtonWidget extends StatelessWidget {
  const HomeNavButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define responsive padding and font size based on screen dimensions.
    // We use a small fraction of the screen width/height for relative sizing.
    // These ratios ensure the button looks good on various devices.
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final verticalPadding = screenHeight * 0.02;  // 2% of screen height
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding, 
      vertical: verticalPadding * 0.75, // Make button vertical padding slightly smaller
    );
    final topOffset = screenHeight * 0.05; // 5% from the top
    final rightOffset = screenWidth * 0.04; // 4% from the right

    return Padding(
      // Use responsive padding for precise positioning
      padding: EdgeInsets.only(top: topOffset, right: rightOffset),
      child: TextButton(
        onPressed: () {
          // Navigate to the login page when the button is pressed
          Navigator.of(context).pushReplacementNamed('/login');
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Slightly reduced corner radius
          ),
          padding: buttonPadding,
        ),
        child: Text(
          "Login / Register",
          style: TextStyle(
            color: Colors.white,
            // Use responsive font size
            fontSize: screenWidth * 0.04, // 4% of screen width for the font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}