import 'package:flutter/material.dart';
import '../utils/commons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Password visibility
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    double fieldWidth = Commons.getInputFieldWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field
              _setEmailField(fieldWidth, _emailController),
              const SizedBox(height: 20),

              // Password field
              _setPasswordField(fieldWidth),
              const SizedBox(height: 20),

              // Login button
              _setLoginButton(fieldWidth),

              // Create account
              _createAccount(fieldWidth)
            ],
          ),
        ),
      ),
    );
  }

  // Password field
  Widget _setPasswordField(double fieldWidth) {
    return 
      SizedBox(
        width: fieldWidth, 
        child: TextFormField(
          controller: _passwordController,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
      );
  }

  // Login button
  Widget _setLoginButton(double fieldWidth) {
    return       
      ElevatedButton(
        onPressed: () {
        },
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
  }

  // Create Account filed
  Widget _createAccount(double fieldWidth) {
    return      
      TextButton(
        onPressed: () => print("creat account"),
        //Navigator.push(context,
        //    MaterialPageRoute(builder: (_) => const SignupPage())),
        child: const Text('Create your account'),
      );
  }
}

// Email field
Widget _setEmailField(double fieldWidth, TextEditingController emailController) {
  return 
    SizedBox(
      width: fieldWidth,
      child: TextField(
        controller: emailController, 
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
}