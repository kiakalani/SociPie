import 'package:flutter/material.dart';
import '../utils/commons.dart';
import './signup_page.dart';

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
  void initState() {
    super.initState();
    Commons.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
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
              _setEmailField(_emailController),
              const SizedBox(height: 20),

              // Password field
              _setPasswordField(),
              const SizedBox(height: 20),

              // Login button
              _setLoginButton(),

              // Create account
              _createAccount()
            ],
          ),
        ),
      ),
    );
  }

  // Password field
  Widget _setPasswordField() {
    return 
      SizedBox(
        width: Commons.fieldWidth, 
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
  Widget _setLoginButton() {
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
  Widget _createAccount() {
    return      
      TextButton(
         onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SignupPage())),
        child: const Text('Create your account'),
      );
  }
}

// Email field
Widget _setEmailField(TextEditingController emailController) {
  return 
    SizedBox(
      width: Commons.fieldWidth,
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