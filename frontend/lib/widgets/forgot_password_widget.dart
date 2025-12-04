import 'package:flutter/material.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final _emailController = TextEditingController();
  bool _isHoveringLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Function to simulate sending the reset email
  void _handleResetPassword() {
    final email = _emailController.text;
    if (email.isNotEmpty) {
      print('Sending password reset link to: $email');
      // In a real app, you would call an API service here.
      // For now, we'll just navigate back to the login screen after a small delay.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email (simulated).'),
          duration: const Duration(seconds: 3),
        ),
      );
      // Navigate back to login
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Reset Password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your email address to receive a password reset link.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Email Field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Send Reset Link Button
            ElevatedButton(
              onPressed: _handleResetPassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Back to Login Link
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHoveringLogin = true),
              onExit: (_) => setState(() => _isHoveringLogin = false),
              child: GestureDetector(
                onTap: () {
                  // Navigate back to the login page
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Center(
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                      fontSize: 16,
                      color: _isHoveringLogin ? Colors.blue[800] : Colors.blue,
                      decoration: _isHoveringLogin
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}