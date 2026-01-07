import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showTopToast('Please enter a username', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    if (email.isEmpty) {
      _showTopToast('Please enter an email address', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    // Email format validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _showTopToast('Please enter a valid email address', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    if (password.isEmpty) {
      _showTopToast('Please enter a password', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    // Firebase requires password to be at least 6 characters
    if (password.length < 6) {
      _showTopToast('Password must be at least 6 characters', Colors.orangeAccent, Icons.warning_amber_rounded);
      return;
    }

    if (password != confirmPassword) {
      _showTopToast('Passwords do not match', Colors.redAccent, Icons.error_outline);
      return;
    }

    // A. Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        if (mounted) Navigator.pop(context);
        _showTopToast('Firebase not initialized. Please restart the app.', Colors.redAccent, Icons.error_outline);
        return;
      }

      // Get the default Firebase app and auth instance
      final FirebaseApp app = Firebase.app();
      final FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);

      // B. Create User in Firebase
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optional: Save Username
      if (userCredential.user != null) {
        try {
          await userCredential.user!.updateDisplayName(username);
        } catch (e) {
          print('Error updating display name: $e');
          // Continue even if display name update fails
        }
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

      // Log the full error for debugging
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
      print('Firebase Auth Error Details: ${e.toString()}');

      // D. FAILURE NOTIFICATION (Top Toast)
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Email/password accounts are not enabled. Please enable it in Firebase Console.';
      } else if (e.code == 'invalid-api-key') {
        message = 'Invalid API key. Please check Firebase configuration.';
      } else if (e.code == 'network-request-failed') {
        message = 'Network error. Please check your internet connection.';
      } else {
        message = 'Registration failed: ${e.message ?? e.code}';
      }

      if (mounted) {
        _showTopToast(message, Colors.redAccent, Icons.cancel_outlined);
      }
    } catch (e, stackTrace) {
      // C. Close loading circle
      if (mounted) Navigator.pop(context);

      // Log the full error for debugging
      print('General Error: $e');
      print('Stack Trace: $stackTrace');

      // Handle any other errors (network, etc.)
      if (mounted) {
        _showTopToast('Registration failed: ${e.toString()}. Please check your connection and try again.', Colors.redAccent, Icons.cancel_outlined);
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
                Flexible(
                  child: Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
                  ),
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