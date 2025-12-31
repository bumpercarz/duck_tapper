import 'package:duck_tapper/providers/duck_provider.dart';
import 'package:duck_tapper/screens/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DuckModel(),
      child: const DuckTapper())
    );
}

class DuckTapper extends StatelessWidget {
  const DuckTapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ducky Quacker',
      theme: ThemeData(
        
        // Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF265490)),
        useMaterial3: true,

        // Default Font for entire app
        fontFamily: 'Chelsea',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),

        // Consistent app bar styling
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        scaffoldBackgroundColor: Color(0xFF265490),
        // Upgrades Card Theme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Landing Page
      home: const NavScreen(),

      // Pages
      routes: {
        '/game': (context) => NavScreen()
      },
    );
  }
}
