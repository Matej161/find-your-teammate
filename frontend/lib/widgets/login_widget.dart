import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../SignalRContracts.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Custom colors matching the app theme
  final Color primaryColor = const Color(0xFF4895ef); // Blue
  final Color secondaryColor = const Color(0xFF4cc9f0); // Light Blue/Teal
  final Color accentColor = const Color(0xFFF77F00); // Orange

  // Track the current toast to remove it if a new one appears
  OverlayEntry? _currentToast;

  // --- CUSTOM TOP NOTIFICATION HELPER (Same as Register) ---
  void _showTopToast(String message, Color baseColor, IconData icon) {
    _currentToast?.remove();

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 15, // Safe area + margin
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          // Bouncy pop animation
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

    Overlay.of(context).insert(_currentToast!);

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (_currentToast != null) {
        _currentToast?.remove();
        _currentToast = null;
      }
    });
  }

  // --- LOGIN LOGIC (Preserved SignalR Logic) ---
  Future<void> _handleLogin() async {
    // Basic UI Validation
    if (_emailController.text.isEmpty) {
       _showTopToast("Email needed!", const Color(0xFFFF9F1C), Icons.mark_email_unread);
       return;
    }

    if (_passwordController.text.isEmpty) {
      _showTopToast("Password cannot be empty", const Color(0xFFFF9F1C), Icons.key_off);
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      SignalRContracts signalRContracts = SignalRContracts();
      
      // Connect to the service
      await signalRContracts.connect();
      
      // Server call for login validation
      bool canLogin = await signalRContracts.canLogin(
        _emailController.text, 
        _passwordController.text
      );

      // Close loader
      if (mounted) Navigator.pop(context);

      if (!mounted) return;

      if (canLogin) {
        String guid = await signalRContracts.login(_emailController.text);
        _showTopToast('Welcome back! 👋', const Color(0xFF06D6A0), Icons.waving_hand); // Teal/Green
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
                    '/gameselection',
                    arguments: guid, // Zde pošleš své GUID
                  );
        }
      } else {
        _showTopToast("Invalid email or password", const Color(0xFFFF0054), Icons.lock_open); // Red/Pink
      }
    } catch (e) {
      // Close loader if crash
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      
      if (mounted) _showTopToast("Connection Error", Colors.red, Icons.wifi_off);
      print("Login Error: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _currentToast?.remove(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final responsiveWidth = screenWidth * 0.9 > 400 ? 400.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth * 0.05; 
    final innerPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.075;
    
    // Increased Font Size for Input Text for better mobile readability
    final inputFontSize = screenWidth * 0.048; 

    final TextStyle inputTextStyle = TextStyle(
      fontSize: inputFontSize,
      fontWeight: FontWeight.w600, 
      color: const Color(0xFF2d3436), // High contrast text
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
              "Welcome Back!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B5998),
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.04), 

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
            const SizedBox(height: 10),

            // Forgot Password Lin

            // Login Button
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
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "L O G I N",
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

            // Register Navigation Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/register');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "REGISTER",
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