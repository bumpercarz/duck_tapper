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

  Future<void> validateCreateDuck(CreateDuck data) async {
    // Foreign key validation - Account must exist and be active
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.account_id.equals(data.account_id)
          ))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException(
        'Account ID ${data.account_id} does not exist or is inactive',
      );
    }

    if(data.totalQuack < 0 || data.currentQuack < 0 || data.duckTaps < 0
    || data.moreDucks < 0 || data.fish < 0 || data.watermelon < 0 
    || data.ponds < 0){
      throw ValidationException(
        'Duck values must not be below 0',
      );
    }
  }

  /// Create a new duck
  Future<int> createDuck(CreateDuck data) async {
    final id = await _db.into(_db.ducks).insert(
          DucksCompanion.insert(
            account_id: data.account_id,
            totalQuack: data.totalQuack,
            currentQuack: data.currentQuack,
            duckTaps: data.duckTaps,
            moreDucks: data.moreDucks,
            fish: data.fish,
            watermelon: data.watermelon,
            ponds: data.ponds
          ),
        );

    return id;
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  /// Get all active ducks (JOIN)
  Future<List<DuckResponse>> getAllDucks() async {
    // Query: SELECT ducks.*
    //        FROM ducks
    //        LEFT JOIN accounts ON ducks.account_id = accounts.id
    //        WHERE ducks.is_active = true AND accounts.is_active = true

    final query = _db.select(_db.ducks).join([
      leftOuterJoin(_db.accounts, _db.accounts.account_id.equalsExp(_db.ducks.account_id)),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final duck = row.readTable(_db.ducks);

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
      ..where(_db.ducks.account_id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final duck = row.readTable(_db.ducks);

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
  Future<void> validateUpdateDuck(int id, UpdateDuck data) async {
    // Check book exists
    final duck = await (_db.select(_db.ducks)
          ..where((t) => t.duck_id.equals(id)))
        .getSingleOrNull();

    if (duck == null) {
      throw ValidationException('Duck ID $id does not exist or is inactive');
    }

    // Check if any updates provided
    if (!data.hasUpdates) {
      throw ValidationException('No updates identifed');
    }
  }


  /// Update duck
  Future<void> updateDuck(int id, UpdateDuck data) async {
    await (_db.update(_db.ducks)..where((t) => t.duck_id.equals(id))).write(
      DucksCompanion(
        totalQuack: data.totalQuack != 0 ? Value(data.totalQuack) : const Value(0),
        currentQuack: data.currentQuack != 0 ? Value(data.currentQuack) : const Value(0),
        duckTaps: data.duckTaps != 0 ? Value(data.duckTaps) : const Value(0),
        moreDucks: data.moreDucks != 0 ? Value(data.moreDucks) : const Value(0),
        fish: data.fish != 0 ? Value(data.fish) : const Value(0),
        watermelon: data.watermelon != 0 ? Value(data.watermelon) : const Value(0),
        ponds: data.ponds != 0 ? Value(data.ponds) : const Value(0)
      ),
    );
  }

  // ============================================================
  // DELETE OPERATIONS (Soft Delete)
  // ============================================================

  /// Validate duck deletion
  Future<void> validateEraseDuck(int id) async {
    final duck = await (_db.select(_db.ducks)
          ..where((t) => t.duck_id.equals(id)))
        .getSingleOrNull();

    if (duck == null) {
      throw ValidationException('Duck does not exist or is already deleted');
    }
  }

  /// Delete a duck
  Future<void> eraseDuck(int id, {String deletedBy = 'system'}) async {
    await (_db.delete(_db.ducks)..where((t) => t.duck_id.equals(id))).go();
  }
  
}