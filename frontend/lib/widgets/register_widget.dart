import 'package:flutter/material.dart';
import '../services/login_service.dart';

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
  final _loginService = LoginService();
  
  bool _isLoading = false;
  String? _errorMessage;

  // Custom colors matching the Login theme
  final Color primaryColor = const Color(0xFF4895ef); // Blue
  final Color secondaryColor = const Color(0xFF4cc9f0); // Light Blue/Teal

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Basic validation
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    // Email validation
    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    // Password match validation
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Password length validation
    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long';
      });
      return;
    }

    // Password complexity validation
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() {
        _errorMessage = 'Password must contain at least one uppercase letter';
      });
      return;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(() {
        _errorMessage = 'Password must contain at least one lowercase letter';
      });
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        _errorMessage = 'Password must contain at least one number';
      });
      return;
    }

    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};\':"\\|,.<>\/?]').hasMatch(password)) {
      setState(() {
        _errorMessage = 'Password must contain at least one special character (!@#\$%^&*()_+-=[]{}|;\':"\\,.<>/? etc.)';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _loginService.register(email, password, username);

      if (response.success) {
        // Registration successful - navigate to login screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        // Registration failed - show error message
        setState(() {
          _isLoading = false;
          _errorMessage = response.message ?? 'Registration failed. Please try again.';
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
    // 1. Get screen dimensions for responsive scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 2. Define responsive measurements
    final responsiveWidth = screenWidth * 0.9 > 380 ? 380.0 : screenWidth * 0.9;
    final horizontalMargin = screenWidth * 0.05; 
    final innerPadding = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.07; // Responsive title size
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
                hintText: "Min 6 chars, 1 uppercase, 1 lowercase, 1 number, 1 special",
                prefixIcon: Icon(Icons.lock, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                helperText: "Must include: uppercase, lowercase, number, special char",
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(fontSize: inputFontSize),
              onSubmitted: (_) => _handleRegister(),
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_reset, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

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

            // Register Button with Gradient
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
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  // Larger vertical padding for easier touching on mobile
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "R E G I S T E R",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Big, readable text
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // Login Navigation Link
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