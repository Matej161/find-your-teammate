import 'package:flutter/material.dart';

class HomeNavButtonWidget extends StatelessWidget {
  const HomeNavButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Increased padding to push it away from the status bar edge
      padding: const EdgeInsets.only(top: 40.0, right: 25.0), // Slightly more right padding
      child: TextButton(
        onPressed: () {
          // Navigate to the login page
          Navigator.of(context).pushNamed('/login');
        },
        style: TextButton.styleFrom(
          // 1. INCREASED OPACITY: Changed from 0.4 to 0.7 for much less transparency
          backgroundColor: Colors.white.withOpacity(0.7),
          
          // 2. ADDED BORDER: A thin white border makes the button edge pop against the blue gradient
          side: const BorderSide(
            color: Colors.white, 
            width: 1.5,
          ),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Slightly more rounded corners
          ),
          // Increased horizontal and vertical padding for a larger button appearance
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14), 
          minimumSize: const Size(0, 50), // Increased minimum height
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            // Kept the strong blue color for high contrast on the button itself
            color: Color(0xFF1565C0), 
            fontSize: 17, // Slightly larger font size
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}