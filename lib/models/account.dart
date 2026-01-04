/// Account Model Class
///
/// This model matches the API response structure from the Dart Frog backend.
/// API Response comes from: duck_api/lib/types/account_types.dart (AccountResponse class)
class Account {
  final int? id; // Nullable for new accounts (not yet saved to API)
  final String username;
  final String password;

  Account({
    this.id,
    required this.username,
    required this.password,
  });

  /// Parse JSON response from API into Account object
  ///
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['account_id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  /// Convert Account object to JSON for API requests
  ///
  /// Used when sending data to:
  /// - POST /accounts (create new account)
  /// - PUT /accounts/:id (update existing account)
  ///
  /// Note: Only includes fields that the API accepts for creation/update
  /// (id, timestamps, and counts are managed by the API)
  ///
  /// API Validation: duck_api/lib/services/account_service.dart
  /// - validateCreateAuthor(): Checks email format, uniqueness, required fields
  /// - validateUpdateAuthor(): Checks email format, uniqueness (excluding current)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'Account(id: $id, username: $username, password: $password)';
  }
}
