import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> checkInput(String username, String password) async {
  final String apiUrl = 'api.yourserver.com'; 

  // DUCK/accounts CHANGE LINK HERE IMPORTANT

  try {

    // Pulls username and password from server response
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Successful login
      // You would typically store the returned token/user data here (e.g., using shared_preferences)
      debugPrint('Login successful: ${response.body}');
      return true;
    } else {
      debugPrint('Login failed: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Handle network errors or exceptions
    debugPrint('An error occurred: $e');
    return false;
  }
}
