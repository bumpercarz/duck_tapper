import 'package:duck_tapper/providers/account_provider.dart';
import 'package:duck_tapper/providers/duck_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/duck.dart';
import '../services/duck_logic.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  _DetailState createState() => _DetailState();
}


class _DetailState extends State<DetailsScreen> {

  @override
  void initState(){
    super.initState();
    
    Future.microtask(() {
      context.read<AccountProvider>().fetchAccounts();
      context.read<DuckProvider>().fetchDucks();
      }
    );
  }
  
    int _totalQuacks = 0;
    int _currentQuacks = 0;
    int _duckTaps = 0;
    int _moreDucks = 0;
    int _fish = 0;
    int _watermelon = 0;
    int _pond = 0;
    late int totalUpgrades = _moreDucks + _fish + _watermelon + _pond;

  void _saveDuck(BuildContext context) async {

    int loggedAccount = context.read<AccountProvider>().loggedAccount ?? 0;
    // Update duck information in current account
    Duck updateDuck = Duck (
      account_id: loggedAccount, 
      totalQuack: _totalQuacks, 
      currentQuack: _currentQuacks, 
      duckTaps: _duckTaps, 
      moreDucks: _moreDucks, 
      fish: _fish, 
      watermelon: _watermelon, 
      ponds: _pond
    );

    Duck oldDuck =await context.read<DuckProvider>().getDucksByAccount(loggedAccount);

    context.read<DuckProvider>().updateDuck(oldDuck.id ?? 0, updateDuck);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duck Saved!')),
    );
  }

  void _eraseDuck(BuildContext context) async {
    // Erase duck information in current account
    // should have a pop-up for confirmation

    int loggedAccount = context.read<AccountProvider>().loggedAccount ?? 0;

    Duck newDuck = Duck (
      account_id: loggedAccount, 
      totalQuack: 0, 
      currentQuack: 0, 
      duckTaps: 0, 
      moreDucks: 0, 
      fish: 0, 
      watermelon: 0, 
      ponds: 0
    );

    Duck oldDuck =await context.read<DuckProvider>().getDucksByAccount(loggedAccount);
    context.read<DuckProvider>().deleteDuck(oldDuck.id ?? 0);
    context.read<DuckProvider>().createDuck(newDuck);
    Provider.of<DuckLogic>(context, listen: false).loadSavedDuck(context, loggedAccount);
    setState(() {
      _totalQuacks = 0;
      _currentQuacks = 0;
      _duckTaps = 0;
      _moreDucks = 0;
      _fish = 0;
      _watermelon = 0;
      _pond = 0;
      totalUpgrades = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This duck is gone :( but it was replaced by another, new duck!')),
    );
  }

    // Logs out of account and brings user back to login_screen
  void _logout(BuildContext context) async {

    // Set Logged account to 0
    context.read<AccountProvider>().setLoggedAccount(0);
    // Navigate back to home and remove all routes
    Navigator.pushNamedAndRemoveUntil(
        context, 
        '/', 
        (route) => false
    );
    
  }

    // Deletes account and brings user back to login_screen
  void _deleteAccount(BuildContext context) async {
    
    int loggedAccount = context.read<AccountProvider>().loggedAccount ?? 0;
    context.read<AccountProvider>().deleteAccount(loggedAccount);
    context.read<AccountProvider>().setLoggedAccount(0);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted. Register to create a new one!')),
    );
    _logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    final duckLogic = context.watch<DuckLogic>();

    int totalUpgrades = duckLogic.moreDucks + duckLogic.fish + duckLogic.watermelon + duckLogic.pond;



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
                  'totalQuacks: ${duckLogic.totalQuacks} \n'
                  'current Quacks: ${duckLogic.currentQuacks} \n'
                  'duck taps: ${duckLogic.duckTaps} \n'
                  'total upgrades: $totalUpgrades',
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
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Erase Duck'),
                              content: const Text('Erase current duck? \nThis will remove all of your current progress and set all quacks to zero.', style: TextStyle(color: Colors.black, fontSize: 15)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'), 
                                  child: const Text('Cancel'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    textStyle: TextStyle(fontSize: 14)
                                  )
                                ),
                                TextButton(
                                  onPressed: () => _eraseDuck(context), 
                                  child: const Text('Erase duck'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xFFE24C15),
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                  )
                                ),    
                              ],
                            )
                          ),
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
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Log out of account?', style: TextStyle(color: Colors.black, fontSize: 15)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'), 
                                  child: const Text('Cancel'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    textStyle: TextStyle(fontSize: 14)
                                  )
                                ),
                                TextButton(
                                  onPressed: () => _logout(context), 
                                  child: const Text('Logout'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xFFE24C15),
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                  )
                                ),    
                              ],
                            )
                          ),
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
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text('Are you sure? This will log you out and delete this account, along with any duck-related data it has!', style: TextStyle(color: Colors.black, fontSize: 15)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'), 
                                child: const Text('Cancel'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 14)
                                )
                              ),
                              TextButton(
                                onPressed: () => _deleteAccount(context), 
                                child: const Text('Delete'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFE24C15),
                                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                )
                              ),    
                            ],
                          )
                        ),
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