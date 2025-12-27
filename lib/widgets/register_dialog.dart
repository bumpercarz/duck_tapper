import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Process data
      final username = _usernameController.text;
      final password = _passwordController.text;
      debugPrint('Registering: $username with password $password');
      

      // CREATE Account IN AccountTable (USE API SERVICE)

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
                  onPressed: _register,
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