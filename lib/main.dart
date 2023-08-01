import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/auth.dart';
import 'package:todo_app/home_page.dart';
import 'login_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
              stream: Auth().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomePage();
                } else {
                  return const LoginSignupPage();
                }
              }),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
