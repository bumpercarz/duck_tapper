import 'dart:math' as math;
import 'package:duck_tapper/services/duck_logic.dart';
import 'package:provider/provider.dart';
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
  @override 
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight= MediaQuery.of(context).size.height;
    int currentQuacks = Provider.of<DuckLogic>(context).currentQuacks;
    int moreDucks = Provider.of<DuckLogic>(context).moreDucks;
    int fish = Provider.of<DuckLogic>(context).fish;
    int watermelon = Provider.of<DuckLogic>(context).watermelon;
    int pond = Provider.of<DuckLogic>(context).pond;
    
    List<int> priceList = [
      (10*math.pow(1.3,moreDucks)).toInt(),
      (250*math.pow(1.3,fish)).toInt(),
      (5000*math.pow(1.3,watermelon)).toInt(),
      (12500*math.pow(1.3,pond)).toInt()
    ];
    
    String exponentPrice (int price){ 
      return 'For ${price.toStringAsExponential(3)} Quacks';
    }

    return Scaffold(
      backgroundColor: Color(0xFF2B1F14),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(83.0),
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
          )
        ),
      body: Column(
          mainAxisAlignment: .start,
          children: [
            Container(
              color: Color(0xFF734014),
              height:51,
              width: .infinity,
              alignment: .center,
              child:Text(
                  '$currentQuacks Quacks',
                  style: TextStyle(fontSize:20)
                )
              ),
            Card(
              color: Color(0xFF66A2B8),
              margin: EdgeInsets.only(top:.010*screenHeight),
              elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: .zero
                ),
              child:  Container(
                height: 0.135*screenHeight,
                alignment: .center,
                child: Padding(
                  padding: EdgeInsets.only(left: .020*screenHeight, right: .010*screenHeight,top: .010*screenHeight,bottom: .010*screenHeight),
                  child:Row(
                    crossAxisAlignment: .start,
                    spacing: 0.02*screenHeight,
                    children: [
                      Center(
                        child: SizedBox(
                        width: .20*screenWidth,
                        height: .090*screenHeight,
                        child: Image.asset('assets/images/Flying Duck.png')
                            )
                      ),
                      SizedBox(
                        width: .44*screenWidth,
                        height: .128*screenHeight,
                        child:  Column(
                          crossAxisAlignment:  .start,
                          children:[
                            Text(
                              'More Ducks', 
                              style: TextStyle(
                                fontSize: 0.024*screenHeight)
                            ),
                            Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              children:[
                                Text(
                                  priceList[0] < 9999
                                    ? 'for ${priceList[0]} Quacks'
                                    : exponentPrice(priceList[0]),
                                  style: TextStyle(
                                    color: Color(0xFFFFD940),
                                    fontSize: .015*screenHeight)
                                ),
                                SizedBox(height:0.005*screenHeight),
                                Text(
                                  'Adds 1 Quack/s per tap per duck',
                                  style: TextStyle(
                                    color: Color(0xFF77EC25),
                                    fontSize: .015*screenHeight)
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                      Column(
                        crossAxisAlignment: .end,
                        children: [
                          Container(
                            alignment: .topRight,
                            width: 0.2*screenWidth,
                            child: Text(
                              'x$moreDucks',
                              style: TextStyle(fontSize:.032*screenHeight)  
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentQuacks >= priceList[0] 
                                ?Color(0xFF7BFF00)
                                : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fixedSize: Size(.2*screenWidth,.068*screenHeight),
                            ),
                            onPressed: currentQuacks >= priceList[0] 
                            ? () => Provider.of<DuckLogic>(context, listen: false).buyMoreDucks(priceList[0])
                            : null,
                            child: Image.asset('assets/images/Shopping Cart.png'),
                          )
                        ],
                      )
                    ],
                  )
                )
              ),
            ),
            moreDucks > 0 ?
            Card(
              color: Color(0xFF66A2B8),
              margin: EdgeInsets.only(top:.010*screenHeight),
              elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: .zero
                ),
              child:  Container(
                height: .135*screenHeight,
                alignment: .center,
                child: Padding(
                  padding: EdgeInsets.only(left: .020*screenHeight, right: .010*screenHeight,top: .010*screenHeight,bottom: .010*screenHeight),
                  child:Row(
                    crossAxisAlignment: .start,
                    spacing: 0.02*screenHeight,
                    children: [
                      Center(
                        child: SizedBox(
                        width: .20*screenWidth,
                        height: .090*screenHeight,
                        child: Image.asset('assets/images/Fish Food.png')
                            )
                      ),
                      SizedBox(
                        width: .44*screenWidth,
                        height: .128*screenHeight,
                        child:  Column(
                          crossAxisAlignment:  .start,
                          children:[
                            Text(
                              'Fish', 
                              style: TextStyle(
                                fontSize: 0.024*screenHeight)
                            ),
                            Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              children:[
                                Text(
                                  priceList[1] < 9999
                                    ? 'for ${priceList[1]} Quacks'
                                    : exponentPrice(priceList[1]),
                                  style: TextStyle(
                                    color: Color(0xFFFFD940),
                                    fontSize: 0.015*screenHeight)
                                ),
                                SizedBox(height:0.005*screenHeight),
                                Text(
                                  'Adds 10 Quack/s per tap per duck',
                                  style: TextStyle(
                                    color: Color(0xFF77EC25),
                                    fontSize: 0.015*screenHeight)
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                      Column(
                        crossAxisAlignment: .end,
                        children: [
                          Container(
                            alignment: .topRight,
                            width: .20*screenWidth,
                            child: Text(
                              'x$fish',
                              style: TextStyle(fontSize:0.032*screenHeight)  
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentQuacks >= priceList[1] 
                                ?Color(0xFF7BFF00)
                                : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fixedSize: Size(.2*screenWidth,.068*screenHeight),
                            ),
                            onPressed: currentQuacks >= priceList[1] 
                            ? () => Provider.of<DuckLogic>(context, listen: false).buyFish(priceList[1])
                            : null,
                            child: Image.asset('assets/images/Shopping Cart.png'),
                          )
                        ],
                      )
                    ],
                  )
                )
              ),
            ) : SizedBox(height: 0),
            fish > 0?
            Card(
              color: Color(0xFF66A2B8),
              margin: EdgeInsets.only(top:.010*screenHeight),
              elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: .zero
                ),
              child:  Container(
                height: .135*screenHeight,
                alignment: .center,
                child: Padding(
                  padding: EdgeInsets.only(left: .020*screenHeight, right: .010*screenHeight,top: .010*screenHeight,bottom: .010*screenHeight),
                  child:Row(
                    crossAxisAlignment: .start,
                    spacing: 0.02*screenHeight,
                    children: [
                      Center(
                        child: SizedBox(
                        width: .20*screenWidth,
                        height: .090*screenHeight,
                        child: Image.asset('assets/images/Watermelon.png')
                            )
                      ),
                      SizedBox(
                        width: .44*screenWidth,
                        height: .128*screenHeight,
                        child:  Column(
                          crossAxisAlignment:  .start,
                          children:[
                            Text(
                              'Watermelon', 
                              style: TextStyle(
                                fontSize: 0.024*screenHeight)
                            ),
                            Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              children:[
                                Text(
                                  priceList[2] < 9999
                                    ? 'for ${priceList[2]} Quacks'
                                    : exponentPrice(priceList[2]),
                                  style: TextStyle(
                                    color: Color(0xFFFFD940),
                                    fontSize: 0.015*screenHeight)
                                ),
                                SizedBox(height:0.005*screenHeight),
                                Text(
                                  'Adds 25 Quack/s per tap per duck',
                                  style: TextStyle(
                                    color: Color(0xFF77EC25),
                                    fontSize: 0.015*screenHeight)
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                      Column(
                        crossAxisAlignment: .end,
                        children: [
                          Container(
                            alignment: .topRight,
                            width: .20*screenWidth,
                            child: Text(
                              'x$watermelon',
                              style: TextStyle(fontSize:0.032*screenHeight)
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentQuacks >= priceList[2] 
                                ?Color(0xFF7BFF00)
                                : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fixedSize: Size(.2*screenWidth,.068*screenHeight),
                            ),
                            onPressed: currentQuacks >= priceList[2] 
                            ? () => Provider.of<DuckLogic>(context, listen: false).buyWatermelon(priceList[2])
                            : null,
                            child: Image.asset('assets/images/Shopping Cart.png'),
                          )
                        ],
                      )
                    ],
                  )
                )
              ),
            ) : SizedBox(height: 0),
            watermelon > 0?
            Card(
              color: Color(0xFF66A2B8),
              margin: EdgeInsets.only(top:.010*screenHeight),
              elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: .zero
                ),
              child:  Container(
                height: .135*screenHeight,
                alignment: .center,
                child: Padding(
                  padding: EdgeInsets.only(left: .020*screenHeight, right: .010*screenHeight,top: .010*screenHeight,bottom: .010*screenHeight),
                  child:Row(
                    crossAxisAlignment: .start,
                    spacing: 0.02*screenHeight,
                    children: [
                      Center(
                        child: SizedBox(
                        width: .20*screenWidth,
                        height: .090*screenHeight,
                        child: Image.asset('assets/images/Lake.png')
                            )
                      ),
                      SizedBox(
                        width: .44*screenWidth,
                        height: .128*screenHeight,
                        child:  Column(
                          crossAxisAlignment:  .start,
                          children:[
                            Text(
                              'Pond', 
                              style: TextStyle(
                                fontSize: 0.024*screenHeight)
                            ),
                            Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              children:[
                                Text(
                                  priceList[3] < 9999
                                    ? 'for ${priceList[3]} Quacks'
                                    : exponentPrice(priceList[3]),
                                  style: TextStyle(
                                    color: Color(0xFFFFD940),
                                    fontSize: 0.015*screenHeight)
                                ),
                                SizedBox(height:0.005*screenHeight),
                                Text(
                                  'Adds 75 Quack/s per tap per duck',
                                  style: TextStyle(
                                    color: Color(0xFF77EC25),
                                    fontSize: 0.015*screenHeight)
                                ),
                              ]
                            )
                          ],
                        )
                      ),
                      Column(
                        crossAxisAlignment: .end,
                        children: [
                          Container(
                            alignment: .topRight,
                            width: .20*screenWidth,
                            child: Text(
                              'x$pond',
                              style: TextStyle(fontSize:0.032*screenHeight)
                            )
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentQuacks >= priceList[3] 
                                ?Color(0xFF7BFF00)
                                : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fixedSize: Size(.2*screenWidth,.068*screenHeight),
                            ),
                            onPressed: currentQuacks >= priceList[3] 
                            ? () => Provider.of<DuckLogic>(context, listen: false).buyPond(priceList[3])
                            : null,
                            child: Image.asset('assets/images/Shopping Cart.png'),
                          )
                        ],
                      )
                    ],
                  )
                )
              ),
            ) : SizedBox(height: 0),
          ],
        ),
    );
  }
}