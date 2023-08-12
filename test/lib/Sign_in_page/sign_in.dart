import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sign_In_page extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const Sign_In_page({super.key, required this.showSignUpPage});

  @override
  State<Sign_In_page> createState() => _Sign_In_pageState();
}

class _Sign_In_pageState extends State<Sign_In_page> {
  //Variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _password = true;

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in page"),
        backgroundColor: Colors.deepOrangeAccent.shade200,
      ),
      body: Center(
        child: Column(children: [
          // Email Text Felid
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Enter Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          // Password Text Felid
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              obscureText: _password,
              controller: _passwordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon:
                      Icon(_password ? Icons.visibility_off : Icons.visibility),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _password = !_password;
                    });
                  },
                ),
                hintText: "Enter Your Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Button
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty) {
                setState(() async {
                  signIn();
                });
                print("success");
              } else {
                print('Please enter both fields');
              }
            },
            child: const Text("Login"),
          ),
          Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Text("Don't Have an Account?"),
                  GestureDetector(
                    onTap: widget.showSignUpPage,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}
