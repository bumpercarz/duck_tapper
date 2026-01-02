import '../services/api_service.dart';
import '../models/account.dart';

/// Author Repository
///
/// Repository pattern abstracts API calls from the UI layer.
/// Each method maps to a specific API endpoint from the Dart Frog backend.
///
/// This creates a clean separation:
/// UI → Provider (State) → Repository (this file) → ApiService → Dart Frog API
///
class AccountRepository {
  final ApiService _apiService = ApiService();

  /// Get all authors from the API
  ///
  /// Endpoint: GET http://BASE_URL/authors
  /// API Handler: zoo_api/routes/authors/index.dart (GET method)
  /// Service Method: zoo_api/lib/services/author_service.dart → getAllAuthors()
  ///
  /// Returns: List of authors with book counts
  ///
  /// Example response:
  /// ```json
  /// [
  ///   {
  ///     "id": 1,
  ///     "name": "J.K. Rowling",
  ///     "email": "jk@example.com",
  ///     "biography": "...",
  ///     "nationality": "British",
  ///     "bookCount": 2,  ← Calculated from JOIN with books table
  ///     "createdAt": "2025-01-15T10:30:00.000Z",
  ///     "updatedAt": "2025-01-15T10:30:00.000Z",
  ///     "createdBy": "admin",
  ///     "updatedBy": "admin"
  ///   }
  /// ]
  /// ```
  ///
  /// The bookCount is calculated using a LEFT JOIN query:
  /// ```sql
  /// SELECT authors.*, COUNT(books.id) as book_count
  /// FROM authors
  /// LEFT JOIN books ON authors.id = books.author_id
  /// WHERE authors.is_active = true
  /// GROUP BY authors.id
  /// ```
  ///
  /// Throws:
  /// - ApiException: If API returns an error or is unreachable
  Future<List<Account>> getAccounts() async {
    final response = await _apiService.get('/accounts');
    return (response as List)
        .map((json) => Account.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get a single author by ID
  ///
  /// Endpoint: GET http://BASE_URL/account/:id
  /// API Handler: duck_api/routes/accounts/[id].dart (GET method)
  /// Service Method: duck_api/lib/services/account_service.dart → getAccountById()
  ///
  /// Throws:
  /// - ApiException(404): Account not found or inactive
  Future<Account> getAccountById(int id) async {
    final response = await _apiService.get('/accounts/$id');
    return Account.fromJson(response as Map<String, dynamic>);
  }

  /// Create a new author
  ///
  /// Endpoint: POST http://BASE_URL/accounts
  /// API Handler: duck_api/routes/accounts/index.dart (POST method)
  /// Validation: duck_api/lib/services/account_service.dart → validateCreateAccount()
  /// Service Method: duck_api/lib/services/account_service.dart → createAccount()
  ///
  /// Request body:
  /// ```json
  /// {
  ///   "name": "J.K. Rowling",
  ///   "email": "jk@example.com",
  ///   "biography": "British author, best known for Harry Potter",
  ///   "nationality": "British",
  ///   "createdBy": "mobile_app"
  /// }
  /// ```
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Account created successfully",
  ///   "id": 1
  /// }
  /// ```
  ///
  /// API Validations performed:
  /// 1. Name: Required, minimum 2 characters
  /// 2. Email: Required, valid format (regex), must be unique
  /// 3. Biography: Required
  /// 4. Nationality: Required
  ///
  /// Returns: The ID of the newly created author
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Author name is required"
  ///   * "Invalid email format"
  ///   * "Email already exists"
  ///   * "Biography is required"
  ///   * etc.
  Future<int> createAccount(Account account) async {
    final response = await _apiService.post('/accounts', account.toJson());
    return response['account_id'] as int;
  }

  /// Update an existing author
  ///
  /// Endpoint: PUT http://BASE_URL/authors/:id
  /// API Handler: zoo_api/routes/authors/[id].dart (PUT method)
  /// Validation: zoo_api/lib/services/author_service.dart → validateUpdateAuthor()
  /// Service Method: zoo_api/lib/services/author_service.dart → updateAuthor()
  ///
  /// Request body (partial updates supported):
  /// ```json
  /// {
  ///   "email": "newemail@example.com",
  ///   "biography": "Updated biography",
  ///   "updatedBy": "mobile_app"
  /// }
  /// ```
  ///
  /// Note: Only send fields you want to update. Omitted fields remain unchanged.
  ///
  /// API Validations performed:
  /// 1. Author exists and is active
  /// 2. At least one field is being updated
  /// 3. If email is updated: valid format and unique (excluding current author)
  /// 4. If name is updated: minimum 2 characters
  /// 5. Non-empty values for updated fields
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Author updated successfully"
  /// }
  /// ```
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Author ID does not exist or is inactive"
  ///   * "No update fields provided"
  ///   * "Email already exists"
  ///   * etc.
  /// - ApiException(404): Author not found
  Future<void> updateAccount(int id, Account account) async {
    await _apiService.put('/accounts/$id', account.toJson());
  }

  /// Delete an author (soft delete)
  ///
  /// Endpoint: DELETE http://BASE_URL/authors/:id
  /// API Handler: zoo_api/routes/authors/[id].dart (DELETE method)
  /// Validation: zoo_api/lib/services/author_service.dart → validateDeleteAuthor()
  /// Service Method: zoo_api/lib/services/author_service.dart → deleteAuthor()
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Author deleted successfully"
  /// }
  /// ```
  ///
  /// Note: This is a SOFT DELETE - the author is not removed from the database.
  /// Instead, the API sets is_active = false. Benefits:
  /// - Data recovery is possible
  /// - Audit trail is preserved
  /// - Foreign key relationships remain intact
  ///
  /// API Validations performed:
  /// 1. Author exists and is active
  /// 2. Author has no active books (must delete/reassign books first)
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Author ID does not exist or is already deleted"
  ///   * "Cannot delete author with N active book(s). Delete or reassign books first."
  /// - ApiException(404): Author not found
  Future<void> deleteAccount(int id) async {
    await _apiService.delete('/accounts/$id');
  }
}
