import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/duck_service.dart';
import '../../lib/types/duck_types.dart';
import '../../lib/exceptions/validation_exception.dart';


// ============================================================
// ROUTE HANDLER - Acts as a "highway" that routes to functions
// ============================================================

Future<Response> onRequest(RequestContext context) async {
  final service = context.read<DuckService>();

  // Route to appropriate handler function based on HTTP method
  return switch (context.request.method) {
    HttpMethod.get => _fetchDucks(service),
    HttpMethod.post => _addDuck(context, service),
    _ => Future.value(Response(statusCode: 405)), // Method not allowed
  };
}

// ============================================================
// GET - Fetch all books
// ============================================================

Future<Response> _fetchDucks(DuckService service) async {
  try {
    final ducks = await service.getAllDucks();
    return Response.json(
      body: ducks.map((d) => d.toJson()).toList(),
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to fetch ducks: ${e.toString()}'},
    );
  }
}

// ============================================================
// POST - Create new duck
// Pattern: Parse → Validate → Execute
// ============================================================

Future<Response> _addDuck(
  RequestContext context,
  DuckService service,
) async {
  try {
    // Step 1: Parse JSON to type class (type casting only)
    final body = await context.request.json() as Map<String, dynamic>;
    final data = CreateDuck.fromJson(body);

    // Step 2: Validate (service method)
    await service.validateCreateDuck(data);

    // Step 3: Execute (service method)
    final id = await service.createDuck(data);

    // Step 4: Return success response
    return Response.json(
      statusCode: 201,
      body: {
        'message': 'New duck has arrived. Quack quack.',
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
      body: {'error': 'Failed to create duck: ${e.toString()}'},
    );
  }
}