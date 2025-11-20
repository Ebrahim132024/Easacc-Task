import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _googleLogin(BuildContext context) async {
    GoogleSignInAccount? user = await GoogleSignIn().signIn();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  Future<void> _facebookLogin(BuildContext context) async {
    final result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _googleLogin(context),
              child: Text("Login with Google"),
            ),
            ElevatedButton(
              onPressed: () => _facebookLogin(context),
              child: Text("Login with Facebook"),
            ),
          ],
        ),
      ),
    );
  }
}
