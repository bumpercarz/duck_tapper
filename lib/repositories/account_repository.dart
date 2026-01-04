import '../services/api_service.dart';
import '../models/account.dart';

/// Account Repository
///
/// Repository pattern abstracts API calls from the UI layer.
/// Each method maps to a specific API endpoint from the Dart Frog backend.
///
/// This creates a clean separation:
/// UI → Provider (State) → Repository (this file) → ApiService → Dart Frog API
///
class AccountRepository {
  final ApiService _apiService = ApiService();

  /// Throws:
  /// - ApiException: If API returns an error or is unreachable
  Future<List<Account>> getAccounts() async {
    final response = await _apiService.get('/accounts');
    return (response as List)
        .map((json) => Account.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Throws:
  /// - ApiException(404): Account not found or inactive
  Future<Account> getAccountById(int id) async {
    final response = await _apiService.get('/accounts/$id');
    return Account.fromJson(response as Map<String, dynamic>);
  }


  Future<int> createAccount(Account account) async {
    final response = await _apiService.post('/accounts', account.toJson());
    return response['account_id'] as int;
  }

  /// Update an existing account
  ///
  Future<void> updateAccount(int id, Account account) async {
    await _apiService.put('/accounts/$id', account.toJson());
  }

  /// Delete an account 
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Account ID does not exist or is already deleted"
  /// - ApiException(404): Author not found
  Future<void> deleteAccount(int id) async {
    await _apiService.delete('/accounts/$id');
  }
}
