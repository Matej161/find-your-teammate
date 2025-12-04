import 'package:flutter/material.dart';
import '../widgets/register_widget.dart';
import '../widgets/go_home_button.dart'; 

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  // Same friendly gradient as LoginScreen for consistency
  final List<Color> backgroundColors = const [
    Color(0xFFBDE0FE), // Light Blue
    Color(0xFFA0C4FF), // Slightly darker blue
  ];

  @override
  Widget build(BuildContext context) {
    // Get media query data for responsive calculations
    final mediaQuery = MediaQuery.of(context);
    
    // Calculate responsive safe-area padding
    // Use the system's safe area padding (status bar height) plus a responsive margin
    final double safeTopPadding = mediaQuery.padding.top;
    final double verticalMargin = mediaQuery.size.height * 0.02;
    final double topPadding = safeTopPadding + verticalMargin;
    // Responsive margin for the left side
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
            // 1. Centered Register Form
            // Wrapped in Center + SingleChildScrollView for mobile-friendly keyboard handling
            const Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), // Smooth scrolling feel
                child: Padding(
                  // Ensure there's vertical space so the form doesn't hug the edges on tall screens
                  padding: EdgeInsets.symmetric(vertical: 40.0), 
                  child: RegisterWidget(),
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