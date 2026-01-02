import 'package:flutter/foundation.dart';
import '../models/duck.dart';
import '../repositories/duck_repository.dart';
import '../services/api_service.dart';

class DuckProvider with ChangeNotifier {
  final DuckRepository _repository = DuckRepository();

  /// List of books fetched from the API
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

  /// Fetch all books from the API
  ///
  /// Calls: GET http://BASE_URL/books
  /// API: zoo_api/routes/books/index.dart → BookService.getAllBooks()
  ///
  /// Returns books with author names resolved via JOIN
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

  /// Create a new book
  ///
  /// Calls: POST http://BASE_URL/books
  /// API: zoo_api/routes/books/index.dart → BookService.validateCreateBook() + createBook()
  ///
  /// API Validations:
  /// - ISBN format (ISBN-10 or ISBN-13)
  /// - ISBN uniqueness
  /// - Published year (1450 to current year)
  /// - Pages (must be positive)
  /// - Author ID (must exist and be active)
  ///
  /// After successful creation, refreshes the book list
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

  /// Update an existing book
  ///
  /// Calls: PUT http://BASE_URL/books/:id
  /// API: zoo_api/routes/books/[id].dart → BookService.validateUpdateBook() + updateBook()
  ///
  /// Supports partial updates - only send fields you want to change
  /// Can also change the author by updating authorId
  ///
  /// After successful update, refreshes the book list
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

  /// Delete a book (soft delete)
  ///
  /// Calls: DELETE http://BASE_URL/books/:id
  /// API: zoo_api/routes/books/[id].dart → BookService.validateDeleteBook() + deleteBook()
  ///
  /// Note: This is a soft delete (sets is_active = false in database)
  /// After deletion, the author's book count will be updated automatically
  ///
  /// After successful deletion, refreshes the book list
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

  /// Get books by a specific author
  ///
  /// Filters the current books list by authorId
  /// Note: If you need fresh data, call fetchBooks() first
  Duck getDucksByAccount(int accountId) {
    List<Duck> foundDuck = _ducks.where((duck) => duck.account_id == accountId).toList();
    return foundDuck[0];
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}










