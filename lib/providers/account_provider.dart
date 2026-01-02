import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../repositories/account_repository.dart';
import '../services/api_service.dart';

/// Author Provider - State management for authors
///
/// Uses Provider package (ChangeNotifier pattern) to manage author state
/// and notify UI widgets when data changes.
///
/// Flow: UI → Provider (this file) → Repository → API Service → Dart Frog API
///
/// State managed:
/// - List of authors (from GET /authors)
/// - Loading status (while fetching data)
/// - Error messages (from API or network errors)
class AccountProvider with ChangeNotifier {
  final AccountRepository _repository = AccountRepository();

  /// List of authors fetched from the API
  List<Account> _accounts = [];

  /// Loading state - true while fetching data from API
  bool _isLoading = false;

  /// Error message - populated when API call fails
  String? _errorMessage;

  /// Getters for accessing state from UI
  List<Account> get authors => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Fetch all authors from the API
  ///
  /// Calls: GET http://BASE_URL/authors
  /// API: zoo_api/routes/authors/index.dart → AuthorService.getAllAuthors()
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

  /// Create a new author
  ///
  /// Calls: POST http://BASE_URL/authors
  /// API: zoo_api/routes/authors/index.dart → AuthorService.validateCreateAuthor() + createAuthor()
  ///
  /// After successful creation, refreshes the author list
  ///
  /// Returns: true if successful, false if error
  Future<bool> createAuthor(Account account) async {
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

  /// Update an existing author
  ///
  /// Calls: PUT http://BASE_URL/authors/:id
  /// API: zoo_api/routes/authors/[id].dart → AuthorService.validateUpdateAuthor() + updateAuthor()
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

  /// Delete an author (soft delete)
  ///
  /// Calls: DELETE http://BASE_URL/authors/:id
  /// API: zoo_api/routes/authors/[id].dart → AuthorService.validateDeleteAuthor() + deleteAuthor()
  ///
  /// Note: API prevents deleting authors with active books
  ///
  /// After successful deletion, refreshes the author list
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
