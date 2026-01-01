import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/duck_service.dart';
import '../../lib/types/duck_types.dart';
import '../../lib/exceptions/validation_exception.dart';

// ============================================================
// ROUTE HANDLER - Acts as a "highway" that routes to functions
// ============================================================

Future<Response> onRequest(RequestContext context, String id) async {
  final service = context.read<DuckService>();

  // Parse and validate ID parameter
  final duck_id = int.tryParse(id);
  if (duck_id == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid duck ID. Go to jail >:CC'},
    );
  }

  // Route to appropriate handler function based on HTTP method
  return switch (context.request.method) {
    HttpMethod.get => _fetchDuck(service, duck_id),
    HttpMethod.put => _updateDuck(context, service, duck_id),
    HttpMethod.delete => _deleteDuck(service, duck_id),
    _ => Future.value(Response(statusCode: 405)), // Method not allowed
  };
}

// ============================================================
// GET - Fetch single duck by ID
// ============================================================

Future<Response> _fetchDuck(DuckService service, int duck_id) async {
  try {
    final duck = await service.getDuckById(duck_id);

    if (duck == null) {
      return Response.json(
        statusCode: 404,
        body: {'error': 'Book not found'},
      );
    }

    return Response.json(body: duck.toJson());
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to fetch duck: ${e.toString()}'},
    );
  }
}

// ============================================================
// PUT - Update duck
// Pattern: Parse → Validate → Execute
// ============================================================

Future<Response> _updateDuck(
  RequestContext context,
  DuckService service,
  int duck_id,
) async {
  try {
    // Step 1: Parse JSON to type class (type casting only)
    final body = await context.request.json() as Map<String, dynamic>;
    final data = UpdateDuck.fromJson(body);

    // Step 2: Validate (service method)
    await service.validateUpdateDuck(duck_id, data);

    // Step 3: Execute (service method)
    await service.updateDuck(duck_id, data);

    // Step 4: Return success response
    return Response.json(
      body: {'message': 'Duck updated successfully'},
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
      body: {'error': 'Failed to update duck: ${e.toString()}'},
    );
  }
}

// ============================================================
// DELETE - Soft delete duck
// Pattern: Validate → Execute
// ============================================================

Future<Response> _deleteDuck(DuckService service, int duck_id) async {
  try {
    // Step 1: Validate (checks existence)
    await service.validateEraseDuck(duck_id);

    // Step 2: Execute soft delete
    await service.eraseDuck(duck_id);

    // Step 3: Return success response
    return Response.json(
      body: {'message': 'Duck data deleted successfully'},
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
      body: {'error': 'Failed to delete duck: ${e.toString()}'},
    );
  }
}