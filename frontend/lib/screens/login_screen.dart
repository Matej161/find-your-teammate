import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';
import '../widgets/go_home_button.dart'; // 1. Import your new widget

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C956C),
      // 2. Add an AppBar just for the button
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make it see-through
        elevation: 0, // Remove the shadow
        
        // 3. Use your custom widget here!
        leading: const GoHomeButton(), 
      ),
      
      body: const Center(
        child: LoginWidget(),
      ),
    );
  }
}