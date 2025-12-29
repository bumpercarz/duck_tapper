import 'package:flutter/material.dart';
import '../widgets/register_dialog.dart';
import '../services/login_check.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  // Controller Station
  final _usernameController = TextEditingController();
  final _passwordController= TextEditingController();
  bool _passwordHide = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  // Function to toggle the password visibility state.
  void _togglePasswordVisibility() {
    setState(() {
      _passwordHide = !_passwordHide;
    });
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
                width:165,
                height:165,
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

                  // Login Checker (CHANGE URL LATER IN login_check.dart WHEN API IS FIXED)
                  onPressed:() async {
                    bool isAuthenticated = await checkInput(_usernameController.text, _passwordController.text);
                    if (isAuthenticated) {
                      Navigator.pushReplacementNamed(context, '/home'); 
                    } else {
                      // Show an error message (e.g., using a SnackBar or an AlertDialog)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid username or password')),
                      );
                    }
                  },
                  child: Text(
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