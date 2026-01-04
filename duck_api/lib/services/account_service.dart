import 'package:drift/drift.dart';
import '../database.dart';
import '../types/account_types.dart';
import '../exceptions/validation_exception.dart';

class AccountService {
  final AppDatabase _db;

  AccountService(this._db);

  // ============================================================
  // CREATE OPERATIONS
  // ============================================================

  /// Validate account creation data
  /// Throws ValidationException if invalid
  Future<void> validateCreateAccount(CreateAccountData data) async {
    // Username validation
    if (data.username.trim().isEmpty) {
      throw ValidationException('Username is required');
    }

    // Check username uniqueness
    final existing = await (_db.select(_db.accounts)
          ..where((t) => t.username.equals(data.username)))
        .getSingleOrNull();

    if (existing != null) {
      throw ValidationException('Username already exists.');
    }

    // Password validation
    if (data.password.trim().isEmpty) {
      throw ValidationException('Please input a password.');
    }
  }

  /// Create a new account (assumes data is already validated)
  /// Returns the new account ID
  Future<int> createAccount(CreateAccountData data) async {
    final id = await _db.into(_db.accounts).insert(
          AccountsCompanion.insert(
            username: data.username.trim(),
            password: data.password.trim(),
          ),
        );

    return id;
  }

  
  // ============================================================
  // READ OPERATIONS
  // ============================================================

  /// Get all active accounts with ducks
  Future<List<AccountsResponse>> getAllAccounts() async {
    // Query: SELECT accounts.*
    //        FROM accounts
    //        LEFT JOIN ducks ON accounts.id = ducks.account_id
    //        WHERE accounts.is_active = true

    final query = _db.select(_db.accounts).join([
      leftOuterJoin(_db.ducks, _db.ducks.account_id.equalsExp(_db.accounts.account_id)),
    ]);

    final rows = await query.get();

    final Map<int, AccountsResponse> accountsMap = {};

    for (final row in rows) {
      final account = row.readTable(_db.accounts);
      // final duck = row.readTableOrNull(_db.ducks);

      if (!accountsMap.containsKey(account.account_id)) {
        accountsMap[account.account_id] = AccountsResponse(
          account_id: account.account_id,
          username: account.username,
          password: account.password
        );
      }
    }

    return accountsMap.values.toList();
  }

  /// Get single account by ID
  Future<AccountsResponse?> getAccountById(int id) async {
    final authors = await getAllAccounts();
    return authors.where((a) => a.account_id == id).firstOrNull;
  }


  // ============================================================
  // UPDATE OPERATIONS
  // ============================================================

  /// Validate account update data
  Future<void> validateUpdateAccount(int id, UpdateAccountData data) async {
    // Check account exists
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.account_id.equals(id)))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException('Account ID $id does not exist or is inactive');
    }

    // Check if any updates provided
    if (!data.hasUpdates) {
      throw ValidationException('No update fields provided');
    }

    // Validate provided fields
    if (data.username != null) {
      if (data.username!.trim().isEmpty) {
        throw ValidationException('Username cannot be empty');
      }

      // Check username uniqueness (excluding current account)
      final existing = await (_db.select(_db.accounts)
            ..where((t) =>
                t.username.equals(data.username!) &
                t.account_id.equals(id).not()))
          .getSingleOrNull();

      if (existing != null) {
        throw ValidationException('Username already exists');
      }
    }

    if (data.password != null) {
      if (data.password!.trim().isEmpty) {
        throw ValidationException('Password cannot be empty');
      }
    }
  }

  /// Update an account (assumes data is already validated)
  Future<void> updateAccount(int id, UpdateAccountData data) async {
    await (_db.update(_db.accounts)..where((t) => t.account_id.equals(id))).write(
      AccountsCompanion(
        username: data.username != null ? Value(data.username!.trim()) : const Value.absent(),
        password: data.password != null ? Value(data.password!.trim()) : const Value.absent(),
      ),
    );
  }


  // ============================================================
  // DELETE OPERATIONS (Soft Delete)
  // ============================================================

  /// Validate account deletion
  Future<void> validateDeleteAccount(int id) async {
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.account_id.equals(id)))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException('Account ID $id does not exist or is already deleted');
    }
  }

  /// Soft delete
  Future<Map<String, dynamic>> deleteAccount(int id, {String deletedBy = 'system'}) async {
    // Check account for ducks
    final duckCheck = await (_db.select(_db.ducks)
          ..where((t) => t.account_id.equals(id)))
        .get();
    
    // CASCADE DELETE: delete ducks under account
    if (duckCheck.isNotEmpty) {
      await (_db.delete(_db.ducks)..where((t) => t.account_id.equals(id))).go();
    }
    
    // Delete an account 
    await (_db.delete(_db.accounts)..where((t) => t.account_id.equals(id))).go();

    return {
      'message': 'Account deleted successfully.'
    };
  }
}