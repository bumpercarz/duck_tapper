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
  
  int _selectedDuckIndex = 0;
  int _totalQuacks = 0;
  int _currentQuacks = 0;
  int _duckTaps = 0;

    // The current scale of the image (1.0 is original size)
  double _scale = 1.0;
  // The desired size when the image is "pressed"
  final double _pressedScale = 0.8; 
  // The duration for the animation
  final Duration _duration = const Duration(milliseconds: 300);

  // Function to handle the tap event
  void _onTap() {
    setState(() {
      _scale = _pressedScale; // Scale down on tap
    });
    // Use Future.delayed to return to the original size after the animation
    Future.delayed(_duration, () {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _scale = 1.0; // Return to normal size
        });
      }
    });
    _totalQuacks++;
    _currentQuacks++;
    _duckTaps++;
    debugPrint("Quacked!");
  }

  // Optional: Add hover functionality for desktop/web
  void _onHover(bool isHovering) {
    setState(() {
      // Scale down slightly on hover, or keep original size if not hovering
      _scale = isHovering ? 0.9 : 1.0;
    });
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _totalQuacks++;
      _currentQuacks++;
      _duckTaps++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
              // Use MouseRegion to detect hover events 
              Container(
                padding: EdgeInsets.only(bottom: 110),
                child:MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  child: GestureDetector(
                    onTap: _onTap, 
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
              margin: EdgeInsets.only(bottom: 110),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(color: Color(0x24947257)),
              child: Center(
                child: _currentQuacks == 1
                
                ?Text(
                  '$_currentQuacks Quack', 
                   style: TextStyle(
                    fontSize:32, 
                    color: Colors.white)
                )
                :Text(
                  '$_currentQuacks Quacks', 
                   style: TextStyle(
                    fontSize:32, 
                    color: Colors.white)
                )
              ),
            )
          ],
        ),
      )
    );
  }
}