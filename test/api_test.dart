import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  // Define your server URL
  final baseUrl = Uri.parse('http://localhost:8080');

  group('API Integration Tests', () {
    // TEST 1: Check Server Status
    test('GET /accounts returns 200 OK', () async {
      final response = await http.get(baseUrl.replace(path: '/accounts'));
      expect(response.statusCode, 200);
    });

    // TEST 2: Check Response Body
    test('GET /ducks returns a valid list', () async {
      final response = await http.get(baseUrl.replace(path: '/ducks'));
      expect(response.body, isNotEmpty); // Ensures server sent something back
    });

    // TEST 3: Check Error Handling
    test('GET /unknown_route returns 404', () async {
      final response = await http.get(baseUrl.replace(path: '/this_does_not_exist'));
      expect(response.statusCode, 404);
    });
  });
}