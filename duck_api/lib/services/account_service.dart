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
    // Name validation
    if (data.username.trim().isEmpty) {
      throw ValidationException('Username is required');
    }

    // Check username uniqueness
    final existing = await (_db.select(_db.accounts)
          ..where((t) => t.username.equals(data.username) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (existing != null) {
      throw ValidationException('Username already exists');
    }

    // Password validation
    if (data.password.trim().isEmpty) {
      throw ValidationException('Password is empty');
    }
  }

  /// Create a new author (assumes data is already validated)
  /// Returns the new account ID
  Future<int> createAccount(CreateAccountData data) async {
    final id = await _db.into(_db.accounts).insert(
          AccountsCompanion.insert(
            username: data.username.trim(),
            password: data.password.trim(),
            isActive: true
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
    ])
      ..where(_db.accounts.isActive.equals(true));

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
  // DELETE OPERATIONS (Soft Delete)
  // ============================================================

  /// Validate account deletion
  Future<void> validateDeleteAccount(int id) async {
    final account = await (_db.select(_db.accounts)
          ..where((t) => t.account_id.equals(id) & t.isActive.equals(true)))
        .getSingleOrNull();

    if (account == null) {
      throw ValidationException('Account ID $id does not exist or is already deleted');
    }
  }

  /// Soft delete an account (set isActive = false)
  Future<void> deleteAccount(int id, {String deletedBy = 'system'}) async {

    await (_db.update(_db.accounts)..where((t) => t.account_id.equals(id))).write(
      AccountsCompanion(
        isActive: const Value(false)
      ),
    );
  }
}