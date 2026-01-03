import '../services/duck_logic.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

/// Screen for when you tap the glowy ducky
/// 

class DuckScreen extends StatefulWidget {
  const DuckScreen({super.key});
  @override
  _DuckState createState() => _DuckState();
}

class _DuckState extends State<DuckScreen> {

    // The current scale of the image (1.0 is original size)
  double _scale = 1.0;
  // The desired size when the image is "pressed"
  final double _pressedScale = 0.8; 
  // The duration for the animation
  final Duration _duration = const Duration(milliseconds: 200);

  // Function to handle the tap event
  void _incrementQuacks(int moreDucks, int fish, int watermelon, int pond) {
    setState(() {
      _scale = _pressedScale; // Scale down on tap
    });
    
    Provider.of<DuckLogic>(context, listen: false).addQuacks(moreDucks, fish, watermelon, pond);

    // Use Future.delayed to return to the original size after the animation
    Future.delayed(_duration, () {
      if (mounted) { // Check if the widget is still in the tree
        setState(() {
          _scale = 1.0; // Return to normal size
        });
      }
    });
    debugPrint("Quacked!");
  }

  void _onHover(bool isHovering) {
    setState(() {
      // Scale down slightly on hover, or keep original size if not hovering
      _scale = isHovering ? 1.2 : 1.0;
    });
  }


  @override
  Widget build(BuildContext context) {
    
    // Watch for changes (rebuilds the widget when data changes)
    int currentQuacks = Provider.of<DuckLogic>(context).currentQuacks;
    int moreDucks = Provider.of<DuckLogic>(context).moreDucks;
    int fish = Provider.of<DuckLogic>(context).fish;
    int watermelon = Provider.of<DuckLogic>(context).watermelon;
    int pond = Provider.of<DuckLogic>(context).pond;

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
                    onTap: () =>_incrementQuacks(moreDucks,fish,watermelon, pond), 
                    child: AnimatedScale(
                      scale: _scale,
                      duration: _duration,
                      // Use a bouncy curve for the animation
                      curve: Curves.bounceOut, 
                      child:  DropShadowImage(
                            image: 
                            pond > 0?
                            Image.asset(
                              'assets/images/DUCK LAKE.png', 
                              width: 390,
                              height: 376,
                            )
                            : 
                            watermelon > 0?
                            Image.asset(
                              'assets/images/DUCK MELON.png', 
                              width: 374,
                              height: 325,
                            )
                            : 
                            fish > 0?
                            Image.asset(
                              'assets/images/DUCK FISH.png', 
                              width: 374,
                              height: 324,
                            )
                            : 
                            moreDucks > 1 ? 
                            Image.asset(
                              'assets/images/DUCK GROUP.png', 
                              width: 382,
                              height: 270,
                            )
                            : 
                            moreDucks == 1 ? 
                            Image.asset(
                              'assets/images/DUCK 2.png', 
                              width: 382,
                              height: 270,
                            )
                            : 
                            Image.asset(
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
                  '$currentQuacks Quacks', 
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