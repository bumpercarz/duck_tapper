import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import '../widgets/register_dialog.dart';
import '../services/duck_logic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  // Controller Station
  final _usernameController = TextEditingController();
  final _passwordController= TextEditingController();
  bool isLoading = false;
  bool _passwordHide = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

  // Function to toggle the password visibility state.
  void _togglePasswordVisibility() {
    setState(() {
      _passwordHide = !_passwordHide;
    });
  }

  void _login(BuildContext context, String username, String password, List<Account> accounts) {

    // Search for inputted account
    int accountToLog = 0;
    int i = 0;
    while(i < accounts.length){
      if(accounts[i].username == username && accounts[i].password == password) 
      {
        accountToLog = accounts[i].id ?? 0;
        i == accounts.length;
      }
      i++;
    }
    
    // Check value of account to be logged
    if (accountToLog > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged in. Welcome to your duck, $username!')),
      );
      context.read<AccountProvider>().setLoggedAccount(accountToLog);
      
      Provider.of<DuckLogic>(context, listen: false).loadSavedDuck(context, accountToLog);
      Navigator.pushReplacementNamed(context, '/game'); 
    } else {
      // Show an error message (e.g., using a SnackBar or an AlertDialog)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
    
  }
  // Show Register Dialog on tap
  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RegisterDialog();
      },
    );
  }

  // Login UI
  @override
  Widget build(BuildContext context){
    final provider = context.read<AccountProvider>();
    provider.fetchAccounts();

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                margin: EdgeInsets.only(top:100),
                width:80,
                height:80,
                child: Image.asset('assets/images/Duck.png', fit: BoxFit.contain),
              ),

              Text(
                'Ducky Quacker',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 39),
                
              ),

              Container(
                margin: EdgeInsets.only(top:50),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username', style: TextStyle(fontSize: 24)),
                    Container(
                    width: 305,
                    height: 45,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD9D9D9),
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: Color(0xFFA7A7A7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                    )
                  ],
                )
              ),
              
              Container(
                margin: EdgeInsets.only(top:20),
                width: 305,
                height: 45,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _passwordHide,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFD9D9D9),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: Color(0xFFA7A7A7)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHide ? Icons.visibility_off : Icons.visibility,
                        semanticLabel: _passwordHide ? 'Hide password' : 'Show password',
                      ),
                      onPressed: _togglePasswordVisibility, 
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              ),

              Container(
                margin: EdgeInsets.only(top:50),
                child:ElevatedButton(
                  
                  // Login Checker
                  onPressed:(){
                    String username = _usernameController.text;
                    String password = _passwordController.text;  
                    List<Account> accounts = provider.accounts;
                    _login(context, username, password, accounts);
                    },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(240, 50),
                    backgroundColor: Color(0xFFCA8C35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.grey[800],
                    )
                  : Text(
                      'Login',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                )
              ),

              // Register Button - Shows a dialog box that prompts the user for registration. (UNIMPLEMENTED)
              Container(
                margin: EdgeInsets.only(top:20),
                child:ElevatedButton(
                  onPressed: () => _showRegisterDialog(context),
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
              )
            ]
          )
        )
      )
        
    );
  }
}