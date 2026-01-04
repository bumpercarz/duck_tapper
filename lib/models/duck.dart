/// Duck Model Class
///
/// This model matches the API response structure from the Dart Frog backend.
/// API Response comes from: duck_api/lib/types/duck_types.dart (AuthorResponse class)
class Duck {
  final int? id; // Nullable for new ducks (not yet saved to API)
  final int account_id;
  final int? totalQuack;
  final int? currentQuack;
  final int? duckTaps;
  final int? moreDucks;
  final int? fish;
  final int? watermelon;
  final int? ponds;
  Duck({
    this.id,
    required this.account_id,
    required this.currentQuack,
    required this.duckTaps, 
    required this.totalQuack, 
    required this.moreDucks, 
    required this.fish, 
    required this.watermelon, 
    required this.ponds
  });

  /// Parse JSON response from API into Duck object
  ///
  /// Used when receiving data from:
  /// - GET /ducks (list of books)
  /// - GET /ducks/:id (single book)
  ///
  /// API Source: duck_api/lib/services/duck_service.dart → getAllDucks()
  factory Duck.fromJson(Map<String, dynamic> json) {
    return Duck(
      id: json['duck_id'] as int,
      account_id: json['account_id'] as int,
      totalQuack: json['totalQuack'] as int? ?? 0,
      currentQuack: json['currentQuack'] as int? ?? 0,
      duckTaps: json['duckTaps'] as int? ?? 0,
      moreDucks: json['moreDucks'] as int? ?? 0,
      fish: json['fish'] as int? ?? 0,
      watermelon: json['watermelon'] as int? ?? 0,
      ponds: json['ponds'] as int? ?? 0,
    );
  }

  /// Convert Book object to JSON for API requests
  ///
  /// Used when sending data to:
  /// - POST /ducks (create new book)
  /// - PUT /ducks/:id (update existing book)
  ///
  /// Note: Only includes fields that the API accepts for creation/update
  /// (id, timestamps, and authorName are managed by the API)
  ///
  /// API Validation: duck_api/lib/services/duck_service.dart
  /// - validateCreateDuck():
  ///   * Validates accountId (must exist)
  ///
  Map<String, dynamic> toJson() {
    return {
      'account_id': account_id,
      'totalQuack': totalQuack,
      'currentQuack': currentQuack,
      'duckTaps': duckTaps,
      'moreDucks': moreDucks,
      'fish': fish,
      'watermelon': watermelon,
      'ponds': ponds
    };
  }

  /// Create a copy of this Duck with updated fields
  /// Useful for updating duck data in the UI
  Duck copyWith({
    int? account_id,
    int? totalQuack,
    int? currentQuack,
    int? duckTaps,
    int? moreDucks,
    int? fish,
    int? watermelon,
    int? ponds
  }) {
    return Duck(
      account_id: account_id ?? this.account_id,
      totalQuack: totalQuack ?? this.totalQuack,
      currentQuack: currentQuack ?? this.currentQuack,
      duckTaps: duckTaps ?? this.duckTaps,
      moreDucks: moreDucks ?? this.moreDucks,
      fish: fish ?? this.fish,
      watermelon: watermelon ?? this.watermelon,
      ponds: ponds ?? this.ponds
    );
  }

  @override
  String toString() {
    return 'Duck(account_id: $account_id, totalQuack: $totalQuack, currentQuack: $currentQuack, duckTaps: $duckTaps, moreDucks: $moreDucks, fish: $fish, watermelon: $watermelon, ponds: $ponds)';
  }
}
