import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/environment.dart';

/// API Service - HTTP client wrapper for Dart Frog API
///
/// This service connects to the Dart Frog API running at BASE_URL (loaded from .env files)
///
/// Base URL Configuration:
/// - Android Emulator: http://10.0.2.2:8080 (maps to host's localhost)
/// - iOS Simulator: http://localhost:8080
/// - Physical Device: http://YOUR_LOCAL_IP:8080 (e.g., http://192.168.1.100:8080)
/// - Production: https://api.bookstore.com
///
/// API Endpoints (from Dart Frog backend - duck_api/routes/):
/// - GET    /accounts         → List all authors
/// - POST   /accounts         → Create new author
/// - GET    /accounts/:id     → Get single author
/// - PUT    /accounts/:id     → Update author
/// - DELETE /accounts/:id     → Delete author (soft delete)
/// - GET    /ducks           → List all books
/// - POST   /ducks           → Create new book
/// - GET    /ducks/:id       → Get single book
/// - PUT    /ducks/:id       → Update book
/// - DELETE /ducks/:id       → Delete book (soft delete)
///
/// Error Handling:
/// - HTTP 400: Validation errors from API (e.g., "Username already exists")
///   * Thrown by: duck_api/lib/services/*_service.dart (validate* methods)
///   * Caught in: duck_api/routes/**/index.dart (on ValidationException)
///
/// - HTTP 404: Resource not found (e.g., account/duck doesn't exist)
///
/// - HTTP 500: Server error (unexpected error in API)
///
/// - SocketException: Connection refused (API not running, wrong BASE_URL)
///
/// - TimeoutException: Request took longer than API_TIMEOUT_SECONDS

class ApiService {
  /// Base URL loaded from environment variables (.env files)
  String get baseUrl => Environment.baseUrl;

  /// Timeout duration for API requests
  Duration get timeout => Duration(seconds: Environment.apiTimeout);

  /// GET request to fetch data from API
  ///
  /// Throws:
  /// - ApiException: For API errors (400, 404, 500)
  /// - SocketException: For connection errors
  /// - TimeoutException: For timeout errors
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    if (Environment.enableLogging) {
      print('📤 GET Request: $url');
    }

    try {
      final response = await http.get(url).timeout(timeout);

      if (Environment.enableLogging) {
        print('📥 GET Response: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      return _handleResponse(response);
    } on SocketException {
      _logError('Connection refused. Is the API running at $baseUrl?');
      throw ApiException(
        'Cannot connect to API. Make sure the Dart Frog server is running.',
        0,
      );
    } on HttpException {
      _logError('HTTP error occurred');
      throw ApiException('HTTP error occurred', 0);
    } catch (e) {
      _logError('Unexpected error: $e');
      rethrow;
    }
  }

  /// POST request to create new resources
  ///
  /// Example usage:
  /// ```dart
  /// final response = await apiService.post('/accounts', {
  ///   'username': 'Mico',
  ///   'password': 'micopassword'
  /// });
  /// Calls: POST http://BASE_URL/accounts
  /// Body: {username, password}
  /// Returns: {message: 'Account created successfully', id: 1}
  /// API Handler: duck_api/routes/accounts/index.dart (POST method)
  /// Validation: duck_api/lib/services/account_service.dart → validateCreateAccount()
  /// ```
  ///
  /// Throws:
  /// - ApiException(400): Validation error (e.g., "Username already exists")
  /// - ApiException(500): Server error
  /// - SocketException: Connection error
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    if (Environment.enableLogging) {
      print('📤 POST Request: $url');
      print('   Body: ${jsonEncode(data)}');
    }

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      if (Environment.enableLogging) {
        print('📥 POST Response: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      return _handleResponse(response);
    } on SocketException {
      _logError('Connection refused. Is the API running at $baseUrl?');
      throw ApiException(
        'Cannot connect to API. Make sure the Dart Frog server is running.',
        0,
      );
    } on HttpException {
      _logError('HTTP error occurred');
      throw ApiException('HTTP error occurred', 0);
    } catch (e) {
      _logError('Unexpected error: $e');
      rethrow;
    }
  }

  /// PUT request to update existing resources
  ///
  /// Example usage:
  /// ```dart
  /// final response = await apiService.put('/authors/1', {
  ///   'email': 'newemail@example.com',
  ///   'biography': 'Updated bio',
  /// });
  /// // Calls: PUT http://BASE_URL/authors/1
  /// // Body: {email, biography, updatedBy}
  /// // Returns: {message: 'Author updated successfully'}
  /// // API Handler: zoo_api/routes/authors/[id].dart (PUT method)
  /// // Validation: zoo_api/lib/services/author_service.dart → validateUpdateAuthor()
  /// ```
  ///
  /// Note: API supports partial updates (only send fields you want to update)
  ///
  /// Throws:
  /// - ApiException(400): Validation error or no fields provided
  /// - ApiException(404): Resource not found
  /// - ApiException(500): Server error
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');

    if (Environment.enableLogging) {
      print('📤 PUT Request: $url');
      print('   Body: ${jsonEncode(data)}');
    }

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeout);

