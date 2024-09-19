import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/FirestoreHelper.dart';
import 'Homepage.dart';
import '../Controller/AuthHelper.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _createAccountWithEmail() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      bool userExists = await FirestoreHelper.firestoreHelper.checkUserExists(email);

      if (!userExists) {
        User? user = await AuthHelper.authHelper.signUp(email: email, password: password);
        if (user != null) {
          await FirestoreHelper.firestoreHelper.addUsers(email: email);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('user_login', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account created successfully!")),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account creation failed.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account with this email already exists. Please sign in.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and password.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccountWithEmail,
              child: Text('Create Account'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
