/// Custom exception for validation errors
/// Used by service layer to return user-friendly error messages
class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => message;
}