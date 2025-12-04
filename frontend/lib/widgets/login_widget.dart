import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Custom colors for a friendly, light look
  final Color primaryColor = const Color(0xFF4895ef); // Blue
  final Color secondaryColor = const Color(0xFF4cc9f0); // Light Blue/Teal
  final Color accentColor = const Color(0xFFF77F00); // Orange

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizing based on screen width/height
    // Ensure the form takes a maximum of 90% of the screen width on mobile, 
    // but caps at 380 for larger devices.
    final responsiveWidth = screenWidth * 0.9 > 380 ? 380.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth * 0.05; // 5% margin on each side
    final innerPadding = screenWidth * 0.06; // 6% padding inside the box
    final titleFontSize = screenWidth * 0.07; // ~28px on a Pixel 7 (411px wide)
    final inputFontSize = screenWidth * 0.04; 

    // Use ConstrainedBox to ensure the widget is responsive but never too wide
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: responsiveWidth, // Responsive width up to 380
      ),
      child: Container(
        // Use responsive horizontal margin
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        // Use responsive inner padding
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Consistent rounding
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome Back!",
              textAlign: TextAlign.center,
              style: TextStyle(
                // Responsive font size for the title
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B5998),
              ),
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive vertical spacing

            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Forgot Password Link
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/forgottenpassword');
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  // Responsive vertical padding
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // Slightly smaller responsive font
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Login Button with Gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  print('Attempting login for: $email');
                  // TODO: Implement actual login logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Important for gradient visibility
                  shadowColor: Colors.transparent, // Remove default shadow
                  // Responsive vertical padding for a comfortable tap target
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive vertical spacing

            // Register Navigation Link (Made Bigger and Mobile-Friendly)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
                ),
                // Wrap the GestureDetector in a Padding for a larger, more comfortable tap area
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to register screen
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Slightly larger font size
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}