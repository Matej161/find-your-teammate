import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse {
  final bool success;
  final String? message;
  final String? userId;
  final String? userName;

  LoginResponse({
    required this.success,
    this.message,
    this.userId,
    this.userName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}

class RegisterResponse {
  final bool success;
  final String? message;
  final String? userId;
  final String? userName;

  RegisterResponse({
    required this.success,
    this.message,
    this.userId,
    this.userName,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}

class LoginService {
  // Update this URL to match your backend API URL
  // For web: use localhost
  // For Android emulator: use http://10.0.2.2:5266
  // For iOS simulator: use http://localhost:5266
  // For physical device: use your computer's IP address
  static const String baseUrl = 'http://localhost:5266'; // Default to backend port from launchSettings.json
  
  Future<LoginResponse> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/login');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse(
          success: false,
          message: 'Server error. Please try again later.',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: 'Connection error. Please check your internet connection.',
      );
    }
  }

  Future<RegisterResponse> register(String email, String password, String userName) async {
    try {
      final url = Uri.parse('$baseUrl/api/register');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'userName': userName,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return RegisterResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 409) {
        // Conflict - user already exists
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return RegisterResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return RegisterResponse.fromJson(jsonResponse);
      } else {
        return RegisterResponse(
          success: false,
          message: 'Server error. Please try again later.',
        );
      }
    } catch (e) {
      return RegisterResponse(
        success: false,
        message: 'Connection error. Please check your internet connection.',
      );
    }
  }
}

