import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/duck.dart';
import '../services/duck_logic.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {

    
    int totalQuacks = Provider.of<DuckLogic>(context).totalQuacks;
    int currentQuacks = Provider.of<DuckLogic>(context).currentQuacks;
    int duckTaps = Provider.of<DuckLogic>(context).duckTaps;
    int moreDucks = Provider.of<DuckLogic>(context).moreDucks;
    int fish = Provider.of<DuckLogic>(context).fish;
    int watermelon = Provider.of<DuckLogic>(context).watermelon;
    int pond = Provider.of<DuckLogic>(context).pond;
    int totalUpgrades = moreDucks + fish + watermelon + pond;



    return Scaffold(
      backgroundColor: Color(0xFF453324),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(134.0),
        child: AppBar(
          titleSpacing: 0,
          title: const Padding(
            padding: EdgeInsets.only(top:100,bottom:75),
            child: Text(
              "Ducky Quacker", 
              style: TextStyle(
                fontSize:39, 
                color: Colors.white))),
          centerTitle: true,
          backgroundColor: Color(0xFF265490),
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFF734014),
              width: 28,
            ),
          ),
          )
        ),
      body: Column(
        children:[
          Container(
            color: Color(0xFF2B1F14),
            width: .infinity,
            height: 63,
            alignment: .center,
            child: Text('Details', style: TextStyle(fontSize: 32))
          ),
          Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .start,
            children:[
              Text(
                'totalQuacks: $totalQuacks \ncurrent Quacks: $currentQuacks \nduck taps: $duckTaps \ntotal upgrades: $totalUpgrades'
              )
            ]
          )
        ]
      )
    );
  }
}