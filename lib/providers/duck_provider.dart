import 'package:flutter/foundation.dart';
import '../models/duck.dart';
import '../repositories/duck_repository.dart';
import '../services/api_service.dart';

class DuckProvider with ChangeNotifier {
  final DuckRepository _repository = DuckRepository();

  /// List of ducks fetched from the API
  List<Duck> _ducks = [];

  /// Loading state - true while fetching data from API
  bool _isLoading = false;

  /// Error message - populated when API call fails
  String? _errorMessage;

  /// Getters for accessing state from UI
  List<Duck> get ducks => _ducks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Fetch all ducks from the API
  ///
  /// Calls: GET http://BASE_URL/ducks
  /// API: duck_api/routes/ducks/index.dart → DuckService.getAllDucks()
  ///
  /// Returns ducks with account names resolved via JOIN
  ///
  /// Updates UI automatically via notifyListeners()
  Future<void> fetchDucks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ducks = await _repository.getDucks();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _ducks = [];
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _ducks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new duck
  ///
  /// Calls: POST http://BASE_URL/ducks
  /// API: duck_api/routes/ducks/index.dart → DuckService.validateCreateDuck() + createDuck()
  ///
  /// API Validations:
  /// - Account ID (must exist)
  ///
  /// After successful creation, refreshes the duck list
  ///
  /// Returns: true if successful, false if error
  Future<bool> createDuck(Duck duck) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createDuck(duck);
      await fetchDucks(); // Refresh list
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

  /// Update an existing duck
  ///
  /// Calls: PUT http://BASE_URL/ducks/:id
  /// API: duck_api/routes/ducks/[id].dart → DuckService.validateUpdateDuck() + updateDuck()
  ///
  /// Supports partial updates - only send fields you want to change
  /// Can also change the account by updating accountId
  ///
  /// After successful update, refreshes the duck list
  ///
  /// Returns: true if successful, false if error
  Future<bool> updateDuck(int id, Duck duck) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateDuck(id, duck);
      await fetchDucks(); // Refresh list
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

  /// Delete a duck
  ///
  /// Calls: DELETE http://BASE_URL/ducks/:id
  /// API: duck_api/routes/ducks/[id].dart → DuckService.validateDeleteDuck() + deleteDuck()
  ///
  ///
  /// After successful deletion, refreshes the duck list
  ///
  /// Returns: true if successful, false if error
  Future<bool> deleteDuck(int id) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteDuck(id);
      await fetchDucks(); // Refresh list
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

  /// Get duck in a specific account
  ///
  /// Filters the current duck list by accountId
  /// Note: If you need fresh data, call fetchDucks() first
  Future<Duck> getDucksByAccount(int accountId) async {
      _ducks = await _repository.getDucks();
    List<Duck> foundDuck = _ducks.where((duck) => duck.account_id == accountId).toList();
    return foundDuck[0];
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}










