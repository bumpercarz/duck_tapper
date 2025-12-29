import '../screens/details_screen.dart';
import '../screens/upgrade_screen.dart';
import '../screens/duck_screen.dart';
import '../services/quack_logic.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

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
  int _selectedDuckIndex = 1;

  List<Widget> screens = [
    DuckScreen(),
    UpgradesScreen(),
    DetailsScreen(),
  ];
  
  int totalQuacks = 0;
  int currentQuacks = 0;
  int duckTaps = 0;

    // The current scale of the image (1.0 is original size)
  double _scale = 1.0;
  // The desired size when the image is "pressed"
  final double _pressedScale = 0.8; 
  // The duration for the animation
  final Duration _duration = const Duration(milliseconds: 200);

  // Function to handle the tap event
  void _incrementQuacks() {
    setState(() {
      _scale = _pressedScale; // Scale down on tap
    });
      totalQuacks = addQuacks(totalQuacks);
      currentQuacks = addQuacks(currentQuacks);
      duckTaps++;
    // Use Future.delayed to return to the original size after the animation
    Future.delayed(_duration, () {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _scale = 1.0; // Return to normal size
        });
      }
    });
      // CHANGE QUACK LOGIC
    
    debugPrint("Quacked!");
  }

  // Optional: Add hover functionality for desktop/web
  void _onHover(bool isHovering) {
    setState(() {
      // Scale down slightly on hover, or keep original size if not hovering
      _scale = isHovering ? 0.9 : 1.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedDuckIndex],
      bottomNavigationBar: Container(
        height: 195,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFCA8C35),
          border: Border(
            top: BorderSide(color: Color(0xFF734014), width: 28.0), 
          ),
          borderRadius: BorderRadius.circular(15), // Rounded corners with a radius of 20
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Image.asset('assets/images/Duck.png', width: 90, height: 90), onPressed: (){
              setState((){
                _selectedDuckIndex = 0;
              });
            }),
            IconButton(icon: Image.asset('assets/images/Buy Upgrade.png', width: 90, height: 90,), onPressed: (){
              setState((){
                _selectedDuckIndex = 1;
              });
            }),
            IconButton(icon: Image.asset('assets/images/Analytics.png', width: 90, height: 90,), onPressed: (){
              setState((){
                _selectedDuckIndex = 2;
              });
            }),
          ],
        )
      )
    );
  }
}