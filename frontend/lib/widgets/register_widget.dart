import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // 1. Remove existing toast if visible
    _currentToast?.remove();

    // 2. Create the OverlayEntry
    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Safe area + 10px margin
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30), // Rounded "Pill" shape
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
                Icon(icon, color: Colors.white, size: 28), // Big Icon
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Bigger Font
                      fontWeight: FontWeight.bold, // Bold Font
                      fontFamily: 'Roboto', // Default nicely readable font
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 3. Insert into the screen
    Overlay.of(context).insert(_currentToast!);

    // 4. Auto-remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_currentToast != null) {
        _currentToast?.remove();
        _currentToast = null;
      }
    });
  }

  // --- REGISTER LOGIC ---
  Future<void> _handleRegister() async {
    // 0. Basic Validation
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showTopToast('Passwords do not match', Colors.redAccent, Icons.error_outline);
      return;
    }

    if (_usernameController.text.trim().isEmpty) {
      _showTopToast('Please enter a username', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    // A. Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // B. Create User in Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Optional: Save Username
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(_usernameController.text.trim());
      }

      // C. Close loading circle
      if (mounted) Navigator.pop(context);

      if (mounted) {
        // D. SUCCESS NOTIFICATION (Top Toast)
        _showTopToast('Account Created! Welcome.', Colors.green.shade600, Icons.check_circle_outline);
        
        // E. Navigate
        Navigator.of(context).pushReplacementNamed('/gameselection');
      }

    } on FirebaseAuthException catch (e) {
      // C. Close loading circle
      if (mounted) Navigator.pop(context);

      // D. FAILURE NOTIFICATION (Top Toast)
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      }

      if (mounted) {
        _showTopToast(message, Colors.redAccent, Icons.cancel_outlined);
      }
    }
  }
  // ------------------------

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Remove toast if screen is closed to prevent errors
    _currentToast?.remove(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveWidth = screenWidth * 0.9 > 380 ? 380.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth * 0.05; 
    final innerPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.07;
    final inputFontSize = screenWidth * 0.04; 

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: responsiveWidth,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              "Create Account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B5998),
              ),
            ),
            SizedBox(height: screenHeight * 0.03), 

            // Username Field
            TextField(
              controller: _usernameController,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(fontSize: inputFontSize),
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_reset, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
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
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
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
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
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
}