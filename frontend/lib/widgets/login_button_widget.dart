import 'package:flutter/material.dart';

class HomeNavButtonWidget extends StatelessWidget {
  const HomeNavButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Increased padding from 16.0 to ensure the button is well clear of the notch/status bar
      padding: const EdgeInsets.only(top: 40.0, right: 20.0),
      child: TextButton(
        onPressed: () {
          // Navigate to the login page
          Navigator.of(context).pushNamed('/login');
        },
        style: TextButton.styleFrom(
          // 1. INCREASED OPACITY: Changed from 0.2 to 0.4 for better visibility
          backgroundColor: Colors.white.withOpacity(0.4),
          
          // 2. ADDED BORDER: A thin white border makes the button edge pop against the blue gradient
          side: const BorderSide(
            color: Colors.white, 
            width: 1.5,
          ),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Slightly more rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12), // Slightly larger tap area
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            // Kept the strong blue color for high contrast on the button itself
            color: Color(0xFF1565C0), 
            fontSize: 16,
            fontWeight: FontWeight.w700, // Slightly bolder text
          ),
        ),
      ),
    );
  }
}