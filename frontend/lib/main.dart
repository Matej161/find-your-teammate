import 'package:flutter/material.dart';
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/home_screen.dart';
// Required for clean URL paths (removes the '#' from web URLs)
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_service.dart';

void main() {
  // Call setPathUrlStrategy() to enable clean URLs (e.g., /login instead of /#/login)
  // NOTE: If you see an error here, you must add flutter_web_plugins: to your pubspec.yaml file

  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  String? _initialRoute;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final isLoggedIn = await _authService.isLoggedIn();
    setState(() {
      _initialRoute = isLoggedIn ? '/home' : '/login';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading screen while checking auth state
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your teammate',
      // Define a simple theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set the default screen based on auth state
      initialRoute: _initialRoute ?? '/login', 
      routes: {
        // Defines the paths for your main screens
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgottenpassword': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}