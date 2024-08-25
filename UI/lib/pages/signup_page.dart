import 'package:flutter/material.dart';
import 'package:view/utils/commons.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();  
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  // Password visibility
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;

  // Password validation
  bool _isPasswordValid = true;

  /// Need to display error message or not
  bool _displayErrorMessage = false;

  @override
  void initState() {
    super.initState();
    Commons.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [   
              // Name field 
              _setNameField(),
              const SizedBox(height: 20),

              // User Name field 
              _setUserNameField(),
              const SizedBox(height: 20),

              // Email field 
              _setEmailField(),
              const SizedBox(height: 20),

              // Password field 
              _setPasswordField(_passwordController, _passwordVisible, "Password", false),
              const SizedBox(height: 20),

              // Repeat Password field 
              _setPasswordField(_repeatPasswordController, _repeatPasswordVisible, "Repeat Password", true),
              const SizedBox(height: 20),

              // Error message display
              if (_displayErrorMessage) 
                _setErrorMessage(''),
                const SizedBox(height: 20),

              // Sign up button
              _setSignupButton()
            ],
          ),
        ),
      ),
    );
  }

  // Name field 
  Widget _setNameField() {
    return 
      SizedBox(
        width: Commons.fieldWidth, 
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
        ),
      );
  }       

  // User Name field 
  Widget _setUserNameField() {
    return 
      SizedBox(
        width: Commons.fieldWidth, 
        child: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'User Name',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.name,
        ),
      );
  }  

  // Email field
  Widget _setEmailField() {
    return 
      SizedBox(
        width: Commons.fieldWidth,
        child: TextField(
          controller: _emailController, 
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      );
  }

  // Password field 
  Widget _setPasswordField(TextEditingController passwordController, bool passwordVisible, String displayText, bool isRepeatPassword) {
    return 
      SizedBox(
        width: Commons.fieldWidth, 
        child: TextFormField(
          controller: passwordController,
          obscureText: !passwordVisible, 
          decoration: InputDecoration(
            labelText: displayText,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isRepeatPassword ?_repeatPasswordVisible = !passwordVisible : _passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
          onChanged: isRepeatPassword ?
            (value) {
              if (value.length < 6 && _isPasswordValid) {
                setState(() => _isPasswordValid = false);
              } else if (value.length >= 6 && !_isPasswordValid) {
                setState(() => _isPasswordValid = true);
              }
            } : null
        ),
      );
  }

  // Error message field 
  Widget _setErrorMessage(String message) {
    return 
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
  }

  // Sign up button
  Widget _setSignupButton() {
    return 
      ElevatedButton(
        onPressed: () {
          /*Authorization().postRequest("/auth/signup/", {
            "email": _emailController.text,
            "name": _nameController.text,
            "username": _usernameController.text,
            "password": _passwordController.text,
            "repeat_password": _repeatPasswordController.text
          }).then((value) => {
            if (value.statusCode == 200) {              
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomePage()))
            }
            else {
              setState(() {
                _displayErrorMessage = true;
              })                        
            }
          });*/
        },
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
  }
}
