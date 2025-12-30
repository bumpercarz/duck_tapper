import '../screens/details_screen.dart';
import '../screens/upgrade_screen.dart';
import '../services/quack_logic.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

/// Screen for when you tap the glowy ducky
/// 

class DuckScreen extends StatefulWidget {
  const DuckScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _DuckState createState() => _DuckState();
}

class _DuckState extends State<DuckScreen> {
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
              width: 28,
            ),
          ),
          )
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
              // Use MouseRegion to detect hover events 
              Container(
                padding: EdgeInsets.only(bottom: 110),
                child:MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  child: GestureDetector(
                    onTap: _incrementQuacks, 
                    child: AnimatedScale(
                      scale: _scale,
                      duration: _duration,
                      // Use a bouncy curve for the animation
                      curve: Curves.bounceOut, 
                      child:  DropShadowImage(
                            image: Image.asset(
                              'assets/images/DUCK PNG.png', 
                              width: 253,
                              height: 259,
                            ),
                            offset: Offset(0, 4),
                            blurRadius: 150,
                            scale: 1,
                          )
                        )
                    ),
                ),
              ),

            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(color: Color(0x24947257)),
              child: Center(
                child: currentQuacks == 1
                
                ?Text(
                  '$currentQuacks Quack', 
                   style: TextStyle(
                    fontSize:32, 
                    color: Colors.white)
                )
                :Text(
                  '$currentQuacks Quacks \n$totalQuacks $currentQuacks $duckTaps', 
                   style: TextStyle(
                    fontSize:32, 
                    color: Colors.white)
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}