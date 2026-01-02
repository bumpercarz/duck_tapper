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

/// Type class for updating an account
/// All fields optional (partial updates)

/// users are unable to update accounts
class UpdateAccountData {
  final String? username;
  final String? password;

  UpdateAccountData({
    this.username,
    this.password
  });

  /// Factory constructor - Type casting only
  factory UpdateAccountData.fromJson(Map<String, dynamic> json) {
    return UpdateAccountData(
      username: json['username']?.toString(),
      password: json['password']?.toString()
    );
  }

  /// Helper: Check if any field is provided
  bool get hasUpdates =>
      username != null ||
      password != null;
}


// ============================================================
// RESPONSE TYPES (Outgoing Data)
// ============================================================

/// Type class for account responses
class AccountsResponse {
  final int account_id;
  final String username;
  final String password;

  AccountsResponse({
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