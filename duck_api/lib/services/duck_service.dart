import 'package:drift/drift.dart';
import '../database.dart';
import '../types/duck_types.dart';
import '../exceptions/validation_exception.dart';

class DuckService {
  final AppDatabase _db;

  DuckService(this._db);

  // ============================================================
  // CREATE OPERATIONS
  // ============================================================

  /// Validate book creation data
  Future<void> validateNewDuck(NewDuckData data) async {
    // Foreign key validation - Account must exist and be active
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.id.equals(data.account_id) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException(
        'Account ${data.account_id} does not exist or is inactive',
      );
    }
  }

  /// Create a new duck
  Future<int> createDuck(NewDuckData data) async {

    final id = await _db.into(_db.ducks).insert(
          DucksCompanion.insert(
            duck_id: data.duck_id,
            account_id: data.account_id,
            totalQuack: data.totalQuack,
            currentQuack: data.currentQuack,
            duckTaps: data.duckTaps,
            moreDucks: data.moreDucks,
            fish: data.fish,
            watermelon: data.watermelon,
            ponds: data.ponds,
            isActive: true
          ),
        );

    return id;
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  /// Get all active books with author names (JOIN)
  Future<List<BookResponse>> getDuck() async {
    // Query: SELECT books.*, authors.name as author_name
    //        FROM books
    //        LEFT JOIN authors ON books.author_id = authors.id
    //        WHERE books.is_active = true AND authors.is_active = true

    final query = _db.select(_db.ducks)
      ..where(_db.ducks.accountid == _db.accounts.accountid);

    final rows = await query.get();

    return rows.map((row) {
      final book = row.readTable(_db.books);
      final author = row.readTableOrNull(_db.authors);

      return BookResponse(
        id: book.id,
        title: book.title,
        isbn: book.isbn,
        publishedYear: book.publishedYear,
        pages: book.pages,
        authorId: book.authorId,
        authorName: author?.name ?? 'Unknown Author',
        createdAt: book.createdAt,
        updatedAt: book.updatedAt,
        createdBy: book.createdBy,
        updatedBy: book.updatedBy,
      );
    }).toList();
  }

  /// Get single book by ID
  Future<BookResponse?> getBookById(int id) async {
    final query = _db.select(_db.books).join([
      leftOuterJoin(_db.authors, _db.authors.id.equalsExp(_db.books.authorId)),
    ])
      ..where(_db.books.id.equals(id) & _db.books.isActive.equals(true));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final book = row.readTable(_db.books);
    final author = row.readTableOrNull(_db.authors);

    return BookResponse(
      id: book.id,
      title: book.title,
      isbn: book.isbn,
      publishedYear: book.publishedYear,
      pages: book.pages,
      authorId: book.authorId,
      authorName: author?.name ?? 'Unknown Author',
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      createdBy: book.createdBy,
      updatedBy: book.updatedBy,
    );
  }

  /// Get books by author ID
  Future<List<BookResponse>> getBooksByAuthor(int authorId) async {
    final allBooks = await getAllBooks();
    return allBooks.where((b) => b.authorId == authorId).toList();
  }

  // ============================================================
  // UPDATE OPERATIONS
  // ============================================================

  /// Validate book update data
  Future<void> validateUpdateBook(int id, UpdateBookData data) async {
    // Check book exists
    final book = await (_db.select(_db.books)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (book == null) {
      throw ValidationException('Book ID $id does not exist or is inactive');
    }

    // Check if any updates provided
    if (!data.hasUpdates) {
      throw ValidationException('No update fields provided');
    }

    // Validate provided fields
    if (data.title != null) {
      if (data.title!.trim().isEmpty) {
        throw ValidationException('Title cannot be empty');
      }
      if (data.title!.length < 2) {
        throw ValidationException('Title must be at least 2 characters');
      }
    }

    if (data.isbn != null) {
      if (data.isbn!.trim().isEmpty) {
        throw ValidationException('ISBN cannot be empty');
      }
      if (!_isValidISBN(data.isbn!)) {
        throw ValidationException('Invalid ISBN format');
      }

      // Check uniqueness (excluding current book)
      final existing = await (_db.select(_db.books)
            ..where((t) =>
                t.isbn.equals(data.isbn!) &
               t.id.equals(id).not() &
                t.isActive.equals(true)))
          .getSingleOrNull();

      if (existing != null) {
        throw ValidationException('ISBN already exists');
      }
    }

    if (data.publishedYear != null) {
      final currentYear = DateTime.now().year;
      if (data.publishedYear! < 1450 || data.publishedYear! > currentYear) {
        throw ValidationException('Invalid published year');
      }
    }

    if (data.pages != null && data.pages! <= 0) {
      throw ValidationException('Pages must be positive');
    }

    if (data.authorId != null) {
      final author = await (_db.select(_db.authors)
            ..where((t) => t.id.equals(data.authorId!) & t.isActive.equals(true)))
          .getSingleOrNull();

      if (author == null) {
        throw ValidationException('Author ID ${data.authorId} does not exist or is inactive');
      }
    }
  }

  /// Update a book (assumes data is validated)
  Future<void> updateBook(int id, UpdateBookData data) async {
    final now = DateTime.now();

    await (_db.update(_db.books)..where((t) => t.id.equals(id))).write(
      BooksCompanion(
        title: data.title != null ? Value(data.title!.trim()) : const Value.absent(),
        isbn: data.isbn != null
            ? Value(data.isbn!.replaceAll(RegExp(r'[-\s]'), ''))
            : const Value.absent(),
        publishedYear: data.publishedYear != null
            ? Value(data.publishedYear!)
            : const Value.absent(),
        pages: data.pages != null ? Value(data.pages!) : const Value.absent(),
        authorId: data.authorId != null ? Value(data.authorId!) : const Value.absent(),
        updatedAt: Value(now),
        updatedBy: Value(data.updatedBy),
      ),
    );
  }

  // ============================================================
  // DELETE OPERATIONS (Soft Delete)
  // ============================================================

  /// Validate book deletion
  Future<void> validateDeleteBook(int id) async {
    final book = await (_db.select(_db.books)
          ..where((t) => t.id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (book == null) {
      throw ValidationException('Book ID $id does not exist or is already deleted');
    }
  }

  /// Soft delete a book
  Future<void> deleteBook(int id, {String deletedBy = 'system'}) async {
    final now = DateTime.now();

    await (_db.update(_db.books)..where((t) => t.id.equals(id))).write(
      BooksCompanion(
        isActive: const Value(false),
        updatedAt: Value(now),
        updatedBy: Value(deletedBy),
      ),
    );
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Validate ISBN-10 or ISBN-13 format
  bool _isValidISBN(String isbn) {
    final cleaned = isbn.replaceAll(RegExp(r'[-\s]'), '');
    return RegExp(r'^\d{10}$|^\d{13}$').hasMatch(cleaned);
  }
}