import 'package:duck_tapper/providers/account_provider.dart';
import 'package:duck_tapper/providers/duck_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
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

void _saveDuck(BuildContext context) async {
  // Update duck information in current account
  
  
}

void _eraseDuck(BuildContext context) async {
  // Erase duck information in current account
  // should have a pop-up for confirmation
  
  //probably has one of this somewhere im jus dum at logic
  //context.read<DuckProvider>().deleteDuck(id);
}

void _logout(BuildContext context) async {
  // Logs out of account and brings user back to login_screen
  // should have a pop-up for confirmation
  
  // Set Logged account to 0
  context.read<AccountProvider>().setLoggedAccount(0);
  // Navigate back to home and remove all routes
  Navigator.pushNamedAndRemoveUntil(
      context, 
      '/', 
      (route) => false
  );
  
}

void _deleteAccount(BuildContext context) async {
  // Deletes account and brings user back to login_screen
  // should have a pop-up for confirmation
  
  
}


class _DetailState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
          title: Padding(
            padding: EdgeInsets.only(top:.1*screenHeight,bottom:.075*screenHeight),
            child: Text(
              "Ducky Quacker", 
              style: TextStyle(
                fontSize:.039*screenHeight, 
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
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'totalQuacks: $totalQuacks \ncurrent Quacks: $currentQuacks \nduck taps: $duckTaps \ntotal upgrades: $totalUpgrades',
                  style: TextStyle(fontSize: 23, color: Colors.white, height: 1.35),
                ),
              ),

              Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children:[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[

                      // Save button
                      Container(
                        margin: EdgeInsets.only(top:20),
                        child:ElevatedButton(
                          onPressed: () => _saveDuck(context),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(169, 36),
                            backgroundColor: Color(0xFF64C91E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                            textAlign: TextAlign.center
                          ),
                        )
                      ),

                      // Erase data button
                      Container(
                        margin: EdgeInsets.only(top:20),
                        child:ElevatedButton(
                          onPressed: () => _eraseDuck(context),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(169, 36),
                            backgroundColor: Color(0xFFE24C15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Erase data ',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                            textAlign: TextAlign.center
                          ),
                        )
                      ),
                       
                    ]
                  ),

                  Column(
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .end,
                    children:[

                      // Logout button
                      Container(
                        height: 0.225 * screenHeight,
                        alignment: .bottomCenter,
                        margin: EdgeInsets.only(top:20),
                        child:ElevatedButton(
                          onPressed: () => _logout(context),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(240, 50),
                            backgroundColor: Color(0xFFCA8C35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        )
                      ),

                      // Delete account button
                      TextButton(
                        onPressed: () => _deleteAccount(context), 
                        child: Text('Delete account'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 17, decoration: TextDecoration.underline)
                        )
                      )
                    ]
                  ),

                  
                ]
              )
            ]
          )
        ]
      )
    );
  }
}