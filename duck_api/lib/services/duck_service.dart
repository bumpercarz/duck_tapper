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

  Future<void> validateCreateDuck(CreateDuckData data) async {
    // Foreign key validation - Author must exist and be active
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.account_id.equals(data.account_id) & t.isActive.equals(true)
          ))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException(
        'Account ID ${data.account_id} does not exist or is inactive',
      );
    }
  }

  /// Create a new duck
  Future<int> createDuck(CreateDuckData data) async {
    final id = await _db.into(_db.ducks).insert(
          DucksCompanion.insert(
            account_id: data.account_id,
            totalQuack: data.totalQuack,
            currentQuack: data.currentQuack,
            duckTaps: data.duckTaps,
            moreDucks: data.moreDucks,
            fish: data.fish,
            watermelon: data.watermelon,
            ponds: data.ponds,
            // isActive: true
          ),
        );

    return id;
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  /// Get all active ducks with accounts names (JOIN)
  Future<List<DuckResponse>> getAllDucks() async {
    // Query: SELECT books.*, authors.name as author_name
    //        FROM books
    //        LEFT JOIN authors ON books.author_id = authors.id
    //        WHERE books.is_active = true AND authors.is_active = true

    final query = _db.select(_db.ducks).join([
      leftOuterJoin(_db.accounts, _db.accounts.account_id.equalsExp(_db.ducks.account_id)),
    ])
      ..where(_db.ducks.isActive.equals(true) & _db.accounts.isActive.equals(true));

    final rows = await query.get();

    return rows.map((row) {
      final duck = row.readTable(_db.ducks);
      final account = row.readTableOrNull(_db.accounts);

      return DuckResponse(
        duck_id: duck.duck_id,
        account_id: duck.account_id,
        totalQuack: duck.totalQuack,
        currentQuack: duck.currentQuack,
        duckTaps: duck.duckTaps,
        moreDucks: duck.moreDucks,
        fish: duck.fish,
        watermelon: duck.watermelon,
        ponds: duck.ponds
      );
    }).toList();
  }

  /// Get single duck by ID
  Future<DuckResponse?> getDuckById(int id) async {
    final query = _db.select(_db.ducks).join([
      leftOuterJoin(_db.accounts, _db.accounts.account_id.equalsExp(_db.ducks.account_id)),
    ])
      ..where(_db.ducks.account_id.equals(id) & _db.ducks.isActive.equals(true));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final duck = row.readTable(_db.ducks);
    final account = row.readTableOrNull(_db.accounts);

    return DuckResponse(
      duck_id: duck.duck_id,
      account_id: duck.account_id,
      totalQuack: duck.totalQuack,
      currentQuack: duck.currentQuack,
      duckTaps: duck.duckTaps,
      moreDucks: duck.moreDucks,
      fish: duck.fish,
      watermelon: duck.watermelon,
      ponds: duck.ponds
    );
  }

  /// Get ducks by account ID
  Future<List<DuckResponse>> getDucksByAccount(int account_id) async {
    final allDucks = await getAllDucks();
    return allDucks.where((b) => b.account_id == account_id).toList();
  }

  // ============================================================
  // UPDATE OPERATIONS
  // ============================================================

  /// Validate book update data
  Future<void> validateUpdateDuck(int id, UpdateDuckData data) async {
    // Check book exists
    final duck = await (_db.select(_db.ducks)
          ..where((t) => t.duck_id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (duck == null) {
      throw ValidationException('Duck ID $id does not exist or is inactive');
    }

    // Check if any updates provided
    if (!data.hasUpdates) {
      throw ValidationException('No updates identifed');
    }


  /// Update duck
  Future<void> updateDuck(int id, UpdateDuckData data) async {
    final now = DateTime.now();

    await (_db.update(_db.ducks)..where((t) => t.duck_id.equals(id))).write(
      DucksCompanion(

        // left off here !!

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