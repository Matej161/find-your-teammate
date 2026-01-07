import 'package:flutter/material.dart';
import '../services/login_service.dart';
import '../services/auth_service.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginService = LoginService();
  final _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;

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

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    // Email validation
    if (!email.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _loginService.login(email, password);

      if (response.success) {
        // Save user session
        if (response.userId != null && response.userName != null) {
          await _authService.saveUserSession(response.userId!, response.userName!);
        }
        
        // Login successful - navigate to home screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        // Login failed - show error message
        setState(() {
          _isLoading = false;
          _errorMessage = response.message ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive sizing
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
              "Welcome Back!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF3B5998),
              ),
            ),
            SizedBox(height: screenHeight * 0.04), 

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
              onSubmitted: (_) => _handleLogin(),
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Error Message Display
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Forgot Password Link
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/forgottenpassword');
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, 
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
<<<<<<< HEAD
                onPressed: () {
                  // Simply navigate to the Game Selection screen on click
                  // In a real app, you would validate the email/password first
                  Navigator.of(context).pushReplacementNamed('/gameselection');
                },
=======
                onPressed: () {
                  // Simply navigate to the Game Selection screen on click
                  // In a real app, you would validate the email/password first
                  Navigator.of(context).pushReplacementNamed('/gameselection');
                },
>>>>>>> b5bf01446a2dd0dd11a0e6b1096506750b9e72b9
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, 
                  shadowColor: Colors.transparent, 
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
<<<<<<< HEAD
                child: Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
=======
                child: Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
>>>>>>> b5bf01446a2dd0dd11a0e6b1096506750b9e72b9
              ),
            ),
            SizedBox(height: screenHeight * 0.04), 

            // Register Navigation Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
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
}