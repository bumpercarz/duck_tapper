import '../screens/details_screen.dart';
import '../screens/upgrade_screen.dart';
import '../screens/duck_screen.dart';
import '../services/quack_logic.dart';
import 'package:flutter/material.dart';
/// Screen for when you tap the glowy ducky
/// 

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<NavScreen> {
  final _selectedBackGroundColor = Color(0xFF895F24);
  final _unselectedBackGroundColor = Color(0xFFCA8C35);
  int _selectedDuckIndex = 0;

  List<Widget> screens = [
    DuckScreen(),
    UpgradesScreen(),
    DetailsScreen(),
  ];
  
  int totalQuacks = 0;
  int currentQuacks = 0;
  int duckTaps = 0;

  
  Color _getBgColor(int index) => _selectedDuckIndex == index
      ? _selectedBackGroundColor
      : _unselectedBackGroundColor;

  void _onItemTapped(int index) {
    setState(() {
      _selectedDuckIndex = index;
    });
  }

  Widget _buildIcon(String iconData, String text, int index) => Container(
    width: double.infinity,
    height: 120,
    child: Material(
      color:  _getBgColor(index),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(iconData, width: 90, height: 90),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )
            ),
          ],
        ),
        onTap: () => _onItemTapped(index),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B1F14),
      body: screens[_selectedDuckIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFCA8C35),
          border: Border(
            top: BorderSide(color: Color(0xFF734014), width: 28.0), 
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: BottomNavigationBar(
          selectedFontSize: 0,
          backgroundColor: Color(0xFF734014),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon(
                'assets/images/Duck.png',
                'Duck',
                0
              ),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                'assets/images/Buy Upgrade.png',
                'Upgrades',
                1
              ),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                'assets/images/Analytics.png',
                'Info',
                2
              ),
              label: ''
            )
          ],
          currentIndex: _selectedDuckIndex,
        ),
      )
    );
  }
}