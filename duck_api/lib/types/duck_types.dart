// ============================================================
// REQUEST TYPES (Incoming Data)
// ============================================================

/// Type class for a new Duck
class CreateDuck {
  final int duck_id;
  final int account_id;  // Foreign key
  final int totalQuack;
  final int currentQuack;
  final int duckTaps;
  final int moreDucks;
  final int fish;
  final int watermelon;
  final int ponds;

  CreateDuck({
    required this.duck_id,
    required this.account_id,
    required this.totalQuack,
    required this.currentQuack,
    required this.duckTaps,
    required this.moreDucks,
    required this.fish,
    required this.watermelon,
    required this.ponds,
  });

  /// Factory constructor - Type casting only
  factory CreateDuck.fromJson(Map<String, dynamic> json) {
    return CreateDuck(
      duck_id: json['duck_id'] as int? ?? 0,
      account_id: json['account_id'] as int? ?? 0,
      totalQuack: json['totalQuack'] as int? ?? 0,
      currentQuack: json['currentQuack'] as int? ?? 0,
      duckTaps: json['duckTaps'] as int? ?? 0,
      moreDucks: json['moreDucks'] as int? ?? 0,
      fish: json['fish'] as int? ?? 0,
      watermelon: json['watermelon'] as int? ?? 0,
      ponds: json['ponds'] as int? ?? 0,
    );
  }
}

/// Type class for updating a Duck
class UpdateDuck {
  final int totalQuack;
  final int currentQuack;
  final int duckTaps;
  final int moreDucks;
  final int fish;
  final int watermelon;
  final int ponds;

  UpdateDuck({
    required this.totalQuack,
    required this.currentQuack,
    required this.duckTaps,
    required this.moreDucks,
    required this.fish,
    required this.watermelon,
    required this.ponds
  });

  factory UpdateDuck.fromJson(Map<String, dynamic> json) {
    return UpdateDuck(
      totalQuack: json['totalQuack'] as int? ?? 0,
      currentQuack: json['currentQuack'] as int? ?? 0,
      duckTaps: json['duckTaps'] as int? ?? 0,
      moreDucks: json['moreDucks'] as int? ?? 0,
      fish: json['fish'] as int? ?? 0,
      watermelon: json['watermelon'] as int? ?? 0,
      ponds: json['ponds'] as int? ?? 0,
    );
  }

}

// ============================================================
// RESPONSE TYPES (Outgoing Data)
// ============================================================

/// Type class for book responses
/// Includes resolved author name from JOIN
class DuckResponse {
  final int duck_id;
  final int account_id;
  final int totalQuack;
  final int currentQuack;
  final int duckTaps;
  final int moreDucks;
  final int fish;
  final int watermelon;
  final int ponds;

  DuckResponse({
    required this.duck_id,
    required this.account_id,
    required this.totalQuack,
    required this.currentQuack,
    required this.duckTaps,
    required this.moreDucks,
    required this.fish,
    required this.watermelon,
    required this.ponds
  });

  Map<String, dynamic> toJson() => {
        'duck_id': duck_id,
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