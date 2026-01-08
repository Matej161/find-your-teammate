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

  // --- CUSTOM TOP NOTIFICATION HELPER (V2) ---
  void _showTopToast(String message, Color baseColor, IconData icon) {
    // 1. Remove existing toast if visible
    _currentToast?.remove();

    // 2. Create the OverlayEntry with Animation
    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 15, // Safe area + margin
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          // Add a bouncy pop animation
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    // Gradient for a "Colorful" look
                    gradient: LinearGradient(
                      colors: [baseColor, baseColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: baseColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            // Interesting Font Style: Heavy weight + Spacing
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 0.5,
                            fontFamily: 'Roboto', 
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black12,
                              )
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    // 3. Insert into the screen
    Overlay.of(context).insert(_currentToast!);

    // 4. Auto-remove after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (_currentToast != null) {
        _currentToast?.remove();
        _currentToast = null;
      }
    });
  }

  // --- REGISTER LOGIC (Restored SignalR Logic) ---
  Future<void> _handleRegister() async {
    // 1. Basic Validation UI Checks
    if (_usernameController.text.trim().isEmpty) {
      _showTopToast("Username needed!", const Color(0xFFFF9F1C), Icons.face_retouching_natural); // Orange
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showTopToast("Email can't be empty!", const Color(0xFFFF9F1C), Icons.mark_email_unread); // Orange
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showTopToast("Type a password!", const Color(0xFFFF9F1C), Icons.key_off); // Orange
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showTopToast("Passwords don't match!", const Color(0xFFFF0054), Icons.compare_arrows); // Bright Red/Pink
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Initialize SignalR Connection (Your Original Logic)
      SignalRContracts signalRContracts = SignalRContracts();
      await signalRContracts.connect();

      // 3. Call Create Account on Backend
      bool canCreate = await signalRContracts.createAccount(
        _usernameController.text, 
        _emailController.text, 
        _passwordController.text
      );

      // Close loader
      if (mounted) Navigator.pop(context);

      if (!mounted) return;

      if (canCreate) {
        // Success!
        _showTopToast("Account Created! 🚀", const Color(0xFF06D6A0), Icons.rocket_launch); // Vibrant Teal/Green
        
        // Wait a tiny bit so they see the toast before navigating
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.of(context).pushReplacementNamed('/gameselection');
      } else {
        // Backend returned false (Generic error)
        _showTopToast("Account creation failed", const Color(0xFFFF0054), Icons.error_outline);
      }
    } catch (e) {
      // Close loader if crash
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      
      if (mounted) _showTopToast("Connection Error", Colors.red, Icons.wifi_off);
      print("Register Error: $e");
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
    
    // Increased Font Size for Input Text
    final inputFontSize = screenWidth * 0.048; 

    // Reusable Input Style
    final TextStyle inputTextStyle = TextStyle(
      fontSize: inputFontSize,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF2d3436),
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