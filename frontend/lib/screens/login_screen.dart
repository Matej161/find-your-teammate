import 'package:flutter/material.dart';
import 'package:frontend/widgets/forgotpassword_widget.dart';
import '../widgets/login_widget.dart'; // Import the widget

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // The Scaffold background will handle the light background color
      // (assuming you set the theme, or the parent of this screen does).
      // If you want to explicitly ensure the light grey background (0xFFF5F5F5)
      // from your previous version, you can set:
      backgroundColor: Color(0xFF36413E), 
      body: Center(
        child: LoginWidget(),
        
      ),
    );
  }
}