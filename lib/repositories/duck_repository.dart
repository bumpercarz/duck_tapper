import '../services/api_service.dart';
import '../models/duck.dart';

/// Book Repository
///
/// Repository pattern abstracts API calls from the UI layer.
/// Each method maps to a specific API endpoint from the Dart Frog backend.
///
/// This creates a clean separation:
/// UI → Provider (State) → Repository (this file) → ApiService → Dart Frog API
///
/// Backend files:
/// - Routes: zoo_api/routes/books/index.dart, zoo_api/routes/books/[id].dart
/// - Service: zoo_api/lib/services/book_service.dart
/// - Types: zoo_api/lib/types/book_types.dart
class DuckRepository {
  final ApiService _apiService = ApiService();

  /// Get all books from the API
  ///
  /// Endpoint: GET http://BASE_URL/books
  /// API Handler: zoo_api/routes/books/index.dart (GET method)
  /// Service Method: zoo_api/lib/services/book_service.dart → getAllBooks()
  ///
  /// Returns: List of books with author names resolved via JOIN
  ///
  /// Example response:
  /// ```json
  /// [
  ///   {
  ///     "id": 1,
  ///     "title": "Harry Potter and the Philosopher's Stone",
  ///     "isbn": "9780747532699",
  ///     "publishedYear": 1997,
  ///     "pages": 223,
  ///     "authorId": 1,
  ///     "authorName": "J.K. Rowling",  ← Resolved from JOIN with authors table
  ///     "createdAt": "2025-01-15T10:30:00.000Z",
  ///     "updatedAt": "2025-01-15T10:30:00.000Z",
  ///     "createdBy": "admin",
  ///     "updatedBy": "admin"
  ///   }
  /// ]
  /// ```
  ///
  /// The authorName is resolved using a LEFT JOIN query:
  /// ```sql
  /// SELECT books.*, authors.name as author_name
  /// FROM books
  /// LEFT JOIN authors ON books.author_id = authors.id
  /// WHERE books.is_active = true AND authors.is_active = true
  /// ```
  ///
  /// Throws:
  /// - ApiException: If API returns an error or is unreachable
  Future<List<Duck>> getDucks() async {
    final response = await _apiService.get('/ducks');
    return (response as List)
        .map((json) => Duck.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get a single book by ID
  ///
  /// Endpoint: GET http://BASE_URL/books/:id
  /// API Handler: zoo_api/routes/books/[id].dart (GET method)
  /// Service Method: zoo_api/lib/services/book_service.dart → getBookById()
  ///
  /// Throws:
  /// - ApiException(404): Book not found or inactive
  Future<Duck> getDuckById(int id) async {
    final response = await _apiService.get('/ducks/$id');
    return Duck.fromJson(response as Map<String, dynamic>);
  }

  /// Create a new book
  ///
  /// Endpoint: POST http://BASE_URL/books
  /// API Handler: zoo_api/routes/books/index.dart (POST method)
  /// Validation: zoo_api/lib/services/book_service.dart → validateCreateBook()
  /// Service Method: zoo_api/lib/services/book_service.dart → createBook()
  ///
  /// Request body:
  /// ```json
  /// {
  ///   "title": "Harry Potter and the Philosopher's Stone",
  ///   "isbn": "9780747532699",
  ///   "publishedYear": 1997,
  ///   "pages": 223,
  ///   "authorId": 1,
  ///   "createdBy": "mobile_app"
  /// }
  /// ```
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Book created successfully",
  ///   "id": 1
  /// }
  /// ```
  ///
  /// API Validations performed:
  /// 1. Title: Required, minimum 2 characters
  /// 2. ISBN: Required, valid format (ISBN-10 or ISBN-13), must be unique
  ///    - ISBN-10: 10 digits (e.g., 0451524934)
  ///    - ISBN-13: 13 digits (e.g., 9780451524935)
  ///    - Hyphens and spaces are automatically removed
  /// 3. Published Year: Between 1450 (printing press invention) and current year
  /// 4. Pages: Must be a positive number (> 0)
  /// 5. Author ID: Must reference an existing, active author
  ///
  /// Returns: The ID of the newly created book
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Book title is required"
  ///   * "Invalid ISBN format. Must be ISBN-10 (10 digits) or ISBN-13 (13 digits)"
  ///   * "ISBN already exists"
  ///   * "Published year must be between 1450 and 2025"
  ///   * "Number of pages must be a positive number"
  ///   * "Author ID X does not exist or is inactive"
  Future<int> createDuck(Duck duck) async {
    final response = await _apiService.post('/ducks', duck.toJson());
    return response['duck_id'] as int;
  }

  /// Update an existing book
  ///
  /// Endpoint: PUT http://BASE_URL/books/:id
  /// API Handler: zoo_api/routes/books/[id].dart (PUT method)
  /// Validation: zoo_api/lib/services/book_service.dart → validateUpdateBook()
  /// Service Method: zoo_api/lib/services/book_service.dart → updateBook()
  ///
  /// Request body (partial updates supported):
  /// ```json
  /// {
  ///   "title": "Updated Title",
  ///   "pages": 300,
  ///   "updatedBy": "mobile_app"
  /// }
  /// ```
  ///
  /// Note: Only send fields you want to update. Omitted fields remain unchanged.
  /// You can even change the author by updating authorId.
  ///
  /// API Validations performed:
  /// 1. Book exists and is active
  /// 2. At least one field is being updated
  /// 3. If ISBN is updated: valid format and unique (excluding current book)
  /// 4. If publishedYear is updated: valid range (1450 to current year)
  /// 5. If pages is updated: must be positive
  /// 6. If authorId is updated: author must exist and be active
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Book updated successfully"
  /// }
  /// ```
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Book ID does not exist or is inactive"
  ///   * "No update fields provided"
  ///   * "Invalid ISBN format"
  ///   * "ISBN already exists"
  ///   * "Invalid published year"
  ///   * "Pages must be positive"
  ///   * "Author ID X does not exist or is inactive"
  /// - ApiException(404): Book not found
  Future<void> updateDuck(int id, Duck duck) async {
    await _apiService.put('/ducks/$id', duck.toJson());
  }

  /// Delete a book (soft delete)
  ///
  /// Endpoint: DELETE http://BASE_URL/books/:id
  /// API Handler: zoo_api/routes/books/[id].dart (DELETE method)
  /// Validation: zoo_api/lib/services/book_service.dart → validateDeleteBook()
  /// Service Method: zoo_api/lib/services/book_service.dart → deleteBook()
  ///
  /// Response:
  /// ```json
  /// {
  ///   "message": "Book deleted successfully"
  /// }
  /// ```
  ///
  /// Note: This is a SOFT DELETE - the book is not removed from the database.
  /// Instead, the API sets is_active = false. Benefits:
  /// - Data recovery is possible
  /// - Audit trail is preserved
  /// - The author's book count will be updated (JOIN excludes inactive books)
  ///
  /// API Validations performed:
  /// 1. Book exists and is active
  ///
  /// Throws:
  /// - ApiException(400): Validation error
  ///   * "Book ID does not exist or is already deleted"
  /// - ApiException(404): Book not found
  Future<void> deleteDuck(int id) async {
    await _apiService.delete('/ducks/$id');
  }

  /// Get all books by a specific author
  ///
  /// Note: The API doesn't have a dedicated endpoint for this,
  /// so we fetch all books and filter by authorId on the client side.
  ///
  /// In a production app, you might want to add a backend endpoint:
  /// GET /authors/:id/books for better performance.
  Future<List<Duck>> getDucksByAccount(int accountId) async {
    final allDucks = await getDucks();
    return allDucks.where((duck) => duck.account_id == accountId).toList();
  }
}
