import 'package:duck_tapper/providers/duck_provider.dart';
import 'package:duck_tapper/screens/details_screen.dart';
import 'package:duck_tapper/screens/duck_screen.dart';
import 'package:provider/provider.dart';
import '../screens/details_screen.dart';
import 'package:flutter/material.dart';

class UpgradesScreen extends StatefulWidget {
  const UpgradesScreen({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _UpgradeState createState() => _UpgradeState();
}

class _UpgradeState extends State<UpgradesScreen> {
  int _selectedDuckIndex = 1;

  List<Widget> screens = [
    DuckScreen(),
    UpgradesScreen(),
    DetailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    
    int currentQuacks = Provider.of<DuckModel>(context).currentQuacks;
    int moreDucks = Provider.of<DuckModel>(context).moreDucks;
    int fish = Provider.of<DuckModel>(context).fish;
    int watermelon = Provider.of<DuckModel>(context).watermelon;
    int pond = Provider.of<DuckModel>(context).pond;
    
    return Scaffold(
      backgroundColor: Color(0xFF2B1F14),
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
              width: 51,
            ),
          ),
          )
        ),
      body: Column(
          mainAxisAlignment: .start,
          children: [
            Container(
              height: 128,
              alignment: .center,
              child:Card(
                color: Color(0xFF66A2B8),
                margin: EdgeInsets.only(top:10),
                elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                child: Row(
                  children: [
                    ListTile(
                      leading: Image.asset('assets/images/Flying Duck.png', width: 90, height: 90,),
                      title: Text("Card Title", style: TextStyle(color: Colors.black)),
                      subtitle: Text("This card spans the screen width."),
                    ),
                    Column(
                      children:[

                      ]
                    ),
                  ]
                )
              ),
            )
          ],
        ),
    );
  }
}