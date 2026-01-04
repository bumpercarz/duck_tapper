import 'package:duck_tapper/models/duck.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duck_tapper/models/account.dart'; 

void main() {
  group('Account and Duck Model Tests', () {
    // TEST 1: The "Happy Path"
    test('fromJson parses valid JSON correctly', () {
      final json = {'account_id': 1, 'username': 'Test Item', 'password': 'passwordtrue'};
      final account = Account.fromJson(json);
      expect(account.username, 'Test Item');
      expect(account.password, 'passwordtrue');
    });

    // TEST 2: The "Edge Case" (Default Values)
    test('fromJson handles missing values by defaulting to 0', () {
      final json = {'duck_id': 1, 'account_id': 1}; // Missing duck data
      final duck = Duck.fromJson(json);
      expect(duck.toString(), 'Duck(account_id: 1, totalQuack: 0, currentQuack: 0, duckTaps: 0, moreDucks: 0, fish: 0, watermelon: 0, ponds: 0)'); 
    });
    
    // TEST 3: Simple Logic
    test('Account validator returns true for valid account', () {
      final json = {'account_id': 1, 'username': 'Test Item', 'password': 'passwordtrue'};
      final account = Account.fromJson(json);
      final test = account.toString();
      expect(test, 'Account(id: 1, username: Test Item, password: passwordtrue)');
    });
  });
}