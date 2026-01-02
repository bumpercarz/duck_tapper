import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration loader
/// Loads environment variables from .env files based on the selected environment
///
/// Environments:
/// - development: For local development (Android Emulator: http://10.0.2.2:8080)
/// - staging: For testing on physical devices (uses local network IP)
/// - production: For deployed API (uses production URL)
class Environment {
  /// Get the API base URL from environment variables
  /// Defaults to Android Emulator localhost if not set
  ///
  /// Expected values:
  /// - Development: http://10.0.2.2:8080 (Android Emulator)
  /// - Staging: http://192.168.x.x:8080 (Physical device on WiFi)
  /// - Production: https://api.bookstore.com
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';

  /// API request timeout in seconds
  /// Defaults to 30 seconds if not set
  static int get apiTimeout =>
      int.parse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30');

  /// Enable/disable request/response logging
  /// Useful for debugging API calls during development
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true';

  /// Load environment variables from the specified .env file
  ///
  /// Usage:
  /// ```dart
  /// await Environment.load(env: 'development'); // Loads .env.development
  /// await Environment.load(env: 'staging');     // Loads .env.staging
  /// await Environment.load(env: 'production');  // Loads .env.production
  /// ```
  ///
  /// The environment should be selected based on deployment target:
  /// - 'development' for Android Emulator / iOS Simulator
  /// - 'staging' for physical device testing
  /// - 'production' for release builds
  static Future<void> load({String env = 'development'}) async {
    await dotenv.load(fileName: '.env.$env');

    if (enableLogging) {
      debugPrint('🌍 Environment loaded: $env');
      debugPrint('🔗 API Base URL: $baseUrl');
      debugPrint('⏱️  API Timeout: ${apiTimeout}s');
    }
  }
}
