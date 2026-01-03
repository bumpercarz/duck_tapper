import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

part 'database.g.dart';  // Generated file

// ============================================================
// TABLE DEFINITIONS
// ============================================================

/// Accounts table - Parent entity
class Accounts extends Table {
  // Primary key
  IntColumn get account_id => integer().autoIncrement()();

  // Username and Password
  TextColumn get username => text().unique()(); // Unique constraint
  TextColumn get password => text()();       // Soft delete flag
}

/// Duck table - Child entity
class Ducks extends Table {
  // Primary key
  IntColumn get duck_id => integer().autoIncrement()();

  // Business fields
  IntColumn get totalQuack => integer()();
  IntColumn get currentQuack => integer()();
  IntColumn get duckTaps => integer()();
  IntColumn get moreDucks => integer()();
  IntColumn get fish => integer()();
  IntColumn get watermelon => integer()();
  IntColumn get ponds => integer()();

  // Foreign key - References Accounts.account_id
  IntColumn get account_id => integer().references(Accounts, #account_id)();
}

// ============================================================
// DATABASE CLASS
// ============================================================

@DriftDatabase(tables: [Accounts, Ducks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
    );
  }

  // ============================================================
  // SEED DATA (Optional - for development)
  // ============================================================

  Future<void> seedData() async {

    // Check if data already exists
    final accountCount = await (select(accounts).get()).then((rows) => rows.length);
    if (accountCount > 0) return;  // Already seeded

    // Seed accounts
    final accountId1 = await into(accounts).insert(
      AccountsCompanion.insert(
        username: 'test',
        password: 'password'
      ),
    );

    // Seed ducks
    await into(ducks).insert(
      DucksCompanion.insert(
        account_id: accountId1,
        totalQuack: 100,
        currentQuack: 100,
        duckTaps: 100,
        moreDucks: 0,
        fish: 0,
        watermelon: 0,
        ponds: 0
      ),
    );

    print('✓ Database seeded successfully');
  }
}

// ============================================================
// DATABASE CONNECTION
// ============================================================

QueryExecutor _openConnection() {
  // Load environment variables from .env file
  final env = DotEnv()..load();

  // Get database credentials from environment variables
  // NO DEFAULTS - Fail fast if .env is missing or incomplete
  final host = env['POSTGRES_HOST'];
  final portStr = env['POSTGRES_PORT'];
  final database = env['POSTGRES_DB'];
  final username = env['POSTGRES_USER'];
  final password = env['POSTGRES_PASSWORD'];

  // Validate all required environment variables are present
  if (host == null || host.isEmpty) {
    throw Exception('POSTGRES_HOST is not set in .env file');
  }
  if (portStr == null || portStr.isEmpty) {
    throw Exception('POSTGRES_PORT is not set in .env file');
  }
  if (database == null || database.isEmpty) {
    throw Exception('POSTGRES_DB is not set in .env file');
  }
  if (username == null || username.isEmpty) {
    throw Exception('POSTGRES_USER is not set in .env file');
  }
  if (password == null || password.isEmpty) {
    throw Exception('POSTGRES_PASSWORD is not set in .env file');
  }

  final port = int.parse(portStr);

  return PgDatabase(
    endpoint: Endpoint(
      host: host,
      port: port,
      database: database,
      username: username,
      password: password,
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );
}