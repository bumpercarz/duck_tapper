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

/// Custom CORS middleware to allow frontend access
Handler _corsMiddleware(Handler handler) {
  return (context) async {
    // Handle preflight OPTIONS requests
    if (context.request.method == HttpMethod.options) {
      return Response(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Access-Control-Max-Age': '86400', // 24 hours
        },
      );
    }

    // Process the request
    final response = await handler(context);

    // Add CORS headers to all responses
    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  };
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