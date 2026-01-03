import '../screens/details_screen.dart';
import '../screens/upgrade_screen.dart';
import '../screens/duck_screen.dart';
import 'package:flutter/material.dart';
/// Screen for when you tap the glowy ducky
/// 

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

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
      backgroundColor:  _selectedDuckIndex==2? Color(0xFF453324):Color(0xFF2B1F14),
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