      if (Environment.enableLogging) {
        print('📥 PUT Response: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      return _handleResponse(response);
    } on SocketException {
      _logError('Connection refused. Is the API running at $baseUrl?');
      throw ApiException(
        'Cannot connect to API. Make sure the Dart Frog server is running.',
        0,
      );
    } on HttpException {
      _logError('HTTP error occurred');
      throw ApiException('HTTP error occurred', 0);
    } catch (e) {
      _logError('Unexpected error: $e');
      rethrow;
    }
  }

  /// DELETE request to remove resources (soft delete)
  ///
  /// Example usage:
  /// ```dart
  /// await apiService.delete('/accounts/1');
  /// Calls: DELETE http://BASE_URL/accounts/1
  /// Returns: {message: 'Account deleted successfully'}
  /// API Handler: duck_api/routes/accounts/[id].dart (DELETE method)
  /// Validation: duck_api/lib/services/account_service.dart → validateDeleteAuthor()
  /// ```
  ///
  /// Note: API uses soft delete (sets is_active = false)
  /// - Data is not permanently removed from database
  /// - Deleted resources won't appear in GET requests
  ///
  /// Throws:
  /// - ApiException(400): Cannot delete (e.g., account has ducks) or already deleted
  /// - ApiException(404): Resource not found
  /// - ApiException(500): Server error
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    if (Environment.enableLogging) {
      print('📤 DELETE Request: $url');
    }

    try {
      final response = await http.delete(url).timeout(timeout);

      if (Environment.enableLogging) {
        print('📥 DELETE Response: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      return _handleResponse(response);
    } on SocketException {
      _logError('Connection refused. Is the API running at $baseUrl?');
      throw ApiException(
        'Cannot connect to API. Make sure the Dart Frog server is running.',
        0,
      );
    } on HttpException {
      _logError('HTTP error occurred');
      throw ApiException('HTTP error occurred', 0);
    } catch (e) {
      _logError('Unexpected error: $e');
      rethrow;
    }
  }

  /// Handle HTTP response and parse errors
  ///
  /// API Response Format (success):
  /// - GET: Returns data directly (array or object)
  /// - POST: Returns {message: '...', id: 1}
  /// - PUT: Returns {message: '...'}
  /// - DELETE: Returns {message: '...'}
  ///
  /// API Error Format (from zoo_api/routes/):
  /// - 400: {error: 'Validation error message'}
  /// - 404: {error: 'Not found'}
  /// - 500: {error: 'Server error: ...'}
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success (200-299)
      return jsonDecode(response.body);
    } else {
      // Error (400+)
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Unknown error occurred';

      _logError('API Error ${response.statusCode}: $errorMessage');

      throw ApiException(errorMessage, response.statusCode);
    }
  }

  /// Log error messages when logging is enabled
  void _logError(String message) {
    if (Environment.enableLogging) {
      print('❌ $message');
    }
  }
}

/// Custom exception for API errors
///
/// Contains user-friendly error message from the API and HTTP status code
///
/// Examples:
/// - ApiException('Email already exists', 400) → Validation error
/// - ApiException('Author not found', 404) → Not found
/// - ApiException('Internal server error', 500) → Server error
/// - ApiException('Cannot connect to API...', 0) → Connection error
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;

  /// Check if this is a validation error (HTTP 400)
  bool get isValidationError => statusCode == 400;

  /// Check if this is a not found error (HTTP 404)
  bool get isNotFoundError => statusCode == 404;

  /// Check if this is a server error (HTTP 500)
  bool get isServerError => statusCode == 500;

  /// Check if this is a connection error (no status code)
  bool get isConnectionError => statusCode == 0 || statusCode == null;
}
