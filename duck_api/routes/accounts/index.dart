import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/account_service.dart';
import '../../lib/types/account_types.dart';
import '../../lib/exceptions/validation_exception.dart';


// ============================================================
// ROUTE HANDLER - Acts as a "highway" that routes to functions
// ============================================================

Future<Response> onRequest(RequestContext context) async {
  final service = context.read<AccountService>();

  // Route to appropriate handler function based on HTTP method
  return switch (context.request.method) {
    HttpMethod.get => _fetchAccounts(service),
    HttpMethod.post => _addAccount(context, service),
    _ => Future.value(Response(statusCode: 405)), // Method not allowed
  };
}

// ============================================================
// GET - Fetch all authors
// ============================================================

Future<Response> _fetchAccounts(AccountService service) async {
  try {
    final accounts = await service.getAllAccounts();
    return Response.json(
      body: accounts.map((a) => a.toJson()).toList(),
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to fetch accounts: ${e.toString()}'},
    );
  }
}

// ============================================================
// POST - Create new author
// Pattern: Parse → Validate → Execute
// ============================================================

Future<Response> _addAccount(
  RequestContext context,
  AccountService service,
) async {
  try {
    // Step 1: Parse JSON to type class (type casting only)
    final body = await context.request.json() as Map<String, dynamic>;
    final data = CreateAccountData.fromJson(body);

    // Step 2: Validate (service method)
    await service.validateCreateAccount(data);

    // Step 3: Execute (service method)
    final id = await service.createAccount(data);

    // Step 4: Return success response
    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Account created successfully',
        'id': id,
      },
    );
  } on ValidationException catch (e) {
    // Validation errors → HTTP 400
    return Response.json(
      statusCode: 400,
      body: {'error': e.message},
    );
  } catch (e) {
    // Unexpected errors → HTTP 500
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to create account: ${e.toString()}'},
    );
  }
}