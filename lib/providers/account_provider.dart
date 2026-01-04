import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../repositories/account_repository.dart';
import '../services/api_service.dart';

/// Account Provider - State management for accounts
///
/// Uses Provider package (ChangeNotifier pattern) to manage account state
/// and notify UI widgets when data changes.
///
/// Flow: UI → Provider (this file) → Repository → API Service → Dart Frog API
///
/// State managed:
/// - List of accounts (from GET /accounts)
/// - Loading status (while fetching data)
/// - Error messages (from API or network errors)
class AccountProvider with ChangeNotifier {
  final AccountRepository _repository = AccountRepository();

  /// List of accounts fetched from the API
  List<Account> _accounts = [];

  /// Loading state - true while fetching data from API
  bool _isLoading = false;

  /// Logged in account in Device
  int _loggedAccount = 0;

  /// Error message - populated when API call fails
  String? _errorMessage;

  /// Getters for accessing state from UI
  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;
  int? get loggedAccount => _loggedAccount;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Fetch all accounts from the API
  ///
  /// Calls: GET http://BASE_URL/accounts
  /// API: duck_api/routes/accounts/index.dart → AccountService.getAllAccounts()
  ///
  /// Updates UI automatically via notifyListeners()
  Future<void> fetchAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _accounts = await _repository.getAccounts();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _accounts = [];
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _accounts= [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<Account> getLatestAccount() async {
      _accounts = await _repository.getAccounts();
    return _accounts[_accounts.length-1];
  }

  Future<void> setLoggedAccount(int loggedAccount) async{
    _loggedAccount = loggedAccount;
    debugPrint('Logged $_loggedAccount');
    notifyListeners();
  }

  /// Create a new account
  ///
  /// Calls: POST http://BASE_URL/accounts
  /// API: duck_api/routes/accounts/index.dart → AccountService.validateCreateAccount() + createAccount()
  ///
  /// After successful creation, refreshes the account list
  ///
  /// Returns: true if successful, false if error
  Future<bool> createAccount(Account account) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createAccount(account);
      await fetchAccounts(); // Refresh list
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update an existing account
  ///
  /// Calls: PUT http://BASE_URL/accounts/:id
  /// API: duck_api/routes/accounts/[id].dart → AccountService.validateUpdateAccount() + updateAccount()
  ///
  /// After successful update, refreshes the author list
  ///
  /// Returns: true if successful, false if error
  Future<bool> updateAccount(int id, Account account) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateAccount(id, account);
      await fetchAccounts(); // Refresh list
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete an account 
  ///
  /// Calls: DELETE http://BASE_URL/accounts/:id
  /// API: duck_api/routes/accounts/[id].dart → AccountService.validateDeleteAccount() + deleteAccount()
  ///
  /// Note: API prevents deleting accounts with active books
  ///
  /// After successful deletion, refreshes the account list
  ///
  /// Returns: true if successful, false if error
  Future<bool> deleteAccount(int id) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteAccount(id);
      await fetchAccounts(); // Refresh list
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
