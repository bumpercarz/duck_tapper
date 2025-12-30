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