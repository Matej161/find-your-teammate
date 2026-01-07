import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../SignalRContracts.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Custom colors matching the Login theme
  final Color primaryColor = const Color(0xFF4895ef); // Blue
  final Color secondaryColor = const Color(0xFF4cc9f0); // Light Blue/Teal

  // Track the current toast to remove it if a new one appears
  OverlayEntry? _currentToast;

  // --- CUSTOM TOP NOTIFICATION HELPER ---
  void _showTopToast(String message, Color bgColor, IconData icon) {
    _currentToast?.remove();

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentToast!);

    Future.delayed(const Duration(seconds: 3), () {
      if (_currentToast != null) {
        _currentToast?.remove();
        _currentToast = null;
      }
    });
  }

  // --- REGISTER LOGIC ---
  Future<void> _handleRegister() async {
    SignalRContracts signalRContracts = SignalRContracts();
    await signalRContracts.connect();

    if (_passwordController.text == _confirmPasswordController.text) {
      if (_passwordController.text.isNotEmpty) {
        bool canCreate = await signalRContracts.createAccount(
          _usernameController.text, 
          _emailController.text, 
          _passwordController.text
        );

        if (!mounted) return;

        if (canCreate) {
          Navigator.of(context).pushReplacementNamed('/gameselection');
        } else {
          _showTopToast("Account creation failed", Colors.redAccent, Icons.error_outline);
        }
      } else {
        _showTopToast("Password cannot be empty", Colors.orangeAccent, Icons.warning_amber_rounded);
      }
    } else {
      _showTopToast("Passwords do not match", Colors.redAccent, Icons.cancel_outlined);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _currentToast?.remove(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Optimized sizing for mobile readability
    final responsiveWidth = screenWidth * 0.9 > 400 ? 400.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth * 0.05; 
    final innerPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.075;
    
    // Increased Font Size for Input Text (approx 18-20px on mobile)
    final inputFontSize = screenWidth * 0.048; 

    // Reusable Input Style to keep the build method clean
    final TextStyle inputTextStyle = TextStyle(
      fontSize: inputFontSize,
      fontWeight: FontWeight.w600, // Semi-bold for better clarity
      color: const Color(0xFF2d3436), // High contrast dark grey/black
      letterSpacing: 0.5,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: responsiveWidth,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Create Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B5998),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.03), 

            // Username Field
            TextField(
              controller: _usernameController,
              style: inputTextStyle,
              decoration: _buildInputDecoration("Username", Icons.person),
            ),
            const SizedBox(height: 18),

            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: inputTextStyle,
              decoration: _buildInputDecoration("Email Address", Icons.email),
            ),
            const SizedBox(height: 18),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: inputTextStyle,
              decoration: _buildInputDecoration("Password", Icons.lock),
            ),
            const SizedBox(height: 18),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: inputTextStyle,
              decoration: _buildInputDecoration("Confirm Password", Icons.lock_reset),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Register Button
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
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "R E G I S T E R",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.035),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
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

  // Helper to build consistent, readable input decoration
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: primaryColor.withOpacity(0.8),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: 22),
      // Increased padding to accommodate larger text
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}