import 'package:duck_tapper/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/duck.dart';
import '../providers/duck_provider.dart';

/// Pop Up Dialog box for Registering a new account
/// - CREATEs an account and directs the new account to Duck Screen (UNIMPLEMENTED)
/// - Validates proper username and password input
class RegisterDialog extends StatefulWidget{
  const RegisterDialog({super.key});

  @override
  _RegisterDialogState createState() => _RegisterDialogState ();
}

class _RegisterDialogState extends State<RegisterDialog>{
  // Create Form State for debugging (prints for console)
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController= TextEditingController();
  
  bool _passwordHide = true;

  // Function to toggle the password visibility state.
  void _togglePasswordVisibility() {
    setState(() {
      _passwordHide = !_passwordHide;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Process data
      final username = _usernameController.text;
      final password = _passwordController.text;
      debugPrint('Registering: $username with password $password');
      

      // CREATE Account (USE API SERVICE)
      final newAccount = Account(
        username: _usernameController.text,
        password: _passwordController.text
      );

      await context.read<AccountProvider>().fetchAccounts();
      await context.read<AccountProvider>().createAccount(newAccount);
      // CREATE Duck with Account
      await context.read<AccountProvider>().fetchAccounts();
      List<Account> accounts = await context.read<AccountProvider>().accounts;
      Account newaccount = accounts[accounts.length-1];

      final newDuck = Duck(
        account_id: (newaccount.id!), 
        currentQuack: 0, 
        duckTaps: 0, 
        totalQuack: 0, 
        moreDucks: 0, 
        fish: 0, 
        watermelon: 0, 
        ponds: 0
      );
      
      await context.read<DuckProvider>().createDuck(newDuck);

      // End with print
      Navigator.of(context).pop({'Username': username});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Stack(
        clipBehavior: Clip.none,
        children:<Widget>[
          Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.rectangle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(color: Colors.black, fontSize: 39)
                ),

                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFA7A7A7),
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(color: Color(0xFF808080)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _passwordHide,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFA7A7A7),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: Color(0xFF808080)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Change the icon based on the state.
                        _passwordHide ? Icons.visibility_off : Icons.visibility,
                        semanticLabel: _passwordHide ? 'Hide password' : 'Show password',
                      ),
                      onPressed: _togglePasswordVisibility, // Call the toggle function on tap.
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed:() => _register(context),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(240, 50),
                    backgroundColor: Color(0xFFCA8C35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                )
              ],
            )
          )
          ),
          // Positioned close button
          Positioned(
            right: 10.0,
            top: 0.0, // Position it at the very top
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('x', style: TextStyle(fontSize: 24, color: Color(0xFF646464)))
            ),
          ),
        ]
      )
    );
  }
}