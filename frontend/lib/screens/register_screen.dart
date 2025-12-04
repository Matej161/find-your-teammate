import 'package:flutter/material.dart';
import '../widgets/register_widget.dart'; // Import the new widget

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF36413E), 
      body: Center(
        // Use the same light background color for consistency
        child: RegisterWidget(), 
      ),
    );
  }
}