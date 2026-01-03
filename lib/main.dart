import 'package:duck_tapper/services/duck_logic.dart';

import 'config/environment.dart';
import 'providers/account_provider.dart';
import 'providers/duck_provider.dart';
import 'screens/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

// Provider for duck data
void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Environment.load(env: 'development');
  runApp(const DuckTapper());
}

class DuckTapper extends StatelessWidget {
  const DuckTapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Author state management
        // Access with: context.read<AuthorProvider>() or context.watch<AuthorProvider>()
        ChangeNotifierProvider(create: (_) => AccountProvider()),

        // Book state management
        // Access with: context.read<BookProvider>() or context.watch<BookProvider>()
        ChangeNotifierProvider(create: (_) => DuckProvider()),
        ChangeNotifierProvider(create: (_) => DuckLogic()),
      ],
      child: MaterialApp(
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
        home: const LoginScreen(),

        // Pages
        routes: {
          '/game': (context) => NavScreen()
        },
      )
    );
  }
}
