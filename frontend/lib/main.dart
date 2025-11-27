import 'package:flutter/material.dart';
import 'package:frontend/screens/forgotpassword_screen.dart';
import 'package:frontend/screens/home_screen.dart';
// Required for clean URL paths (removes the '#' from web URLs)
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  // Call setPathUrlStrategy() to enable clean URLs (e.g., /login instead of /#/login)
  // NOTE: If you see an error here, you must add flutter_web_plugins: to your pubspec.yaml file

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your teammate',
      // Define a simple theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set the default screen for when the app first loads
      initialRoute: '/home', 
      routes: {
        // Defines the paths for your main screens
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}