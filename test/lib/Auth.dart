import 'package:flutter/material.dart';
import 'package:test/Sign_Up_page/sign_up.dart';
import 'package:test/Sign_in_page/sign_in.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({super.key});

  @override
  State<AuthUser> createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  bool showSignInpage = true;

  void toggleScreen() {
    setState(() {
      showSignInpage = !showSignInpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInpage) {
      return Sign_In_page(showSignUpPage: toggleScreen);
    } else {
      return Sign_up_page(showLoginPage: toggleScreen);
    }
  }
}
