import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// restored imports
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/auth_service.dart';

// Import the Game Selection Screen
import 'screens/game_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  Widget? _initialHome;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final isLoggedIn = await _authService.isLoggedIn();
    setState(() {
      _initialHome = isLoggedIn ? const HomeScreen() : const LoginScreen();
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
      
      // Theme settings to match the dark look of your app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Enforces dark mode
        ),
        
        /*textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),*/
        
        scaffoldBackgroundColor: const Color(0xFF111827), // Deep dark background
        useMaterial3: true,
      ),
<<<<<<< HEAD
      // Currently set to Game Selection for testing. 
      // Change this to '/login' or '/home' when you want to start normally.
      initialRoute: '/home',
=======

      // Currently set to Game Selection for testing. 
      // Change this to '/login' or '/home' when you want to start normally.
      initialRoute: '/home', 
      
>>>>>>> b5bf01446a2dd0dd11a0e6b1096506750b9e72b9
      routes: {
        // Restored routes so login/register works
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgottenpassword': (context) => const ForgotPasswordScreen(),
        
        // The new screen
        '/gameselection': (context) => const GameSelectionScreen(),
        
        // NOTE: '/gameserver' is NOT here because it is dynamic (handled in game_selection_screen.dart)
      },
    );
  }
}