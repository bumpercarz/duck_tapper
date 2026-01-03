import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duck.dart';
import '../providers/duck_provider.dart';
import '../providers/account_provider.dart';

class DuckLogic with ChangeNotifier {

  int _totalQuacks = 0;
  int _currentQuacks = 0;
  int _duckTaps = 0;
  int _moreDucks = 0;
  int _fish = 0;
  int _watermelon = 0;
  int _pond = 0;

  int get totalQuacks => _totalQuacks;
  int get currentQuacks => _currentQuacks;
  int get duckTaps => _duckTaps;

  int get moreDucks => _moreDucks;
  int get fish => _fish;
  int get watermelon => _watermelon;
  int get pond => _pond;

  Future<void> loadSavedDuck (BuildContext context, int loggedAccount) async {
    final provider = context.read<DuckProvider>();

    Duck _ducks = await provider.getDucksByAccount(loggedAccount); 

    _totalQuacks = _ducks.totalQuack ?? 0;
    _currentQuacks = _ducks.currentQuack ?? 0;
    _duckTaps = _ducks.duckTaps ?? 0;
    _moreDucks = _ducks.moreDucks ?? 0;
    _fish = _ducks.fish ?? 0;
    _watermelon = _ducks.watermelon ?? 0;
    _pond = _ducks.ponds ?? 0;
  }

  void addQuacks(int moreDucks, int fish, int watermelon, int pond) {
    _totalQuacks = (_totalQuacks+1) + 1*moreDucks + 10*fish + 25*watermelon + 75*pond;
    _currentQuacks = (_currentQuacks+1) + 1*moreDucks + 10*fish + 25*watermelon + 75*pond;
    _duckTaps++;
    notifyListeners(); // Notify all listening widgets
  }

  void buyMoreDucks(int price){
    _currentQuacks = _currentQuacks - price;
    _moreDucks++;
    notifyListeners(); //
  }
  
  void buyFish(int price){
    _currentQuacks = _currentQuacks - price;
    _fish++;
    notifyListeners(); //
  }
  
  void buyWatermelon(int price){
    _currentQuacks = _currentQuacks - price;
    _watermelon++;
    notifyListeners(); //
  }
  
  void buyPond(int price){
    _currentQuacks = _currentQuacks - price;
    _pond++;
    notifyListeners(); //
  }
}