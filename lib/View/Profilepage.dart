import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_kepper/Controller/AuthHelper.dart';
import 'package:flutter/material.dart';
import 'SignInScreen.dart';

class ProfilePage extends StatelessWidget {
  final AuthHelper authHelper=AuthHelper.authHelper;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ?? "https://www.example.com/default-avatar.png"),
            ),
            SizedBox(height: 20),
            Text(
              user?.displayName ?? 'No display name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              user?.email ?? 'No email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthHelper.authHelper.signOutUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}
