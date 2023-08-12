import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Sign_up_page extends StatefulWidget {
  final VoidCallback showLoginPage;
  const Sign_up_page({super.key, required this.showLoginPage});

  @override
  State<Sign_up_page> createState() => _Sign_up_pageState();
}

// ignore: camel_case_types
class _Sign_up_pageState extends State<Sign_up_page> {
  //Variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _re_passwordController = TextEditingController();
  bool _password = true;

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
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
        title: const Text("Sign Up Page"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter your Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              obscureText: _password,
              controller: _passwordController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _password ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _password = !_password;
                      });
                    },
                    color: Colors.red,
                  ),
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              obscureText: _password,
              controller: _re_passwordController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _password ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _password = !_password;
                      });
                    },
                    color: Colors.red,
                  ),
                  hintText: "Enter Conformed password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_emailController.text.isEmpty &&
                  _passwordController.text.isEmpty &&
                  _re_passwordController.text.isEmpty) {
                print("fill all three fileds");
              } else if (_passwordController.text !=
                  _re_passwordController.text) {
                print("password and conformed passwords are not same");
              } else if (_emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _re_passwordController.text.isNotEmpty) {
                setState(() {
                  signUp();
                });
                print("Success");
              }
            },
            child: const Text("Sign Up"),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text("Already Have an Account?"),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
