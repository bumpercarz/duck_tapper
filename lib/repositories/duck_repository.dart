import '../services/api_service.dart';
import '../models/duck.dart';

/// Duck Repository
///
/// Repository pattern abstracts API calls from the UI layer.
/// Each method maps to a specific API endpoint from the Dart Frog backend.
///
/// This creates a clean separation:
/// UI → Provider (State) → Repository (this file) → ApiService → Dart Frog API
///
class DuckRepository {
  final ApiService _apiService = ApiService();


  Future<List<Duck>> getDucks() async {
    final response = await _apiService.get('/ducks');
    return (response as List)
        .map((json) => Duck.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Duck> getDuckById(int id) async {
    final response = await _apiService.get('/ducks/$id');
    return Duck.fromJson(response as Map<String, dynamic>);
  }

  Future<int> createDuck(Duck duck) async {
    final response = await _apiService.post('/ducks', duck.toJson());
    return response['duck_id'] as int;
  }

  Future<void> updateDuck(int id, Duck duck) async {
    await _apiService.put('/ducks/$id', duck.toJson());
  }

  Future<void> deleteDuck(int id) async {
    await _apiService.delete('/ducks/$id');
  }

  Future<List<Duck>> getDucksByAccount(int accountId) async {
    final allDucks = await getDucks();
    return allDucks.where((duck) => duck.account_id == accountId).toList();
  }
}
