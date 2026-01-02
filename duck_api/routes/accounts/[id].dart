import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/account_service.dart';
import '../../lib/types/account_types.dart';
import '../../lib/exceptions/validation_exception.dart';

// ============================================================
// ROUTE HANDLER - Acts as a "highway" that routes to functions
// ============================================================

Future<Response> onRequest(RequestContext context, String id) async {
  final service = context.read<AccountService>();

  // Parse and validate ID parameter
  final account_id = int.tryParse(id);
  if (account_id == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid account ID format'},
    );
  }

  // Route to appropriate handler function based on HTTP method
  return switch (context.request.method) {
    HttpMethod.get => _fetchAccount(service, account_id),
    HttpMethod.delete => _deleteAccount(service, account_id),
    _ => Future.value(Response(statusCode: 405)), // Method not allowed
  };
}

// ============================================================
// GET - Fetch single author by ID
// ============================================================

Future<Response> _fetchAccount(AccountService service, int account_id) async {
  try {
    final account = await service.getAccountById(account_id);

    if (account == null) {
      return Response.json(
        statusCode: 404,
        body: {'error': 'Account not found'},
      );
    }

    return Response.json(body: account.toJson());
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to fetch account: ${e.toString()}'},
    );
  }
}

// ============================================================
// PUT - Update account
// Pattern: Parse → Validate → Execute
// ============================================================

Future<Response> _updateAccount(
  RequestContext context,
  AccountService service,
  int account_id,
) async {
  try {
    // Step 1: Parse JSON to type class (type casting only)
    final body = await context.request.json() as Map<String, dynamic>;
    final data = UpdateAccountData.fromJson(body);

    // Step 2: Validate (service method)
    await service.validateUpdateAccount(account_id, data);

    // Step 3: Execute (service method)
    await service.updateAccount(account_id, data);

    // Step 4: Return success response
    return Response.json(
      body: {'message': 'Account updated successfully'},
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
      body: {'error': 'Failed to update account: ${e.toString()}'},
    );
  }
}


// ============================================================
// DELETE - Soft delete author
// Pattern: Validate → Execute
// ============================================================

Future<Response> _deleteAccount(AccountService service, int account_id) async {
  try {
    // Step 1: Validate (checks existence and constraints)
    await service.validateDeleteAccount(account_id);

    // Step 2: Execute soft delete
    await service.deleteAccount(account_id);

    // Step 3: Return success response
    return Response.json(
      body: {'message': 'Account deleted successfully'},
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
      body: {'error': 'Failed to delete author: ${e.toString()}'},
    );
  }
}