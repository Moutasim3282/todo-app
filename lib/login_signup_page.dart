import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/theme/spaces.dart';
import 'package:todo_app/auth.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final userMailController = TextEditingController();
  final userPasswordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: userMailController.text,
          password: userPasswordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: userMailController.text,
          password: userPasswordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Task Hive',
              style: TextStyle(
                  color: Colors.purple.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 27)),
          extraLargeVerticalSizedBox,
          extraLargeVerticalSizedBox,
          Card(
            elevation: 5,
            child: TextField(
              controller: userMailController,
              decoration: const InputDecoration(hintText: 'Gmail'),
            ),
          ),
          Card(
            elevation: 5,
            child: TextField(
              controller: userPasswordController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ),
          largeVerticalSizedBox,
          ElevatedButton(
              onPressed: isLogin
                  ? _signInWithEmailAndPassword
                  : _createUserWithEmailAndPassword,
              child: Text(isLogin ? 'Login' : 'Register')),
          largeVerticalSizedBox,
          TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Register Instead' : 'Login Instead'))
        ],
      ),
    );
  }
}
