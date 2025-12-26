// ============================================================
// REQUEST TYPES (Incoming Data)
// ============================================================

/// Type class for creating a new account
/// NO VALIDATION - Only type casting
class CreateAccountData {
  final String username;
  final String password;

  CreateAccountData({
    required this.username,
    required this.password
  });

  /// Factory constructor - Simple type casting only
  /// Validation happens in AccountService.validateCreateAccount()
  factory CreateAccountData.fromJson(Map<String, dynamic> json) {
    return CreateAccountData(
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }
}

/// You cannot change your username & password after account creation ;p



// ============================================================
// RESPONSE TYPES (Outgoing Data)
// ============================================================

/// Type class for account responses
class AccountResponse {
  final int account_id;
  final String username;
  final String password;

  AccountResponse({
    required this.account_id,
    required this.username,
    required this.password
  });

  /// Convert to JSON for HTTP response
  Map<String, dynamic> toJson() => {
        'account_id': account_id,
        'username': username,
        'password': password
      };
}