import 'package:flutter/material.dart';

// --- 1. FIREBASE IMPORTS ---
// Required to initialize the Firebase "Engine"
import 'package:firebase_core/firebase_core.dart';
// This file was created by the 'flutterfire configure' command
// It contains the API keys for Android and iOS
import 'firebase_options.dart';

// Restored imports
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// Import the Game Selection Screen
import 'screens/game_selection_screen.dart';

// --- 2. UPDATED MAIN FUNCTION ---
// We add 'async' because connecting to Firebase takes a split second,
// and we must wait for it to finish before showing the app.
void main() async {
  // This line ensures the "glue" between the widgets and the engine is ready.
  // We MUST call this if we are doing anything asynchronous (like `await`) in main().
  WidgetsFlutterBinding.ensureInitialized();

  // This connects your specific app to the Firebase project using the
  // configuration found in firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your teammate',
      
      // Theme settings to match the dark look of your app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Enforces dark mode
        ),
        scaffoldBackgroundColor: const Color(0xFF111827), // Deep dark background
        useMaterial3: true,
      ),

      // Currently set to Game Selection for testing. 
      // Change this to '/login' or '/home' when you want to start normally.
      initialRoute: '/home', 
      
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