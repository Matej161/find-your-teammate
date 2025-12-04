import 'package:flutter/material.dart';
import '../widgets/forgot_password_widget.dart'; // Import the new widget

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // We use a light background color for contrast on the web
      backgroundColor: Color(0xFFE8F0F7), 
      body: Center(
        child: ForgotPasswordWidget(), // Display the new form widget
      ),
    );
  }
}