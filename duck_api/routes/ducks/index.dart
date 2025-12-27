import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/duck_service.dart';
import '../../lib/types/duck_types.dart';
import '../../lib/exceptions/validation_exception.dart';


// unedited vvv

// ============================================================
// ROUTE HANDLER - Acts as a "highway" that routes to functions
// ============================================================

Future<Response> onRequest(RequestContext context) async {
  final service = context.read<BookService>();

  // Route to appropriate handler function based on HTTP method
  return switch (context.request.method) {
    HttpMethod.get => _fetchBooks(service),
    HttpMethod.post => _addBook(context, service),
    _ => Future.value(Response(statusCode: 405)), // Method not allowed
  };
}

// ============================================================
// GET - Fetch all books
// ============================================================

Future<Response> _fetchBooks(BookService service) async {
  try {
    final books = await service.getAllBooks();
    return Response.json(
      body: books.map((b) => b.toJson()).toList(),
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to fetch books: ${e.toString()}'},
    );
  }
}

// ============================================================
// POST - Create new book
// Pattern: Parse → Validate → Execute
// ============================================================

Future<Response> _addBook(
  RequestContext context,
  BookService service,
) async {
  try {
    // Step 1: Parse JSON to type class (type casting only)
    final body = await context.request.json() as Map<String, dynamic>;
    final data = CreateBookData.fromJson(body);

    // Step 2: Validate (service method)
    await service.validateCreateBook(data);

    // Step 3: Execute (service method)
    final id = await service.createBook(data);

    // Step 4: Return success response
    return Response.json(
      statusCode: 201,
      body: {
        'message': 'Book created successfully',
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
      body: {'error': 'Failed to create book: ${e.toString()}'},
    );
  }
}