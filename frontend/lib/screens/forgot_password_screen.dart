import 'package:flutter/material.dart';
import '../widgets/forgot_password_widget.dart';
import '../widgets/go_home_button.dart'; // Ensure you have this GoHomeButton widget for navigation

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  // Use the consistent friendly gradient
  final List<Color> backgroundColors = const [
    Color(0xFFBDE0FE), // Light Blue
    Color(0xFFA0C4FF), // Slightly darker blue
  ];

  @override
  Widget build(BuildContext context) {
    // Get media query data for responsive calculations
    final mediaQuery = MediaQuery.of(context);
    
    // Calculate responsive safe-area padding
    final double safeTopPadding = mediaQuery.padding.top;
    final double verticalMargin = mediaQuery.size.height * 0.02;
    final double topPadding = safeTopPadding + verticalMargin;
    final double leftPadding = mediaQuery.size.width * 0.03;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Full screen gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 1. Centered Widget
            // Wrapped in SingleChildScrollView for keyboard safety on small screens
            const Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), 
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0), 
                  child: ForgotPasswordWidget(),
                ),
              ),
            ),
            
            // 2. Go Home Button positioned on top left with dynamic, safe padding
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
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