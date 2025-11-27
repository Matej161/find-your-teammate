import 'package:flutter/material.dart';

class HomeNavButtonWidget extends StatelessWidget {
  const HomeNavButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap the button in Padding to ensure it's not flush against the screen edges.
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 16.0), // Added more top padding for safety/status bar area
      child: TextButton(
        onPressed: () {
          // Navigate to the login page when the button is pressed
          // Using pushReplacementNamed for clean navigation history
          Navigator.of(context).pushReplacementNamed('/login');
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal.withOpacity(0.9), // Slightly opaque background for a modern look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        ),
        child: const Text(
          "Login / Register",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}