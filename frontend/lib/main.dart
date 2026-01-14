import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// restored imports
import 'package:frontend/screens/forgot_password_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// --- 1. FIREBASE IMPORTS ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- ADDED FOR NOTIFICATIONS: Import Messaging Package ---
import 'package:firebase_messaging/firebase_messaging.dart'; 

// Import the Game Selection Screen
import 'screens/game_selection_screen.dart';
import 'screens/profile_screen.dart';

// --- 2. UPDATED MAIN FUNCTION ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- ADDED FOR NOTIFICATIONS: Call the function to get/print token ---
  // We call this right after Firebase initializes so you can see the token in the console immediately.
  await getDeviceToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find your teammate',
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, 
        ),
        
        /*textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),*/
        
        scaffoldBackgroundColor: const Color(0xFF111827), 
        useMaterial3: true,
      ),

      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgottenpassword': (context) => const ForgotPasswordScreen(),
        
        '/gameselection': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return GameSelectionScreen(guid: args);
        },
        '/profile': (context) {
          // 1. Získáme argument (userId) z navigace
          final args = ModalRoute.of(context)!.settings.arguments as String;

          // 2. Předáme ho do ProfileScreen
          return ProfileScreen(userId: args);
        },
      },
    );
  }
}

// --- ADDED FOR NOTIFICATIONS: The Logic to fetch the Token ---
Future<void> getDeviceToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 1. Request Permission (Crucial for iOS/Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Fetch the token
      String? token = await messaging.getToken();
      
      // 3. Print it clearly so you can copy it from the Debug Console
      print("========================================");
      print("FCM TOKEN: $token");
      print("========================================");
    } else {
      print('User declined or has not accepted notification permissions');
    }
  } catch (e) {
    print("Error getting token: $e");
  }
}