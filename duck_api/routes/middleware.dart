import 'package:dart_frog/dart_frog.dart';
import '../lib/database.dart';
import '../lib/services/account_service.dart';
import '../lib/services/duck_service.dart';

// Singleton instantiation - create instances at module level
final _db = AppDatabase();
final _accountService = AccountService(_db);
final _duckService = DuckService(_db);

// Seed database on startup
Future<void> _initializeDatabase() async {
  await _db.seedData();
}

/// Middleware that provides services to all routes
Handler middleware(Handler handler) {
  // Trigger database seeding (runs once)
  _initializeDatabase();

  return handler
      .use(requestLogger())
      .use(provider<AppDatabase>((_) => _db))
      .use(provider<AccountService>((_) => _accountService))
      .use(provider<DuckService>((_) => _duckService));
}